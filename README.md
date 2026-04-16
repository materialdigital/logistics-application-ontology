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
- [Release Process](#release-process)
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
│   ├── release.yml              #   Versioned release + GitHub release creation
│   ├── enforce-tags.yml         #   Reject non-semver tags
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

### `qc.yml` — Build Ontology
| | |
|:---|:---|
| **Trigger** | Push to `main` / `repository_dispatch: trigger-qc` |
| **What it does** | Runs `make test` (reasoner + syntax checks) → `make refresh-imports` → builds release artifacts (OWL, TTL, JSON) → commits results → triggers docs |

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

### `release.yml` — Release Ontology
| | |
|:---|:---|
| **Trigger** | Manual dispatch (enter version in UI) / push `v*.*.*` git tag |
| **Container** | `obolibrary/odkfull:v1.6` |
| **What it does** | Builds release artifacts → sets PMDco-convention `owl:versionIRI` → commits to `main` → creates GitHub release with OWL/TTL/JSON attached → triggers versioned docs |

### Workflow Chain

<<<<<<< HEAD
```
setup-repo  ──►  qc (build)  ──►  docs (Widoco)
                    ▲
    push to main ───┘
=======
```text
setup-repo  ──►  qc (ontology-build)  ──►  docs (/dev/ updated)
                         ▲
     push to main ───────┘

release ──►  docs (/<version>/ added to Pages)
   ▲
   └── workflow_dispatch (enter version) OR git tag push

any pull_request ──►  qc (pr-checks)  ──►  PR comment
>>>>>>> e06896c (feat: add versioned release workflow, enforce tag convention)
```

---

## Release Process

### Version IRI Convention

This template follows the **PMD Core Ontology convention** for `owl:versionIRI`:

```turtle
owl:versionIRI  <https://w3id.org/pmd/{id}/{version}>
owl:versionInfo "{version}"
```

Example for ontology `myont` at version `1.0.0`:

```turtle
owl:ontologyIRI  <https://w3id.org/pmd/myont>
owl:versionIRI   <https://w3id.org/pmd/myont/1.0.0>
owl:versionInfo  "1.0.0"
```

This differs from the ODK default (`releases/2025-11-20/myont.owl`) — the `release.yml` workflow overrides it automatically via ROBOT annotate after the build.

Versions must be **semver** (`X.Y.Z`) without a `v` prefix. Git tags are created with the `v` prefix (`v1.0.0`).

### How to Create a Release

**Option A — via GitHub UI (recommended):**

1. Navigate to **Actions → Release Ontology → Run workflow**
2. Enter version (e.g. `1.0.0`)
3. Optionally add release notes
4. Click **Run workflow**

**Option B — via git tag:**

```bash
git tag v1.0.0
git push origin v1.0.0
```

Both options:
- Build all release artifacts with the correct `owl:versionIRI`
- Commit the versioned OWL/TTL/JSON files to `main`
- Create a GitHub release with all serializations attached
- Trigger a versioned documentation build (adds `/{version}/` to GitHub Pages)

### GitHub Pages Structure After Release

```text
https://{org}.github.io/{repo}/           version index (all releases)
https://{org}.github.io/{repo}/dev/doc/   development build (updated on every push)
https://{org}.github.io/{repo}/1.0.0/doc/ Widoco HTML for v1.0.0 (permanent)
https://{org}.github.io/{repo}/2.0.0/doc/ Widoco HTML for v2.0.0 (permanent)
```

Widoco generates serialization download links (OWL, TTL, RDF/XML, JSON-LD) directly in the HTML documentation — no separate hosting needed.

> **Breaking change — GitHub Pages source setting**
>
> The docs workflow now deploys via the `gh-pages` **branch** instead of the GitHub Actions Pages API. This is required to preserve old release documentation across deploys.
>
> **One-time setup required:**
> Go to **Settings → Pages → Build and deployment → Source**
> Change from `GitHub Actions` → `Deploy from a branch`, select branch `gh-pages` / `(root)`.
>
> **Migrating from the old single-version docs:**
> Your existing Pages content will be replaced on the next docs run. If you want to preserve it, manually copy the content into the `gh-pages` branch before triggering the workflow.

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
