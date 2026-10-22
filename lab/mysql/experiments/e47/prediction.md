# E47 — prediction

Write this before running anything. Topic: [NestJS request lifecycle](../../../../topics/nestjs-request-lifecycle/index.html), section 05.

Setup: `GET /accounts/:id` through controller, service and repository, MySQL 8.4,
one Node 22 process. Three builds: (a) everything singleton; (b) `TenantContext`
with `Scope.REQUEST` injected into the repository; (c) `TenantContext` singleton
reading from `AsyncLocalStorage`. Open-loop load with k6 or autocannon, 60 s per
rate, at 500, 2,000 and 5,000 requests per second.

1. Maximum requests per second for each build
   TODO
2. p50 and p99 at each rate for each build
   TODO
3. Constructor calls per request in (b), and GC time per second in (a) vs (b)
   TODO
4. At what rate does (b) start to fall behind (a) by more than 10% in p99?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
