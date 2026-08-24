CREATE TABLE staff_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id uuid NOT NULL REFERENCES staff(id) ON DELETE CASCADE,
  clinic_id uuid NOT NULL REFERENCES clinics(id) ON DELETE RESTRICT,
  polyclinic_id uuid,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT staff_assignment_polyclinic_fk
    FOREIGN KEY (clinic_id, polyclinic_id)
    REFERENCES polyclinics(clinic_id, id)
    ON DELETE RESTRICT
);

CREATE UNIQUE INDEX staff_assignment_unique
  ON staff_assignments(staff_id, clinic_id, COALESCE(polyclinic_id, '00000000-0000-0000-0000-000000000000'::uuid));

CREATE TABLE doctor_polyclinics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  doctor_id uuid NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
  clinic_id uuid NOT NULL REFERENCES clinics(id) ON DELETE RESTRICT,
  polyclinic_id uuid NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT doctor_polyclinic_fk
    FOREIGN KEY (clinic_id, polyclinic_id)
    REFERENCES polyclinics(clinic_id, id)
    ON DELETE RESTRICT,
  UNIQUE (doctor_id, polyclinic_id)
);

CREATE TABLE admin_clinic_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  clinic_id uuid NOT NULL REFERENCES clinics(id) ON DELETE RESTRICT,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, clinic_id)
);
