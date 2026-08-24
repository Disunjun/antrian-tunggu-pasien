import type { QueueStatus } from "./queue.js";

const TERMINAL_STATES: ReadonlySet<QueueStatus> = new Set([
  "DONE",
  "CANCELLED",
]);

const ALLOWED_TRANSITIONS: Readonly<Record<QueueStatus, readonly QueueStatus[]>> = {
  WAITING: ["CALLED", "CANCELLED"],
  CALLED: ["IN_SERVICE", "SKIPPED", "CANCELLED"],
  IN_SERVICE: ["DONE", "CANCELLED"],
  DONE: [],
  SKIPPED: [],
  CANCELLED: [],
};

export function canTransition(
  from: QueueStatus,
  to: QueueStatus,
): boolean {
  return ALLOWED_TRANSITIONS[from].includes(to);
}

export function isTerminalState(
  status: QueueStatus,
): boolean {
  return TERMINAL_STATES.has(status);
}

export function assertValidTransition(
  from: QueueStatus,
  to: QueueStatus,
): void {
  if (!canTransition(from, to)) {
    throw new Error(
      `Invalid queue transition: ${from} -> ${to}`,
    );
  }
}
