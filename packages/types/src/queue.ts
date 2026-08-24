export const QUEUE_STATUSES = [
  "WAITING",
  "CALLED",
  "IN_SERVICE",
  "DONE",
  "SKIPPED",
  "CANCELLED"
] as const;

export type QueueStatus = typeof QUEUE_STATUSES[number];

export type UserRole = "PATIENT" | "STAFF" | "DOCTOR" | "ADMIN";
