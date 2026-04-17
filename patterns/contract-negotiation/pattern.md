# Pattern: Contract Negotiation

[Visualize example data](https://thhanke.github.io/visgraph/?rdfUrl=https://raw.githubusercontent.com/materialdigital/logistics-application-ontology/refs/heads/main/patterns/contract-negotiation/shape-data.ttl)

## Purpose
Model a commercial service agreement negotiated and signed by persons acting in organizational roles, representing their respective companies as buyer and supplier.

## Entities
- **Commercial service agreement** (`LOG:LOG_1000001`) — the contract (information content entity)
- **Selling business process** (`LOG:LOG_1000125`) — the process in which the contract is negotiated and executed
- **Buying business process** (`LOG:LOG_1000111`) — the complementary buying process
- **Person** (`foaf:Person`) — individual negotiators
- **Business organization** (`LOG:LOG_1000047`) — the companies party to the contract
- **Buyer role** (`LOG:LOG_1000055`) — role held by the buying organization / person
- **Supplier role** (`LOG:LOG_1000063`) — role held by the supplying organization / person
- **org:Membership** — links a person to their role within an organization
- **org:Post** — formal position in an organization grounding the person's authority to act

## Key properties
- `BFO:0000196` (bearer of) — organization/person bears a role
- `org:memberOf` — person is member of organization
- `org:holds` — person holds a post
- `org:postIn` — post is in an organization
- `IAO:0000136` (is about) — contract is about the commercial service
- `RO:0000057` (has participant) — process has participant (organizations)

## Notes
The contract bridges two organizational actors. Each actor is an organization bearing a supply-chain role. Persons hold org:Post instances grounding their authority, connecting foaf:Person through W3C ORG to BFO roles.
