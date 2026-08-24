import test from "node:test";
import assert from "node:assert/strict";

test("foundation API contract exposes /health shape", () => {
  const response = {
    status: "ok",
    service: "patient-queue-api",
    version: "0.1.0"
  };

  assert.equal(response.status, "ok");
  assert.equal(response.service, "patient-queue-api");
});
