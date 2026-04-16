<div align="center">

# PMD Application Ontology Template

**Template for building modular [PMD Core](https://github.com/materialdigital/core-ontology) application ontologies**

[![ODK](https://img.shields.io/badge/Powered%20by-ODK%20v1.6-blue?logo=github)](https://github.com/INCATools/ontology-development-kit)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)
[![CI](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-orange?logo=githubactions&logoColor=white)](.github/workflows/)

*Automated scaffolding, modular import architecture, SLME extraction, ROBOT templates, and Widoco documentation — all wired together with GitHub Actions.*

</div>

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration Files](#configuration-files)
- [CI/CD Workflows](#cicd-workflows)
- [Development Guide](#development-guide)
- [Import Architecture](#import-architecture)
- [ID Range Allocation](#id-range-allocation)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This is a **template repository** for creating new [Platform MaterialDigital (PMD)](https://www.2025.2030.2050.2070.2090.materialdigital.de/) application ontologies. It provides:

- **One-click setup** — A single GitHub Actions workflow generates the entire ontology scaffold from configuration files
- **Modular component system** — Ontology content is organized into independent OWL modules (e.g., `material_data`, `process_data`) that share a common import backbone
- **Automated imports** — External ontologies (PMD Core, LogO, TTO, HTO, etc.) are imported via [SLME extraction](https://robot.obolibrary.org/extract) so only referenced terms are included
- **ROBOT template support** — Define classes in simple TSV spreadsheets; they compile to OWL automatically
- **Full CI/CD pipeline** — Quality control, builds, import refresh, and documentation generation run on every push
- **Auto-generated documentation** — [Widoco](https://github.com/dgarijo/Widoco) produces HTML docs deployed to GitHub Pages

Built on the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit) v1.6 and runs entirely inside the `obolibrary/odkfull` Docker container — no local tooling required.

---

## Architecture

```
                     ┌─────────────────────────┐
                     │   External Ontologies    │
                     │  (pmdco, logo, tto, hto) │
                     └────────────┬────────────┘
                          SLME extraction
                                  │
                     ┌────────────▼────────────┐
                     │   *_import.owl modules   │
                     │  (pmdco_import.owl, ...) │
                     └────────────┬────────────┘
                                  │
                     ┌────────────▼────────────┐
                     │    imports-edit.owl      │
                     │  (aggregates all imports)│
                     └────────────┬────────────┘
                                  │
                     ┌────────────▼────────────┐
                     │    {id}-shared.owl       │
                     │  (shared import base)    │
                     └────────────┬────────────┘
                      ┌───────────┼───────────┐
                      │           │           │
               ┌──────▼──┐ ┌─────▼───┐ ┌─────▼───┐
               │{id}-     │ │{id}-    │ │{id}-    │
               │material_ │ │process_ │ │sustain- │
               │data.owl  │ │data.owl │ │ability  │  ... more components
               └──────┬───┘ └────┬────┘ └────┬────┘
                      │          │            │
                     ┌▼──────────▼────────────▼┐
                     │ {id}-axioms-shared.owl   │
                     │ (top-level aggregation)  │
                     └──────────────────────────┘
```

Each component module **imports `{id}-shared.owl`**, which transitively provides access to all external terms. The `{id}-axioms-shared.owl` file aggregates every component for the final build.

---

## Repository Structure

```
application-ontology-template/
│
├── .github/workflows/           # CI/CD pipeline (5 workflows)
│   ├── setup-repo.yml           #   Initial ontology scaffolding (22 steps)
│   ├── qc.yml                   #   PR quality checks + full build
│   ├── refresh-imports.yml      #   Re-extract external imports via SLME
│   ├── update-repo.yml          #   Sync repo structure from ODK config
│   └── docs.yml                 #   Generate Widoco HTML documentation
│
├── component_seeds.txt          # Component seed data (name|id|label|parent)
├── components.txt               # Component module names (one per line)
├── creators.txt                 # Contributor names for ID range allocation
├── imports.txt                  # External ontology imports (id|url)
├── pmdco_terms.txt              # PMD Core terms to import via SLME
│
├── project-odk.yaml             # Main ODK configuration (auto-updated by setup)
├── seed-template.yaml           # Minimal seed config template
│
├── LICENSE                      # Apache 2.0
└── README.md                    # You are here
```

**After running the setup workflow**, the following directories are generated:

```
├── src/
│   ├── ontology/
│   │   ├── {id}-edit.owl                  # Main ontology source (edit here)
│   │   ├── {id}-idranges.owl              # ID allocation per contributor
│   │   ├── {id}-odk.yaml                  # Internal ODK config copy
│   │   ├── Makefile                       # ODK build system
│   │   ├── catalog-v001.xml               # ROBOT import catalog
│   │   ├── imports/                       # SLME-extracted import modules
│   │   │   ├── pmdco_import.owl
│   │   │   ├── logo_import.owl
│   │   │   └── ...
│   │   └── components/                    # Modular OWL component files
│   │       ├── imports-edit.owl           # Aggregates all *_import.owl
│   │       ├── {id}-shared.owl            # Shared base (imports imports-edit)
│   │       ├── {id}-material_data.owl     # Component module
│   │       ├── {id}-process_data.owl      # Component module
│   │       └── {id}-axioms-shared.owl     # Top-level aggregation
│   └── templates/                         # ROBOT template TSV files
│       ├── {id}-material_data.tsv
│       └── {id}-process_data.tsv
└── src/ontology/config/
    └── context.json                       # JSON-LD prefix context for ROBOT
```

---

## Prerequisites

| Requirement | Details |
|:---|:---|
| **GitHub Account** | With write access to this repository |
| **GitHub Pages** | Enabled in repo settings → Pages → Source: **GitHub Actions** |
| **Actions Permissions** | Settings → Actions → General → **Read and write permissions** + **Allow GitHub Actions to create pull requests** |
| **No local tools needed** | Everything runs in the `obolibrary/odkfull:v1.6` Docker container via GitHub Actions |

> **For local development** (optional): Install [Protégé](https://protege.stanford.edu/) to edit OWL files, and Docker to run ODK locally via `make`.

---

## Quick Start

### 1. Create Your Repository

Click **[Use this template](https://github.com/materialdigital/application-ontology-template/generate)** to create a new repository from this template.

### 2. Configure Your Input Files

Edit the following files in your new repo **before running the setup workflow**:

<details>
<summary><strong>components.txt</strong> — Define your ontology modules</summary>

```
# One component name per line (no .owl extension)
material_data
process_data
sustainability_info
dismantling_data
```
</details>

<details>
<summary><strong>component_seeds.txt</strong> — Pre-populate components with seed classes</summary>

```
# Format: ComponentName | ClassIRI | rdfs:label | ParentClassIRI
material_data | https://w3id.org/pmd/co/PMD_0000892 | portion of matter | http://purl.obolibrary.org/obo/BFO_0000040
process_data  | https://w3id.org/pmd/co/PMD_0000907 | primary shaping   | https://w3id.org/pmd/co/PMD_0000899
```
</details>

<details>
<summary><strong>creators.txt</strong> — Register contributors for ID range allocation</summary>

```
Alice
Bob
Charlie
```

Each creator gets a block of 10,000 entity IDs (0–9999, 10000–19999, ...).
</details>

<details>
<summary><strong>imports.txt</strong> — Add external ontology imports</summary>

```
# Format: import_id|direct_url_to_owl_file
# PMD Core (pmdco) is always imported automatically — don't add it here
logo|https://raw.githubusercontent.com/.../log-full.owl
tto|https://raw.githubusercontent.com/.../tto-full.owl
```
</details>

<details>
<summary><strong>pmdco_terms.txt</strong> — Specify which PMD Core terms to import</summary>

```
# One IRI per line (comments with # are ignored)
https://w3id.org/pmd/co/PMD_0000833  # manufacturing process
https://w3id.org/pmd/co/PMD_0000892  # portion of matter
https://w3id.org/pmd/co/PMD_0000602  # Device
```
</details>

### 3. Enable GitHub Pages

Go to **Settings → Pages → Build and deployment → Source** and select **GitHub Actions**.

### 4. Set Actions Permissions

Go to **Settings → Actions → General → Workflow permissions**:
- Select **Read and write permissions**
- Check **Allow GitHub Actions to create and approve pull requests**

### 5. Run the Setup Workflow

1. Navigate to **Actions** → **Setup New Ontology**
2. Click **Run workflow**
3. Fill in the parameters:

| Parameter | Example | Description |
|:---|:---|:---|
| `ontology_id` | `autoce` | Lowercase acronym for your ontology |
| `ontology_title` | `Automotive Components Ontology` | Human-readable title |
| `id_digits` | `7` | Number of digits in entity IDs (default: 7) |

4. Click **Run workflow** and wait for completion (~5–10 minutes)

### 6. Start Editing

Open `src/ontology/{id}-edit.owl` in [Protégé](https://protege.stanford.edu/) or your preferred OWL editor.
Create new entities under the namespace `https://w3id.org/pmd/{id}/` (e.g., `AUTOCE_0000001`).

---

## Configuration Files

### `project-odk.yaml`

The main ODK configuration file. **Auto-generated by the setup workflow** — manual edits will be overwritten during setup. Key sections:

| Section | Purpose |
|:---|:---|
| `id`, `title` | Ontology identifier and display name |
| `uribase`, `uribase_suffix` | IRI structure (`https://w3id.org/pmd/{id}/`) |
| `import_group.products` | External ontologies to import (SLME) |
| `components.products` | Modular OWL files registered for build |
| `idranges` | Entity ID blocks allocated per contributor |
| `ci: []` | Disables ODK's default workflows (we use custom ones) |

### `seed-template.yaml`

Minimal bootstrap config used only if `project-odk.yaml` is missing. Defines the bare minimum for ODK seed to run.

---

## CI/CD Workflows

Five GitHub Actions workflows automate the entire ontology lifecycle:

### `setup-repo.yml` — Setup New Ontology
| | |
|:---|:---|
| **Trigger** | Manual dispatch (`workflow_dispatch`) |
| **Steps** | 22 steps end-to-end |
| **What it does** | Reads config files → configures ODK → seeds repo scaffold → creates import stubs → patches catalog → generates shared OWL backbone → extracts imports via SLME → creates ROBOT templates → injects annotations → validates → commits → triggers QC build |
| **Container** | `obolibrary/odkfull:v1.6` |

### `qc.yml` — Build Ontology + PR Quality Checks

`qc.yml` runs two different jobs depending on the event type:

#### Job 1: `pr-checks` — Fast quality gates on every pull request

| | |
|:---|:---|
| **Trigger** | Every pull request targeting `main` (no path filter) |
| **Container** | `obolibrary/odkfull:v1.6` |
| **What it does** | Runs fast ODK quality checks → validates OWL DL profile → posts report as PR comment |

Checks performed (in order):

| Check | ODK target / tool | What it catches |
|:---|:---|:---|
| ID range validation | `make validate_idranges` | IRI conflicts outside allocated ranges |
| Consistency (ELK) | `make reason_test` | Unsatisfiable classes, logical contradictions |
| SPARQL unit tests | `make sparql_test` | Custom SPARQL checks in `src/ontology/sparql/` |
| ROBOT report | `make robot_reports` | Missing labels, definitions, synonyms |
| OWL DL profile | `robot validate-profile` | OWL DL violations (undeclared entities, etc.) |

Results are posted as a **comment on the PR** and also appear in the GitHub Actions Step Summary. If a previous run already posted a comment, it is updated in place rather than creating a new one.

#### Job 2: `ontology-build` — Full build on push to main

| | |
|:---|:---|
| **Trigger** | Push to `main` (ontology source files only) / `repository_dispatch: trigger-qc` / `workflow_dispatch` |
| **Container** | `obolibrary/odkfull:v1.6` |
| **What it does** | `make refresh-imports` → `make all_assets` → commits release artifacts → triggers `docs.yml` |

#### Customising PR Quality Checks

**Add custom SPARQL checks**

Place any `.sparql` `ASK` or `SELECT` query in `src/ontology/sparql/`. ODK's `sparql_test` target picks them up automatically:

```
src/ontology/sparql/
├── my-check-no-orphans.sparql
└── my-check-required-annotations.sparql
```

**Disable a specific ODK check**

Pass the corresponding flag as `false` in the `make` call inside `qc.yml`:

```yaml
# Example: skip pattern expansion and mirror downloads
make IMP=false PAT=false COMP=false MIR=false validate_idranges reason_test sparql_test robot_reports
```

| Flag | Default | Effect when `false` |
|:---|:---|:---|
| `IMP` | true | Skip import refresh |
| `PAT` | true | Skip pattern expansion |
| `COMP` | true | Skip component rebuild |
| `MIR` | true | Skip upstream mirror downloads |

**Change the OWL profile checked**

In `qc.yml`, find the `robot validate-profile` step and change `--profile DL` to `--profile EL` or `--profile RL` as needed.

**Disable the PR comment** (keep only GitHub Step Summary)

In `qc.yml`, remove or comment out the `gh pr comment` / `gh api` call at the end of the `Post QC report as PR comment` step's Python block.

**Increase ROBOT memory** (for large upstream ontologies)

In the `ontology-build` job, change `ROBOT_JAVA_ARGS=-Xmx6G` to a larger value:

```yaml
env:
  ROBOT_ENV: 'ROBOT_JAVA_ARGS=-Xmx12G'
```

### `refresh-imports.yml` — Refresh Ontology Imports
| | |
|:---|:---|
| **Trigger** | Manual dispatch / `repository_dispatch: trigger-refresh-imports` |
| **What it does** | Re-downloads upstream ontologies and re-extracts SLME modules into `imports/*_import.owl` |

### `update-repo.yml` — Update Repo Config
| | |
|:---|:---|
| **Trigger** | Manual dispatch / `repository_dispatch: trigger-update-repo` |
| **What it does** | Regenerates `Makefile` and config files from `{id}-odk.yaml` after manual config changes |

### `docs.yml` — Create Widoco Documentation
| | |
|:---|:---|
| **Trigger** | Manual dispatch / `repository_dispatch: trigger-docs` |
| **What it does** | Generates HTML documentation using [Widoco](https://github.com/dgarijo/Widoco) and deploys to GitHub Pages |

### Workflow Chain

```
setup-repo  ──►  qc (ontology-build)  ──►  docs (Widoco)
                         ▲
     push to main ───────┘

any pull_request ──►  qc (pr-checks)  ──►  PR comment
```

---

## Development Guide

### Editing Your Ontology

1. **Open** `src/ontology/{id}-edit.owl` in Protégé
2. **Create** new classes under namespace `https://w3id.org/pmd/{id}/`
3. **Push** to `main` — the QC workflow builds and validates automatically

### Makefile Commands (Local Development)

Run these from `src/ontology/`:

```bash
make test                  # Run reasoner + validation checks
make refresh-imports       # Re-extract external imports via SLME
make release               # Build all release artifacts (OWL, TTL, JSON)
make update_repo           # Regenerate Makefile from ODK config
```

### Adding a New Component

1. Add the name to `components.txt`
2. Re-run the **Setup New Ontology** workflow, or manually:
   - Register in `project-odk.yaml` under `components.products`
   - Create the OWL file in `src/ontology/components/`
   - Add an `Import()` for it in `{id}-axioms-shared.owl`
   - Run `make update_repo`

### Adding a New External Import

1. Add a line to `imports.txt`:
   ```
   myonto|https://example.org/ontologies/myonto.owl
   ```
2. Optionally create `myonto_terms.txt` with specific IRIs to extract
3. Run the **Refresh Ontology Imports** workflow

---

## Import Architecture

The setup workflow generates a **layered OWL import graph** that keeps modules decoupled while sharing external terms:

| File | Role |
|:---|:---|
| `imports/*_import.owl` | SLME-extracted modules from upstream ontologies |
| `imports-edit.owl` | Aggregates all `*_import.owl` into a single import point |
| `{id}-shared.owl` | Imports `imports-edit.owl` — shared base for all components |
| `{id}-{component}.owl` | Individual component modules — each imports `{id}-shared.owl` |
| `{id}-axioms-shared.owl` | Top-level aggregation importing ALL component files |

**Why this structure?**
- Each component gets all external terms through `{id}-shared.owl` without redundant imports
- Components are independently editable and testable
- Adding/removing a component only requires updating `{id}-axioms-shared.owl`
- The SLME extraction keeps import files minimal (only referenced terms)

---

## ID Range Allocation

Each contributor listed in `creators.txt` is allocated a **10,000 ID block**:

| Creator | Range | Example ID |
|:---|:---|:---|
| First | `0` – `9,999` | `AUTOCE_0000001` |
| Second | `10,000` – `19,999` | `AUTOCE_0010000` |
| Third | `20,000` – `29,999` | `AUTOCE_0020000` |

The ranges are encoded in `{id}-idranges.owl` (Manchester Syntax) and enforced by tools like dicer-cli.

---

## Troubleshooting

<details>
<summary><strong>Setup workflow fails at "Run ODK seed"</strong></summary>

- Ensure `project-odk.yaml` exists in the repo root
- Check that `ontology_id` contains only alphanumeric characters
- Review the stub import files — they must exist before ODK seed runs
</details>

<details>
<summary><strong>ROBOT out-of-memory errors during SLME extraction</strong></summary>

The workflows default to `-Xmx8G`. For very large upstream ontologies, increase the heap:
```yaml
ROBOT_ENV='ROBOT_JAVA_ARGS=-Xmx12G'
```
</details>

<details>
<summary><strong>Double slashes in IRIs (e.g., /pmd//autoce/)</strong></summary>

Step 12 of the setup workflow automatically normalizes these. If they persist:
```bash
find src/ontology -name "*.owl" -exec sed -i 's|/pmd//|/pmd/|g' {} +
```
</details>

<details>
<summary><strong>Catalog resolution errors (HTTP fetch during CI)</strong></summary>

Ensure `catalog-v001.xml` has `rewriteURI` entries for both `imports/` and `components/` directories. Step 10 of setup does this automatically.
</details>

<details>
<summary><strong>"Protected branch" error when pushing</strong></summary>

The `main` branch requires pull requests. Push to a feature branch and open a PR:
```bash
git checkout -b feature/my-changes
git push origin feature/my-changes
```
</details>

---

## Contributing

We welcome contributions to the PMD Application Ontology Template!

- **Issues**: [Report bugs or request features](https://github.com/materialdigital/application-ontology-template/issues)
- **Discussions**: [Join community conversations](https://github.com/materialdigital/application-ontology-template/discussions)
- **PMD Playground Meetings**: Every second Friday, 1–2 PM CET — [Register via mailing list](https://www.lists.kit.edu/sympa/subscribe/ontology-playground?previous_action=info)
- **Contact**: [info@material-digital.de](mailto:info@material-digital.de)

---

## License

This project is licensed under the [Apache License 2.0](LICENSE).
