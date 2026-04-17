# Pattern: Shipment by Sea

[Visualize example data](https://thhanke.github.io/visgraph/?rdfUrl=https://raw.githubusercontent.com/materialdigital/logistics-application-ontology/refs/heads/main/patterns/shipment-by-sea/shape-data.ttl)

## Purpose
Model a material product shipment from a supplier to a producer via sea transport, including geospatial ship-from and ship-to locations and a bill of lading.

## Entities
- **Shipment** (`LOG:LOG_1000051`) — the shipment object aggregate
- **Material product** (`LOG:LOG_1000029`) — the goods being shipped, bearing a cargo role
- **Supplier** (`LOG:LOG_1000020`) — the organization holding the supplier role
- **Producer / Manufacturer** (`LOG:LOG_1000047`) — the receiving business organization
- **Transport process** (`LOG:LOG_1000143`) — the sea transport process
- **Seaway** (`LOG:LOG_1000100`) — the route used
- **Ship-from location** (`LOG:LOG_1000088`) — geospatial site bearing the ship-from location role
- **Ship-to location** (`LOG:LOG_1000089`) — geospatial site bearing the ship-to location role
- **Bill of lading** (`LOG:LOG_1000002`) — the transport document (information content entity)
- **Consignor role** (`LOG:LOG_1000057`) — role of the supplier in this shipment
- **Consignee role** (`LOG:LOG_1000056`) — role of the producer in this shipment

## Key properties
- `BFO:0000196` (bearer of) — links agent to role
- `BFO:0000055` (realizes) — transport process realizes the carrier role
- `RO:0000057` (has participant) — process has participant
- `RO:0002233` (has input) — process has input
- `RO:0002234` (has output) — process has output
- `BFO:0000066` (occurs in) — process occurs in location

## Notes
The ship-from and ship-to locations are `PMD:PMD_0040029` (geospatial site, BFO:0000029) bearing location roles. The bill of lading is about (`IAO:0000136`) the shipment.
