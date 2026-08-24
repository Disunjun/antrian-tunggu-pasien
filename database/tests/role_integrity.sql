-- Run after migrations 001-009.
-- Valid cases must commit; invalid cases must fail and be rolled back.
-- See docs/FOUNDATION-V1-REVIEW-2.md for the test matrix.

BEGIN;
INSERT INTO users(role, phone) VALUES ('PATIENT', '081000000001') RETURNING id;
-- Create patient profile using the returned id; COMMIT should succeed.
ROLLBACK;

BEGIN;
INSERT INTO users(role, phone) VALUES ('STAFF', '081000000002') RETURNING id;
-- INSERT INTO patients(user_id, full_name) using the returned id MUST FAIL.
ROLLBACK;

BEGIN;
INSERT INTO users(role, phone) VALUES ('PATIENT', '081000000003') RETURNING id;
-- Create patient profile, then UPDATE users SET role='DOCTOR' ... MUST FAIL.
ROLLBACK;
