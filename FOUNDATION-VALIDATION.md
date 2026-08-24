# Foundation V1 — Validation Patch 3

This patch adds the first repeatable CI validation gate.

## Checks
- Node/TypeScript workspace typecheck
- Fresh PostgreSQL service
- Sequential migrations 001..009
- Database role-integrity tests
- API unit tests

## Important
The GitHub branch remains `foundation-v1`. Do not merge into `main` until this workflow passes and the migration review is complete.
