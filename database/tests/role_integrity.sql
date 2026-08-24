BEGIN;

INSERT INTO clinics (code, name)
VALUES ('TST', 'Test Clinic')
RETURNING id \gset

INSERT INTO users (role, phone)
VALUES ('PATIENT', '081000000001')
RETURNING id \gset patient_

INSERT INTO patients (user_id, full_name)
VALUES (:'patient_id', 'Valid Patient');

SET CONSTRAINTS ALL IMMEDIATE;

INSERT INTO users (role, phone)
VALUES ('STAFF', '081000000002')
RETURNING id \gset staff_

DO $$
BEGIN
  BEGIN
    INSERT INTO patients (user_id, full_name)
    SELECT id, 'Invalid Patient'
    FROM users
    WHERE phone = '081000000002';

    RAISE EXCEPTION
      'TEST FAILED: STAFF user accepted by patients profile';
  EXCEPTION
    WHEN SQLSTATE '23514' THEN
      NULL;
  END;
END $$;

INSERT INTO staff (user_id, display_name)
VALUES (:'staff_id', 'Valid Staff');

DO $$
BEGIN
  BEGIN
    UPDATE users
    SET role = 'DOCTOR'
    WHERE phone = '081000000002';

    RAISE EXCEPTION
      'TEST FAILED: role change bypassed staff profile guard';
  EXCEPTION
    WHEN SQLSTATE '23514' THEN
      NULL;
  END;
END $$;

INSERT INTO users (role, email)
VALUES ('ADMIN', 'admin@test.invalid')
RETURNING id \gset admin_

INSERT INTO admin_clinic_assignments (user_id, clinic_id)
VALUES (:'admin_id', :'id');

DO $$
BEGIN
  BEGIN
    INSERT INTO admin_clinic_assignments (user_id, clinic_id)
    SELECT u.id, c.id
    FROM users u
    CROSS JOIN clinics c
    WHERE u.phone = '081000000001'
      AND c.code = 'TST';

    RAISE EXCEPTION
      'TEST FAILED: non-ADMIN accepted by admin assignment';
  EXCEPTION
    WHEN SQLSTATE '23514' THEN
      NULL;
  END;
END $$;

ROLLBACK;

SELECT 'role integrity tests passed' AS result;
