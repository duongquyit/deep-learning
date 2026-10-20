# E37 — prediction

Write this before running anything. Topic: [capacity estimation](../../../../topics/capacity-estimation/index.html), section 05.

Setup: a primary-key read endpoint (or a direct `SELECT` by id) driven at a
fixed arrival rate (open loop, e.g. k6 `constant-arrival-rate`). First find the
maximum sustainable rate, then run 2 minutes each at 20%, 50%, 70%, 85% and 95%
of it. Sample `Threads_running` every second.

1. p50 and p99 at each level
   TODO
2. Average `Threads_running` at each level, and λ × W computed from the measured latency: do they agree?
   TODO
3. From which level does p99 double compared with 20%? Does the curve look like M/M/1 on the page? (open question 29)
   TODO
4. What happens at 95% over the 2 minutes: steady or growing latency?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
