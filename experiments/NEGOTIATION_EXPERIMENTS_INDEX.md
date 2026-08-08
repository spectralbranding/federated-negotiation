# Federated-negotiation evaluation experiments — index (Cases 4–5)

Index of the two added scale/volume federated ontology-negotiation experiments
backing the `federated_negotiation` paper's Evaluation section (Cases 4 and 5).
Both run the same tool (`code/negotiate_modules.py`) over two namespaced
module sets. Cases 1–3 (the small-vocabulary class-coverage set) live under
`[internal path removed]` (`NEGOTIATION_*`); this directory holds the
two cross-domain scale/volume cases.

## The two runs

| Experiment ID | Class result | Modules (internal) | Record |
|---|---|---|---|
| EXP-2026-06-18-NEG-GO-ANNOTATOR | 8 CROSS_IMPORT + 2 DANGLING_IMPORT (gate fail) | `negotiation_obo_scale_go/{go,annotator}/` | `NEGOTIATION_OBO_SCALE_GO_2026-06-18.md` |
| EXP-2026-06-18-NEG-CIDOC-SPECTROMETER | 12 CROSS_IMPORT + 1 CROSS_REFINE (gate pass, clean) | `negotiation_cultural_heritage_cidoc/{cidoc,spectrometer}/` | `NEGOTIATION_CULTURAL_HERITAGE_CIDOC_2026-06-18.md` |

Synthesis: Case 4 takes the DANGLING_IMPORT class to OBO scale, grounded in the
Gene Ontology's own term-obsoletion governance (OBO Principle 19,
changed-definition => new ID) — two retired GO IDs (GO:0000005, GO:0006350) that
the current GO slice does not own dangle, while eight current GO terms cross-import
cleanly. Case 5 takes the CROSS_IMPORT class to volume (12 imports, 3x Case 1's
four) on the cultural-heritage standard CIDOC-CRM (ISO 21127:2023), reused
unchanged by a perception-provenance instrument — a clean federation. Honest open
limitation (unchanged from Cases 1–3): both module sets are author-transcribed
(faithful, sourced) and transcribe representative 12–13-term slices, not whole
ontologies; a full-ontology run + automated definition extraction remain future work.

## Source vocabularies (registered as VERIFIED substrate sources)

| Case | Vocabulary | Source key | DOI / identifier |
|---|---|---|---|
| 4 | Gene Ontology (GO) | `ashburner-2000-gene-ontology` | DOI 10.1038/75556 ; PURL http://purl.obolibrary.org/obo/go.owl ; current release GO Consortium 2026 (DOI 10.1093/nar/gkaf1292) |
| 5 | CIDOC-CRM | `doerr-2003-cidoc-crm` | DOI 10.1609/aimag.v24i3.1720 ; ISO 21127:2023 ; IRI http://www.cidoc-crm.org/cidoc-crm/ |

## Reproducibility

Deterministic. Term identity is a content-addressed hash of the definition text;
the classifier is a pure function of the two parsed module sets. No seed, no
network, no credentials. Each record carries pre-registered hypotheses with
falsifiers, an integrity manifest of the owned-term `def_hash` values, and a
threats-to-validity section. Run commands are in each record's §3.
