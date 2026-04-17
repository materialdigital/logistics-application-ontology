# Pattern: Warehouse Receiving

## Purpose
Model goods arriving at a storage facility, triggering a receiving process that executes a warehousing plan, and the subsequent storage process.

## Entities
- **Material product** (`LOG:LOG_1000029`) — the incoming goods
- **Shipment** (`LOG:LOG_1000051`) — the shipment being received
- **Receiving process** (`LOG:LOG_1000124`) — the process of accepting incoming goods
- **Warehousing process** (`LOG:LOG_1000129`) — the process of storing goods
- **Warehousing plan specification** (`LOG:LOG_1000098`) — the plan governing the warehousing
- **Storage facility** (`LOG:LOG_1000034`) — the physical premises where goods are received and stored
- **Storage service provider role** (`LOG:LOG_1000069`) — role held by the organization operating the facility
- **Ship-to location** (`LOG:LOG_1000089`) — geospatial site of the storage facility

## Key properties
- `BFO:0000066` (occurs in) — processes occur in the storage facility location
- `RO:0002233` (has input) — receiving process has input: the shipment
- `RO:0002234` (has output) — receiving process has output: stored goods
- `RO:0000059` (concretizes) — warehousing process is prescribed by plan specification
- `BFO:0000050` (part of) — storage facility is part of physical premises

## Notes
The storage facility (`LOG:LOG_1000034`) is a subclass of physical premises (`LOG:LOG_1000146`) which is aligned to `org:Site`. The warehousing plan specification (`LOG:LOG_1000098`) prescribes the warehousing process, following the BFO planned process pattern.
