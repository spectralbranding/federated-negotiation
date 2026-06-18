# Experiment Record — Federated Ontology Negotiation Against an OBO-Foundry Ontology at Scale (GO <-> annotation resource)

| Field | Value |
|---|---|
| **Experiment ID** | EXP-2026-06-18-NEG-GO-ANNOTATOR |
| **Date** | 2026-06-18 |
| **Operator** | Dmitry Zharnikov (with Claude Opus 4.8) |
| **Classification** | Computational / deterministic / logical — no stochastic component, no statistical inference; the outcome is a fixed function of the inputs and the tool. |
| **Instrument** | `code/negotiate_modules.py` (federated multi-author generalization of the single-author linker `build_ontology.py`). Shared parser `build_ontology.Module` + `def_hash` + `_norm_ref`. |
| **Protocol** | `experiments/negotiation_obo_scale_go`; companion `experiments/negotiation_obo_scale_go`. |
| **Carrying paper** | `experiments/negotiation_obo_scale_go` (Case 4). |
| **Companion experiments** | Cases 1–3 (`experiments/negotiation_obo_scale_go*`); Case 5 (`NEGOTIATION_CULTURAL_HERITAGE_CIDOC_2026-06-18.md`). This is the first OBO-Foundry-grounded pair and the dangling-at-scale rung. |
| **Environment** | Python 3.12, `uv`; macOS (darwin). Substrate `experiments/negotiation_obo_scale_go` and the live ontology `experiments/negotiation_obo_scale_go*.yaml` present but neither read nor written by the run. |
| **Pre-registration** | Post-hoc record of a single confirmatory run. The §1 hypotheses (including the directional prediction in H2) were the design intent fixed before execution; no run was discarded or re-specified after seeing results. |
| **Data availability** | All inputs and outputs are listed in §9 and earmarked for the public mirror when the carrying paper is published (§9). |

---

## 1. Research question and hypotheses

