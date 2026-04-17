# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0] - 2026-04-17

### First release

The PMD Logistics Application Ontology (LOG) is a BFO- and IOF-conformant ontology
for logistics and supply chain management in the materials science and engineering domain.

#### Origin

LOG originates from a need to model logistics and supply chain processes within the
[Platform MaterialDigital (PMD)](https://www.materialdigital.de/) ecosystem in a way
that is interoperable with existing PMD ontologies and compatible with industrial standards.
The ontology was developed at Fraunhofer IWM and adopts the
[IOF Supply Chain Module](https://spec.industrialontologies.org/ontology/supplychain/Metadatasupplychain/supplychainModule)
as its primary source, extending and aligning it to the
[PMD Core Ontology (PMDCo)](https://w3id.org/pmd/co) 3.0.0.
Development was supported by the PMD-X project EDCar (Förderkennzeichen: 13XPM504B).

#### What it covers

- **Organizations and roles** — business organizations, suppliers, manufacturers, carriers,
  freight forwarders and their BFO-aligned roles; integrated with W3C ORG vocabulary
- **Persons** — modeled via FOAF, linked to organizations through `org:Membership` and `org:Post`
- **Locations and premises** — physical premises, geospatial sites with WGS84 coordinates,
  ship-from/ship-to locations, supply chain nodes
- **Shipments and cargo** — shipment, load, cargo, lot, traceable resource unit,
  bill of lading, purchase order
- **Transport** — transport process, seaway, airway, shipping route, multimodal chains
- **Facilities** — facility, storage facility, distribution center, warehouse
- **Agreements** — commercial service agreement, bill of lading, framework contracts
- **Processes** — transport, receiving, warehousing, packaging, procurement, selling,
  manufacturing, supply chain processes
- **Plan specifications** — shipment plan, warehousing plan, supply chain plan

#### Usage patterns (SHACL-validated)

Four real-world usage patterns with annotated example data are included,
each validated with [pyshacl](https://github.com/RDFLib/pySHACL):

| Pattern | Scenario |
|---------|----------|
| [Shipment by Sea](patterns/shipment-by-sea/) | Steel coil shipment Baosteel → Volkswagen via COSCO |
| [Contract Negotiation](patterns/contract-negotiation/) | Annual steel supply framework agreement |
| [Warehouse Receiving](patterns/warehouse-receiving/) | Steel coils received at DB Schenker Hamburg |
| [Multimodal Transport](patterns/multimodal-transport/) | Multi-leg transport chain |

#### Ontology artifacts

| File | Description |
|------|-------------|
| `log.owl` / `log.ttl` | Full ontology with all imports merged |
| `log-base.owl` / `log-base.ttl` | Base ontology without imports |
| `log-simple.owl` / `log-simple.ttl` | Simplified profile |
| `log-full.owl` / `log-full.ttl` | Full reasoned version |
