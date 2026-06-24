[![MIT License](https://img.shields.io/badge/Code-MIT-blue.svg)](LICENSE)
[![CC-BY 4.0](https://img.shields.io/badge/Data-CC--BY_4.0-lightgrey.svg)](LICENSE-data)
![Last Updated](https://img.shields.io/badge/updated-2026--06--18-success)

# Negotiating Vocabularies at Link Time: A Deterministic Six-Class Compatibility Check for Federated Ontology Modules

A federated linker that transfers the compile/link-time compatibility check
compilers and package managers apply to code to scholarly vocabularies: each work
declares the terms it owns, imports, and refines as a content-addressed module; a
deterministic linker classifies every cross-author interaction into exactly one
of six classes, proposes a typed SSSOM reconciliation, and fails a CI gate on the
three unresolved classes — before either author reads the other's prose.

- Paper: [paper.md](paper.md) · Version 1.0.0 · DOI [10.5281/zenodo.20751395](https://doi.org/10.5281/zenodo.20751395)
- Machine-readable bundle: [SPINE.yaml](SPINE.yaml), [ONTOLOGY.yaml](ONTOLOGY.yaml), [GLOSSARY.md](GLOSSARY.md)
- New here? [AGENTS.md](AGENTS.md) is a file-by-file guide for any reader (human or AI agent).

*Last updated: 2026-06-18*

## 1 | Getting Started

This repository is the self-contained artifact for the paper above: the `[@key]`
manuscript source, the reference linker, and a five-case evaluation that exercises
the full interaction-class set. Clone it and run `./reproduce.sh` to reproduce all
five cases (see [§3](#3--quick-start)). No network, credentials, or random seed are
required — the classification is a pure function of two parsed module sets.

## 2 | Project Layout

```
paper.md                   the manuscript ([@key] source; renders with the .bib)
federated-negotiation.bib  bibliography
SPINE.yaml / ONTOLOGY.yaml / GLOSSARY.md   machine-readable claim + term graphs
CITATION.cff / CITATIONS.md / AGENTS.md    citation metadata + reader's guide
NEGOTIATION_PROTOCOL.md    the negotiation protocol the tool implements
code/                      the reference implementation
  negotiate_modules.py     the federated multi-author linker (the paper's tool)
  build_ontology.py        the single-author linker it generalizes (shared parser)
experiments/               the five evaluation cases + a README index
  negotiation_real_corpora/         Case 1 (clean) and Case 2 (Aaker dangling)
  negotiation_independent_spence/   Case 3 (same-key conflict)
  negotiation_obo_scale_go/         Case 4 (OBO-scale dangling, Gene Ontology)
  negotiation_cultural_heritage_cidoc/  Case 5 (cross-import at volume, CIDOC-CRM)
reproduce.sh               runs all five cases
output/                    figures / tables / logs (generated)
```

## 3 | Quick Start

```bash
pip install -e .          # installs the only dependency, PyYAML
./reproduce.sh            # runs and reports all five evaluation cases
```

Run one case directly (swap directories per `experiments/README.md`):

```bash
python code/negotiate_modules.py \
    --author-a experiments/negotiation_real_corpora/sbt \
    --author-b experiments/negotiation_real_corpora/ost
```

Add `--sssom out.tsv` to write the mapping proposal, or `--gate` to exit non-zero
when any interaction is unresolved (CONFLICT / INCOMPATIBLE_REFINE / DANGLING_IMPORT).

## 4 | Dependencies

Python 3.12 and [PyYAML](https://pyyaml.org/) (>= 6.0) — declared in
[pyproject.toml](pyproject.toml). The linker is deliberately dependency-light:
parsing two author module sets needs nothing else.

## 5 | Script Map

| Script | Purpose |
|--------|---------|
| `code/negotiate_modules.py` | The federated linker. Classifies every cross-owner interaction between two authors' module sets into the six classes and proposes an SSSOM reconciliation. |
| `code/build_ontology.py` | The single-author linker it generalizes; provides the shared `Module` parser + `def_hash` content-addressed identity that both tools read. |
| `reproduce.sh` | Runs `negotiate_modules.py` on all five evaluation cases and prints each result. |

## 6 | Citation

Cite the paper via its Zenodo DOI (a machine-readable record is in
[CITATION.cff](CITATION.cff)):

> Zharnikov, D. (2026). *Negotiating Vocabularies at Link Time: A Deterministic
> Six-Class Compatibility Check for Federated Ontology Modules.* Working Paper
> v1.0.0. https://doi.org/10.5281/zenodo.20751395

## 7 | License

Code is released under the [MIT License](LICENSE); the paper and data are released
under [CC BY 4.0](LICENSE-data).
