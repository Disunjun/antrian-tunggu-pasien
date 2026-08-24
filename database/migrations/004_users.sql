CREATE TYPE user_role AS ENUM ('PATIENT', 'STAFF', 'DOCTOR', 'ADMIN');

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  role user_role NOT NULL,
  phone text,
  email text,
  password_hash text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT users_contact_unique CHECK (phone IS NOT NULL OR email IS NOT NULL)
);

CREATE UNIQUE INDEX users_phone_unique ON users(phone) WHERE phone IS NOT NULL;
CREATE UNIQUE INDEX users_email_unique ON users(lower(email)) WHERE email IS NOT NULL;
