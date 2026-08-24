import test from "node:test";
import assert from "node:assert/strict";

import {
  canTransition,
  isTerminalState,
  assertValidTransition,
} from "./queue-lifecycle.js";

test("allows the locked V1 queue lifecycle", () => {
  assert.equal(canTransition("WAITING", "CALLED"), true);
  assert.equal(canTransition("CALLED", "IN_SERVICE"), true);
  assert.equal(canTransition("IN_SERVICE", "DONE"), true);
  assert.equal(canTransition("WAITING", "CANCELLED"), true);
});

test("rejects returning terminal states to WAITING", () => {
  assert.equal(canTransition("DONE", "WAITING"), false);
  assert.equal(canTransition("CANCELLED", "WAITING"), false);
});

test("rejects invalid lifecycle transitions", () => {
  assert.equal(canTransition("WAITING", "DONE"), false);
  assert.equal(canTransition("CALLED", "DONE"), false);
  assert.equal(canTransition("DONE", "CALLED"), false);
});

test("identifies terminal states", () => {
  assert.equal(isTerminalState("DONE"), true);
  assert.equal(isTerminalState("CANCELLED"), true);
  assert.equal(isTerminalState("WAITING"), false);
  assert.equal(isTerminalState("IN_SERVICE"), false);
});

test("throws for invalid transitions", () => {
  assert.throws(
    () => assertValidTransition("DONE", "WAITING"),
    /Invalid queue transition/,
  );
});
