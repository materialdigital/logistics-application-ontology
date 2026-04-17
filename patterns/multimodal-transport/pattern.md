# Pattern: Multimodal Transport

## Purpose
Model a shipment transported via two sequential transport legs — sea freight from origin port to intermediate port, then road transport to final destination — linked through a supply chain node at the port of transfer.

## Entities
- **Shipment** (`LOG:LOG_1000051`) — the goods being moved across both legs
- **Sea transport process** (`LOG:LOG_1000143`) — first leg (ship)
- **Road transport process** (`LOG:LOG_1000143`) — second leg (truck)
- **Supply chain node** (`LOG:LOG_1000090`) — the intermediate port acting as handoff point
- **Ship-from location** (`LOG:LOG_1000088`) — origin port
- **Ship-to location** (`LOG:LOG_1000089`) — final delivery location
- **Seaway** (`LOG:LOG_1000100`) — route of sea leg
- **Carrier role** (`LOG:LOG_1000021`) — role held by shipping line / trucking company
- **Material product** (`LOG:LOG_1000029`) — the cargo across both legs

## Key properties
- `BFO:0000066` (occurs in) — each transport leg occurs in its origin and destination locations
- `RO:0000057` (has participant) — transport process has participant: shipment, carrier
- `BFO:0000062` (preceded by) — road leg is preceded by sea leg (temporal ordering)
- `BFO:0000196` (bearer of) — supply chain node bears supply chain node role

## Notes
The supply chain node (`LOG:LOG_1000090`) at the transfer port is the geospatial site that is both the ship-to of the sea leg and the ship-from of the road leg. This models the handoff point in a multimodal chain.
