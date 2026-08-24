import test from "node:test";
import assert from "node:assert/strict";
import { QUEUE_STATUSES } from "./queue.js";

test("queue states contain the locked V1 lifecycle", () => {
  assert.deepEqual(QUEUE_STATUSES, [
    "WAITING",
    "CALLED",
    "IN_SERVICE",
    "DONE",
    "SKIPPED",
    "CANCELLED"
  ]);
});
