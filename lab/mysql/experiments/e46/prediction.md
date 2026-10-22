# E46 — prediction

Write this before running anything. Topic: [NestJS request lifecycle](../../../../topics/nestjs-request-lifecycle/index.html), section 05.

Setup: a NestJS 12 app on Node 22 with Express. One middleware, a global guard
and a route guard, interceptors at global, controller and route level, a global
`ValidationPipe`, a route filter `@Catch(DomainError)` and a global `@Catch()`
filter. Every layer logs one line on the way in and one on the way out.

1. For each case, which lines are printed and in which order: success; the global guard returns `false`; the guard throws `UnauthorizedException`; `amountMinor = "abc"`; the service throws `InsufficientFundsError` with the route filter removed; the same with the route filter; a body with a trailing comma (broken JSON)
   TODO
2. Status code and exact body of each response
   TODO
3. Does the global `@Catch()` filter see the broken-JSON error? Does any interceptor?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
