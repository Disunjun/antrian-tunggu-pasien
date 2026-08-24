-- Enforce role/profile consistency at the database boundary.
-- Cross-table invariants are implemented with deferred constraint triggers.

CREATE OR REPLACE FUNCTION enforce_user_profile_role()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  expected_role user_role;
BEGIN
  expected_role := CASE TG_TABLE_NAME
    WHEN 'patients' THEN 'PATIENT'::user_role
    WHEN 'staff' THEN 'STAFF'::user_role
    WHEN 'doctors' THEN 'DOCTOR'::user_role
    ELSE NULL
  END;

  IF expected_role IS NULL THEN
    RETURN NEW;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM users u
    WHERE u.id = NEW.user_id
      AND u.role = expected_role
  ) THEN
    RAISE EXCEPTION 'user % must have role % for profile %', NEW.user_id, expected_role, TG_TABLE_NAME
      USING ERRCODE = '23514';
  END IF;

  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER patients_user_role_guard AFTER INSERT OR UPDATE OF user_id ON patients DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION enforce_user_profile_role();
CREATE CONSTRAINT TRIGGER staff_user_role_guard AFTER INSERT OR UPDATE OF user_id ON staff DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION enforce_user_profile_role();
CREATE CONSTRAINT TRIGGER doctors_user_role_guard AFTER INSERT OR UPDATE OF user_id ON doctors DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION enforce_user_profile_role();

CREATE OR REPLACE FUNCTION enforce_assignment_role()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE actual_role user_role;
BEGIN
  IF TG_TABLE_NAME = 'admin_clinic_assignments' THEN
    SELECT role INTO actual_role FROM users WHERE id = NEW.user_id;
    IF actual_role IS DISTINCT FROM 'ADMIN'::user_role THEN
      RAISE EXCEPTION 'user % must have ADMIN role for admin clinic assignment', NEW.user_id USING ERRCODE = '23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER admin_assignment_role_guard AFTER INSERT OR UPDATE OF user_id ON admin_clinic_assignments DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION enforce_assignment_role();

CREATE OR REPLACE FUNCTION prevent_incompatible_role_change()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.role IS NOT DISTINCT FROM OLD.role THEN RETURN NEW; END IF;
  IF NEW.role <> 'PATIENT'::user_role AND EXISTS (SELECT 1 FROM patients WHERE user_id = NEW.id) THEN RAISE EXCEPTION 'cannot change user % from PATIENT while patient profile exists', NEW.id USING ERRCODE = '23514'; END IF;
  IF NEW.role <> 'STAFF'::user_role AND EXISTS (SELECT 1 FROM staff WHERE user_id = NEW.id) THEN RAISE EXCEPTION 'cannot change user % from STAFF while staff profile exists', NEW.id USING ERRCODE = '23514'; END IF;
  IF NEW.role <> 'DOCTOR'::user_role AND EXISTS (SELECT 1 FROM doctors WHERE user_id = NEW.id) THEN RAISE EXCEPTION 'cannot change user % from DOCTOR while doctor profile exists', NEW.id USING ERRCODE = '23514'; END IF;
  IF NEW.role <> 'ADMIN'::user_role AND EXISTS (SELECT 1 FROM admin_clinic_assignments WHERE user_id = NEW.id) THEN RAISE EXCEPTION 'cannot change user % from ADMIN while admin assignments exist', NEW.id USING ERRCODE = '23514'; END IF;
  RETURN NEW;
END;
$$;

CREATE CONSTRAINT TRIGGER users_role_change_guard AFTER UPDATE OF role ON users DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION prevent_incompatible_role_change();
