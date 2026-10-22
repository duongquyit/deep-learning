# E50 — prediction

Write this before running anything. Topic: [Validation and error contracts](../../../../topics/validation-error-contracts/index.html), section 05.

Setup: the Month 2 NestJS 12 app on Node 22, `POST /transfers` with `TransferDto`
and `GET /transfers` with `ListDto` as on the page. The handler responds with
each field's value and `typeof`. Restart the app for each combination of
`whitelist`, `forbidNonWhitelisted`, `transform`, `enableImplicitConversion`.

1. For the 7 payloads × 16 combinations of the page's widget, sent over HTTP: same status, body and handler values as the widget (which called the pipe directly)? Which differ, and why?
   TODO
2. `@Query('page') page: number` with `transform: true` and `?page=abc`, `?page=`: what does the handler receive?
   TODO
3. Body that is a JSON array instead of an object: status and message
   TODO
4. A body with an array of 10,000 nested items (each with a `@ValidateNested` DTO): validation time, event-loop delay, and response size when every item is invalid (open question 41)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
