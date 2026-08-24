# Foundation V1

## Locked principles
- `main` is stable.
- Development happens on `foundation-v1`.
- UUIDs are internal identifiers.
- Patient access is ownership-scoped.
- Staff/Doctor access is clinic/polyclinic scoped.
- Database integrity is enforced with FK, UNIQUE and CHECK constraints.
- Queue logic is intentionally not implemented in this foundation checkpoint.

## Validation gate
1. Fresh database migration.
2. Typecheck/build.
3. API `/health`.
4. Constraint tests.
5. RBAC/scope tests in the next checkpoint.
