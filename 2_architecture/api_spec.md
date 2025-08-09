# API Spec (Draft)

## Events Ingestion
`POST /v1/events` — accepts signed HCS events for relaying & indexing

## Query
`GET /v1/edges/:id` — returns anonymized edge weights by tag
`GET /v1/me/slots` — returns slot bitmap + cooldowns

## Admin/Research
`GET /v1/checkpoints/latest` — Merkle root + schema hash