**Research question.** Cases 1–3 demonstrated the full real-data class set on small, hand-curated pairs (≤9 owned terms each). The lead external-validity threat (the paper's L3) is that scale and transcription bias undercut generalization. This experiment asks:

> When a genuinely independent, large-scale **OBO Foundry** ontology — the Gene Ontology (GO), the namesake of the Foundry — is negotiated against a downstream resource that consumes it by reference, does the linker produce the adversarial `DANGLING_IMPORT` class at realistic scale, **grounded in GO's own changed-definition / term-obsoletion governance** (OBO Principle 19), alongside clean `CROSS_IMPORT` of GO's current terms?

GO is the canonical test of the identity model the paper's P3 advances: GO does not silently mutate a term's meaning. When a term goes out of scope or is mis-defined, the term is **obsoleted** (its ID persists, tagged obsolete, relations stripped) and — since 2022 — a successor is referenced via the `replaced_by` OBO tag rather than a silent merge (GO Consortium 2026, *Nucleic Acids Research* 54(D1):D1779–D1792). The content-addressed `def_hash` is the automatic, byte-exact form of exactly this policy.

**Hypotheses (each with an explicit falsification criterion).**

- **H1 — Mechanizability at scale.** The linker assigns every cross-owner interaction to exactly one protocol class and terminates with a verdict on a real OBO-scale slice. *Falsified if* any interaction is left unclassified or the tool errors on the real modules.

- **H2 — Genuine DANGLING_IMPORT grounded in OBO obsoletion.** A downstream resource whose legacy annotations still cite GO IDs the Consortium **retired** under Principle 19 produces a genuine `DANGLING_IMPORT` (the current GO slice does not own those obsoleted IDs), while its annotations against GO's **current** terms produce clean `CROSS_IMPORT`. *Directional prediction, fixed before the run:* exactly two `DANGLING_IMPORT` (the two retired IDs `GO:0000005` and `GO:0006350`) and eight `CROSS_IMPORT` (the current GO terms the annotator uses). *Falsified if* the retired IDs do not dangle (e.g. they resolve to an owned current term) or the current-term imports are not clean cross-imports.

- **H3 — Determinism / integrity.** Re-running reproduces byte-identical output; each GO term's `def_hash` recomputes identically (the §2 integrity manifest). *Falsified if* output varies run-to-run or a manifest hash does not reproduce.

**Adjudication is in §4.**

---

## 2. Materials

### 2.1 Author A — Gene Ontology module (new; faithfully transcribed, sourced per term)

`experiments/negotiation_obo_scale_go` (`paper_key: go_real`) **owns twelve** current, active GO terms, each a faithful transcription of the real GO definition served by the EBI QuickGO term API, carrying its real, stable GO ID:

| term_key | GO ID | label |
|---|---|---|
| `go-molecular-function` | GO:0003674 | molecular_function |
| `go-biological-process` | GO:0008150 | biological_process |
| `go-cellular-component` | GO:0005575 | cellular_component |
| `go-catalytic-activity` | GO:0003824 | catalytic activity |
| `go-binding` | GO:0005488 | binding |
| `go-transporter-activity` | GO:0005215 | transporter activity |
| `go-dna-templated-transcription` | GO:0006351 | DNA-templated transcription (the **successor** of obsoleted GO:0006350) |
| `go-protein-binding` | GO:0005515 | protein binding |
| `go-cytoplasm` | GO:0005737 | cytoplasm |
| `go-membrane` | GO:0016020 | membrane |
| `go-signal-transduction` | GO:0007165 | signal transduction |
| `go-immune-response` | GO:0006955 | immune response |

**Sources.** Ashburner, M., Ball, C. A., Blake, J. A., et al. (2000), "Gene Ontology: tool for the unification of biology," *Nature Genetics* 25(1):25–29, DOI `10.1038/75556` (foundational GO paper); The Gene Ontology Consortium (2026), "The Gene Ontology knowledgebase in 2026," *Nucleic Acids Research* 54(D1):D1779–D1792, DOI `10.1093/nar/gkaf1292` (current release + obsoletion / `replaced_by` policy). Definitions retrieved from the EBI QuickGO services API on 2026-06-18. Registered as VERIFIED substrate source `ashburner-2000-gene-ontology` (DOI `10.1038/75556`; PURL `http://purl.obolibrary.org/obo/go.owl`).

### 2.2 Author B — downstream annotation-resource module (new)

`experiments/negotiation_obo_scale_go` (`paper_key: go_annotator_real`) models a downstream gene/protein annotation resource that consumes GO by reference. It **owns one** local term (`annotation-evidence-code`, its own evidence concept), **imports eight** current GO terms (the `CROSS_IMPORT` set), and **imports two retired GO IDs** that the current GO slice does not own (the `DANGLING_IMPORT` set):

- `go-0000005-ribosomal-chaperone-activity` — **GO:0000005**, `isObsolete: true`, `replacedBy: null`, `consider: null`. Verbatim QuickGO comment: *"This term was made obsolete because it refers to a class of gene products and a biological process rather than a molecular function."* No active successor — a legacy annotation dangles.
- `go-0006350-transcription` — **GO:0006350** "transcription", a legacy ID obsoleted and (post-2022 policy) `replaced_by` the narrower-defined `GO:0006351` "DNA-templated transcription". A legacy annotation that still cites the **old** GO:0006350 references a term the current GO slice does not own.

These are real, sourced GO obsoletions, not fabricated incompatibilities. They are exactly the changed-definition-⇒-new-ID condition the `def_hash` automates.

### 2.3 Integrity manifest (the deterministic-experiment analogue of a fixed random seed)

Each owned GO term's `def_hash` (sha256 of the trimmed definition, truncated to 16 hex), recomputed at run time:

| term_key | def_hash |
|---|---|
| `go-molecular-function` | `676180a80543333f` |
| `go-biological-process` | `7dec517b97dde93f` |
| `go-cellular-component` | `d8496e07ddc1c6ab` |
| `go-catalytic-activity` | `5a4e0093de2fd223` |
| `go-binding` | `f5eb4a28513a94fd` |
| `go-transporter-activity` | `16958760921a366b` |
| `go-dna-templated-transcription` | `324ec862a20fbad5` |
| `go-protein-binding` | `52190c097342d8d2` |
| `go-cytoplasm` | `564a318fd687bdf0` |
| `go-membrane` | `b27e54fbc9a8285b` |
| `go-signal-transduction` | `003e8e9fa56becb7` |
| `go-immune-response` | `7f23c9c0ad064c7c` |

### 2.4 Instrument and isolation

`negotiate_modules.py` parses both authors' modules with the exact parser the single-author linker uses, then classifies every cross-owner interaction (shared `term_key`s and explicit `imports`/`refines` only). Both module files live only under `experiments/negotiation_obo_scale_go`; neither is in `experiments/negotiation_obo_scale_go` nor named `ONTOLOGY.yaml`, so the live `build_ontology.discover_modules()` never discovers them. The committed substrate and live ontology were neither read nor written.

---

## 3. Procedure

```
uv run python code/negotiate_modules.py \
    --author-a experiments/negotiation_obo_scale_go \
    --author-b experiments/negotiation_obo_scale_go \
    --sssom experiments/negotiation_obo_scale_go
```

The run was repeated with `--gate` appended for the federated CI verdict. **Determinism:** no random component, no sampling, no seed; `def_hash` is a pure function of definition text and the classifier is a pure function of the two parsed module sets.

---

## 4. Results — the negotiation report (verbatim)

```
NEGOTIATION REPORT  go  <->  annotator
================================================================

DANGLING_IMPORT  (2)
  - go-0000005-ribosomal-chaperone-activity: annotator imports 'go-0000005-ribosomal-chaperone-activity' owned by neither author
      -> reconcile: BLOCK until some author owns the term or the import is dropped
  - go-0006350-transcription: annotator imports 'go-0006350-transcription' owned by neither author
      -> reconcile: BLOCK until some author owns the term or the import is dropped

CROSS_IMPORT  (8)
  - go-binding [skos:exactMatch]: annotator imports the other author's term
  - go-biological-process [skos:exactMatch]: annotator imports the other author's term
  - go-catalytic-activity [skos:exactMatch]: annotator imports the other author's term
  - go-cellular-component [skos:exactMatch]: annotator imports the other author's term
  - go-dna-templated-transcription [skos:exactMatch]: annotator imports the other author's term
  - go-molecular-function [skos:exactMatch]: annotator imports the other author's term
  - go-protein-binding [skos:exactMatch]: annotator imports the other author's term
  - go-signal-transduction [skos:exactMatch]: annotator imports the other author's term

----------------------------------------------------------------
10 interaction(s); 2 unresolved (CONFLICT / INCOMPATIBLE_REFINE / DANGLING_IMPORT).
Federation NOT clean: ...
```

`--gate` exit code: **1** (two unresolved `DANGLING_IMPORT`). Tool exit code (report mode): **0**.

**Class tally:** `DANGLING_IMPORT` = 2; `CROSS_IMPORT` = 8; `CONFLICT` = 0; `AGREEMENT` = 0; `CROSS_REFINE` = 0; `INCOMPATIBLE_REFINE` = 0. Total interactions = 10; unresolved = 2.

**Hypothesis adjudication.**

- **H1 — supported.** All ten interactions were classified and the tool terminated with a verdict; no interaction was left unclassified; the tool did not error on the real OBO-scale modules.
- **H2 — supported in full.** Exactly two `DANGLING_IMPORT` (the retired `GO:0000005` and `GO:0006350`) and eight `CROSS_IMPORT` (the current GO terms), matching the directional prediction. The dangling is grounded in GO's own Principle-19 obsoletions, not a manufactured incompatibility. This is the first **OBO-Foundry-grounded** gate-failing class in the program, and it produces both a resolved class (`CROSS_IMPORT`) and an unresolved class (`DANGLING_IMPORT`) in one report.
- **H3 — supported.** The run reproduces byte-identically; the §2.3 manifest hashes recompute identically.

---

## 5. The SSSOM mapping proposal

`experiments/negotiation_obo_scale_go` — eight `CROSS_IMPORT` rows, each `skos:exactMatch` / `semapv:LexicalMatching` at confidence .95 (a clean dependency edge onto an owned GO term). The two `DANGLING_IMPORT` interactions carry **no** mapping row, exactly as designed: a dangling import is a missing-owner gap, not a term-to-term correspondence. The SSSOM is therefore a faithful record that the federation has eight clean reuse edges and two unresolved owner gaps.

---

## 6. Analysis by interaction class

**DANGLING_IMPORT (2) — the OBO-grounded adversarial result.** The two retired GO IDs are owned by neither current module: GO obsoleted them under its changed-definition governance (Principle 19), and the annotator's legacy citations of them now dangle. The linker correctly reports the federation NOT clean until the annotator drops the obsoleted IDs (or re-points `GO:0006350` to its `replaced_by` successor `GO:0006351`, which the GO module **does** own). This is precisely the maintenance error OBO governance exists to prevent, surfaced mechanically at link time.

**CROSS_IMPORT (8) — clean reuse of current GO terms.** The annotator imports eight current GO terms unchanged; each is a clean cross-author dependency edge onto a GO-owned term. No reconciliation is owed.

**Why GO is the right OBO test.** GO's `def_hash` story is exact: a term whose definition changes substantively is obsoleted and gets a new identity, so the byte-hash identity test the paper advances (P3) is the automatic form of a policy GO already runs by hand. The experiment shows the linker reproduces GO's own obsoletion discipline as a deterministic gate.

---

## 7. Threats to validity and limitations

**Transcribed, not authored by the GO Consortium.** The GO module's definitions are faithful transcriptions the SBT author made from the published ontology (QuickGO) — not modules the Consortium authored in this schema. The independence is in GO's provenance (a different community, a 25-year-old standard, decades of governance), not yet in a living co-author's authoring act. This is the same load-bearing limitation as Cases 2–3 (the paper's L1).

