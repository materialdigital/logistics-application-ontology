
![Build Status](https://github.com/materialdigital/logistics-application-ontology/actions/workflows/qc.yml/badge.svg)
[![DOI](https://zenodo.org/badge/1046227251.svg)](https://doi.org/10.5281/zenodo.19629236)

# Platform Material Digital — Logistics Application Ontology (LOG)

The PMD Logistics Application Ontology (LOG) is a BFO- and IOF-conformant ontology for logistics and supply chain management. It extends the [PMD Core Ontology (PMDCo)](https://w3id.org/pmd/co) and is adopted from the [IOF Supply Chain Module](https://spec.industrialontologies.org/ontology/supplychain/Metadatasupplychain/supplychainModule).

More information: **https://w3id.org/pmd/log/**

---

## Contents

- [Scope](#scope)
- [Imports](#imports)
- [Key Classes](#key-classes)
- [Usage Patterns](#usage-patterns)
- [Versions](#versions)
- [Development](#development)
- [Contact](#contact)

---

## Scope

LOG covers the following domains:

- **Organizations and roles** — business organizations, suppliers, manufacturers, carriers, freight forwarders and their BFO-aligned roles; integrated with [W3C ORG vocabulary](https://www.w3.org/TR/vocab-org/) for membership, posts, and sites
- **Persons** — modeled via [FOAF](http://xmlns.com/foaf/0.1/) (`foaf:Person`), linked to organizations through `org:Membership` and `org:Post`
- **Physical premises and locations** — `LOG:LOG_1000146` (physical premises, BFO object aggregate) aligned to `org:Site`; geospatial sites (`PMD:PMD_0040029`, BFO:0000029) for spatial modeling; ship-from/ship-to locations with WGS84 coordinates
- **Shipments and cargo** — shipment, load, cargo, lot, traceable resource unit, bill of lading, purchase order
- **Transport** — transport process, seaway, airway, shipping route, multimodal chains via supply chain nodes
- **Facilities** — facility, storage facility, distribution center, warehouse; subclassing `LOG:LOG_1000146 → org:Site`
- **Agreements and contracts** — commercial service agreement, bill of lading, purchase order, framework contracts
- **Processes** — transport, receiving, warehousing, packaging, procurement, selling, manufacturing, supply chain processes
- **Business functions** — freight forwarding, transportation, logistics service, manufacturing service
- **Plan specifications** — shipment plan, warehousing plan, supply chain plan, packaging plan

---

## Imports

| Import | Type | Source |
|--------|------|--------|
| `pmdco` | mirror | [PMD Core Ontology 3.0.0](https://w3id.org/pmd/co/3.0.0) |
| `org` | SLME | [W3C Organization Ontology](https://www.w3.org/ns/org) |
| `foaf` | custom | [FOAF Vocabulary](http://xmlns.com/foaf/0.1/) — with OWL DL violation fix removing `schema:Person`/`contact:Person` equivalencies |

---

## Key Classes

| IRI | Label | BFO alignment |
|-----|-------|---------------|
| `LOG:LOG_1000047` | business organization | `BFO:0000027`, `org:FormalOrganization` |
| `LOG:LOG_1000050` | organization | `BFO:0000027`, `org:FormalOrganization` |
| `LOG:LOG_1000146` | physical premises | `BFO:0000027 ∩ ∃BFO:0000082.PMD_0040029`, `org:Site` |
| `LOG:LOG_1000032` | facility | `LOG_1000146` |
| `LOG:LOG_1000034` | storage facility | `LOG_1000032` |
| `LOG:LOG_1000051` | shipment | `BFO:0000027` |
| `LOG:LOG_1000029` | material product | `BFO:0000040` |
| `LOG:LOG_1000143` | transport process | `BFO:0000015` |
| `LOG:LOG_1000129` | warehousing process | `LOG_1000146` context |
| `LOG:LOG_1000001` | commercial service agreement | `IAO:0000030` (information content entity) |
| `LOG:LOG_1000002` | bill of lading | `IAO:0000030` |
| `LOG:LOG_1000088` | ship from location | `PMD:PMD_0040029` |
| `LOG:LOG_1000089` | ship to location | `PMD:PMD_0040029` |
| `LOG:LOG_1000090` | supply chain node | `PMD:PMD_0040029` |

---

## Usage Patterns

Patterns demonstrate how to model real-world logistics scenarios using this ontology. Each pattern provides:

- **`pattern.md`** — description, entities, and key properties
- **`shape.ttl`** — hand-written SHACL shapes for validation
- **`shape-data.ttl`** — real-world annotated example data (with coordinates, addresses, named organizations)

Patterns are validated with [pyshacl](https://github.com/RDFLib/pySHACL). SHACL shapes can also be auto-generated from the ontology axioms using the [autoshape pipeline](#autoshape-pipeline).

### Shipment by Sea

Models a steel coil shipment from Baosteel (Shanghai) to Volkswagen (Hamburg) via COSCO sea freight.

**Entities:** shipment, material product, ship-from/ship-to locations (with WGS84 coordinates), bill of lading, consignor/consignee organizations, transport process.

[View pattern](patterns/shipment-by-sea/pattern.md) · [Visualize data](https://thhanke.github.io/visgraph/?rdfUrl=https://raw.githubusercontent.com/materialdigital/logistics-application-ontology/refs/heads/main/patterns/shipment-by-sea/shape-data.ttl)

### Contract Negotiation

Models an annual steel supply framework agreement negotiated between Baosteel and Volkswagen AG, signed by named representatives holding formal organizational posts.

**Entities:** commercial service agreement, selling process, persons with titles, `org:Post`, buyer/supplier roles, HQ sites with coordinates.

[View pattern](patterns/contract-negotiation/pattern.md) · [Visualize data](https://thhanke.github.io/visgraph/?rdfUrl=https://raw.githubusercontent.com/materialdigital/logistics-application-ontology/refs/heads/main/patterns/contract-negotiation/shape-data.ttl)

### Warehouse Receiving

Models steel coils arriving at DB Schenker's Hamburg logistics centre, covering the receiving process and subsequent warehousing under a quarterly buffer stock plan.

**Entities:** storage facility (with address and coordinates), receiving process, warehousing process, warehousing plan specification, material product.

[View pattern](patterns/warehouse-receiving/pattern.md) · [Visualize data](https://thhanke.github.io/visgraph/?rdfUrl=https://raw.githubusercontent.com/materialdigital/logistics-application-ontology/refs/heads/main/patterns/warehouse-receiving/shape-data.ttl)

### Multimodal Transport

Models automotive parts shipped from Busan to Düsseldorf via Maersk sea freight (Busan → Rotterdam) followed by DB Schenker road freight (Rotterdam → Düsseldorf), with Rotterdam as the intermodal supply chain node.

**Entities:** two transport process legs, supply chain node, three geospatial sites (with coordinates), two carriers, shipment continuity across legs, temporal ordering.

[View pattern](patterns/multimodal-transport/pattern.md) · [Visualize data](https://thhanke.github.io/visgraph/?rdfUrl=https://raw.githubusercontent.com/materialdigital/logistics-application-ontology/refs/heads/main/patterns/multimodal-transport/shape-data.ttl)

### Autoshape Pipeline

SHACL shapes are auto-generated from the ontology axioms in three strictness profiles using [owl2shacl](https://github.com/sparna-git/owl2shacl):

| Profile | File | Description |
|---------|------|-------------|
| Open | `patterns/autoshape/auto-shapes-open.ttl` | Properties from other ontologies allowed |
| Semi-closed | `patterns/autoshape/auto-shapes-semi-closed.ttl` | Domain constraints validated |
| Closed | `patterns/autoshape/auto-shapes-closed.ttl` | Only declared properties allowed |

**Generate shapes:**
```bash
cd src/ontology
sh utils/generate-auto-shapes.sh
```

**Validate a pattern:**
```bash
cd patterns
sh test.sh shipment-by-sea
```

**Validate all patterns (make target):**
```bash
cd src/ontology
make validate-patterns
```

---

## Versions

### Stable release

Latest release always at: **https://w3id.org/pmd/log.owl**

### Release artefacts

| Artefact | Description |
|----------|-------------|
| `log.owl` / `log.ttl` | Full ontology with all imports merged |
| `log-full.owl` / `log-full.ttl` | Full with inferred axioms (primary release) |
| `log-base.owl` / `log-base.ttl` | Base — no imports merged |
| `log-simple.owl` / `log-simple.ttl` | Simplified, classified, imports filtered |

### Editors' version

[src/ontology/log-edit.owl](src/ontology/log-edit.owl)

---

## Development

This repository uses the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit).

**Run quality checks:**
```bash
cd src/ontology
docker run --rm -v $(pwd)/../../:/work -w /work/src/ontology obolibrary/odkfull:latest make IMP=false MIR=false
```

**Refresh imports:**
```bash
cd src/ontology
docker run --rm -v $(pwd)/../../:/work -w /work/src/ontology obolibrary/odkfull:latest make all_imports
```

Customizations to the build pipeline belong in [src/ontology/log.Makefile](src/ontology/log.Makefile) — this file is never overwritten by ODK updates.

---

## Contact

Please use the [Issue tracker](https://github.com/materialdigital/logistics-application-ontology/issues) to request new terms or report errors.

## Acknowledgements

This ontology repository was created using the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit). The autoshape pipeline uses [owl2shacl rulesets](https://github.com/sparna-git/owl2shacl) derived from work by TopQuadrant, adapted from [PMD Core Ontology](https://github.com/materialdigital/core-ontology).
