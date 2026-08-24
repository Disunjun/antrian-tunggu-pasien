# F3 — Domain Foundation

## 1. Purpose

F3 establishes the domain foundation of the Antrian Tunggu Pasien system.

The objective is to define the core domain concepts, responsibilities, relationships, and invariants before implementing higher-level application features.

F3 does not define UI behavior or deployment configuration.

---

## 2. Domain Scope

The system manages patient queueing and service flow.

The domain foundation covers:

- Patient
- Queue Ticket
- Queue
- Service
- Service Point
- Queue Status
- User Role

The domain must remain independent from presentation and infrastructure concerns.

---

## 3. Core Domain Concepts

### 3.1 Patient

A Patient represents a person receiving healthcare service.

A patient may have:

- identity information
- contact information
- registration information

A patient is not itself a queue ticket.

---

### 3.2 Queue Ticket

A Queue Ticket represents a patient's position in a service queue.

A queue ticket belongs to:

- one patient
- one queue/service context

A queue ticket has a lifecycle represented by its status.

---

### 3.3 Queue

A Queue represents an ordered collection of queue tickets for a defined service flow.

A queue is responsible for:

- ordering waiting tickets
- identifying the next eligible ticket
- maintaining queue flow

Queue ordering must not depend on UI state.

---

### 3.4 Service

A Service represents a type of service that can be requested by a patient.

Examples may include:

- registration
- consultation
- pharmacy
- other configured healthcare services

Services are domain configuration and must not be hard-coded into the UI.

---

### 3.5 Service Point

A Service Point represents a location or operational point where a service can be performed.

A service point may process queue tickets according to its configured service.

---

## 4. Queue Ticket Lifecycle

A queue ticket follows a controlled lifecycle.

Initial state:

`WAITING`

Possible progression:

`WAITING -> CALLED -> SERVING -> COMPLETED`

Alternative terminal state:

`WAITING -> CANCELLED`

A ticket that has reached a terminal state must not return to an active waiting state without an explicit domain operation.

Terminal states:

- `COMPLETED`
- `CANCELLED`

---

## 5. Queue Invariants

The following invariants must be preserved:

1. A queue ticket belongs to exactly one patient.
2. A queue ticket belongs to one defined queue/service context.
3. Queue order must be deterministic.
4. Only eligible waiting tickets may be called.
5. A completed ticket cannot become waiting again through a normal transition.
6. A cancelled ticket cannot become waiting again through a normal transition.
7. Queue state must not be derived from presentation-layer state.
8. Domain rules must be enforceable independently from the UI.

---

## 6. Roles

The system may contain operational roles.

### Patient

A patient can:

- register for a service
- obtain a queue ticket
- view their queue status

### Staff

Staff can:

- manage queue flow
- call the next eligible ticket
- process a ticket
- complete or cancel a ticket according to domain rules

### Administrator

Administrator responsibilities may include:

- managing services
- managing service points
- managing operational configuration
- managing authorized users

Role authorization is an application/security concern and must not be confused with the domain entity itself.

---

## 7. Domain Boundaries

The domain layer owns:

- queue rules
- ticket lifecycle
- queue ordering rules
- service relationships
- domain invariants

The domain layer does not own:

- React components
- browser state
- HTTP transport
- database-specific queries
- authentication provider implementation
- deployment configuration

Infrastructure may persist domain data, but persistence must not redefine domain behavior.

---

## 8. Data Ownership

The following ownership model is established:

```text
Patient
   |
   +---- Queue Ticket
             |
             +---- Queue
             |
             +---- Service
             |
             +---- Service Point