**A twelve-term slice, not the full GO.** GO has ~40,000 terms; this slice transcribes twelve. The experiment demonstrates the class set and the OBO-obsoletion grounding at realistic per-pair scale, not a full-ontology run. The runtime is linear in term count (the classification is a set intersection over keys), so the slice is representative of the mechanism, not a stress benchmark of the full ontology.

**The dangling count is a design choice about which legacy IDs to include.** Two retired IDs were chosen as real, sourced obsoletions; a resource with more legacy IDs would dangle more. The point is that the dangling arises from genuine OBO obsoletion, not from the count.

---

## 8. Reproducibility statement

Anyone with the repository and Python 3.12 can reproduce this record exactly: (i) the two input modules in §2; (ii) the §3 command; (iii) byte-identical report and SSSOM; (iv) the `--gate` exit code 1; (v) the §2.3 integrity manifest, recomputable by hashing each GO definition. The GO IDs and obsolete statuses are independently checkable against the EBI QuickGO API. No seed, network call, or API key is required for the negotiation run itself.

---

## 9. Data availability and publication plan

**Internal artifacts (canonical SSOT, present now):**

- `experiments/negotiation_obo_scale_go` — GO author module (new)
- `experiments/negotiation_obo_scale_go` — annotation-resource module (new)
- `experiments/negotiation_obo_scale_go` — tool-emitted SSSOM (8 CROSS_IMPORT rows)
- this experiment record

The committed substrate and live ontology modules were not modified by the run. The two source vocabularies are registered as VERIFIED substrate sources (`ashburner-2000-gene-ontology`, and the cultural-heritage `doerr-2003-cidoc-crm` for the companion Case 5).

**Publication plan.** Published to the public mirror when the carrying paper (`federated_negotiation`) is published, under an `experiments/negotiation-obo-scale-go/` directory, alongside Cases 1–3 and Case 5, per `experiments/negotiation_obo_scale_go` and PAQS items 37a–37f.

---

## 10. Conclusion

Against the Gene Ontology — a genuinely independent, large-scale OBO Foundry ontology faithfully transcribed with real GO IDs — the federated linker classified all ten interactions and terminated (H1), producing two genuine `DANGLING_IMPORT` grounded in GO's own changed-definition obsoletion governance (`GO:0000005`, `GO:0006350`) and eight clean `CROSS_IMPORT` of GO's current terms (H2), reproducibly (H3); `--gate` exit 1. The dangling-at-scale rung is filled with an OBO-Foundry-grounded pair, and the content-addressed identity model is shown to reproduce, as a deterministic link-time gate, the obsoletion discipline GO already runs by hand.
