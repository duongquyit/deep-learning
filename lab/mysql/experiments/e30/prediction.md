# E30 — prediction

Write this before running anything. Topic: [transactional outbox](../../../../topics/transactional-outbox/index.html), section 05.

Setup: `orders`, `outbox`, and a stand-in broker (a `received_events` table in a
separate schema reached over its own connection, or an HTTP endpoint that logs).
A Node script creates 1,000 orders with each of the four designs in the table of
section 01. Between the two steps it kills the process with probability 5%
(a supervisor restarts it); the broker rejects 2% of sends; 1% of commits are
forced to fail. Reconcile with a join between `orders` and the received events.

For each design: orders without an event, events without an order, duplicated events.

1. Commit order, then send
   TODO
2. Send, then commit order
   TODO
3. Send inside the transaction
   TODO
4. Outbox with a polling relay
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
