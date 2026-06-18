# Experiment Record — Federated Ontology Negotiation Against a Cultural-Heritage Standard at Volume (CIDOC-CRM <-> Brand-Spectrometer provenance)

| Field | Value |
|---|---|
| **Experiment ID** | EXP-2026-06-18-NEG-CIDOC-SPECTROMETER |
| **Date** | 2026-06-18 |
| **Operator** | Dmitry Zharnikov (with Claude Opus 4.8) |
| **Classification** | Computational / deterministic / logical — no stochastic component, no statistical inference; the outcome is a fixed function of the inputs and the tool. |
| **Instrument** | `code/negotiate_modules.py` (federated multi-author generalization of the single-author linker `build_ontology.py`). Shared parser `build_ontology.Module` + `def_hash` + `_norm_ref`. |
| **Protocol** | `experiments/negotiation_cultural_heritage_cidoc`; companion `experiments/negotiation_cultural_heritage_cidoc`. |
| **Carrying paper** | `experiments/negotiation_cultural_heritage_cidoc` (Case 5). |
| **Companion experiments** | Cases 1–3 (`experiments/negotiation_cultural_heritage_cidoc*`); Case 4 (`NEGOTIATION_OBO_SCALE_GO_2026-06-18.md`). This is the cross-import-at-volume rung. |
| **Environment** | Python 3.12, `uv`; macOS (darwin). Substrate and live ontology present but neither read nor written by the run. |
| **Pre-registration** | Post-hoc record of a single confirmatory run. The §1 hypotheses were the design intent fixed before execution; no run was discarded or re-specified after seeing results. |
| **Data availability** | All inputs and outputs are listed in §9 and earmarked for the public mirror when the carrying paper is published (§9). |

---

## 1. Research question and hypotheses

**Research question.** Case 1 (SBT<->OST) produced the resolved classes — but at small volume (4 `CROSS_IMPORT` + 2 `CROSS_REFINE`) and between two convergent programs by one author. This experiment asks whether the resolved classes — clean cross-author **reuse** — scale to a genuine, independent, cross-domain standard:

> When a genuinely independent **cultural-heritage** standard — the CIDOC Conceptual Reference Model (CIDOC-CRM), ratified as ISO 21127:2023 — is negotiated against a perception-provenance instrument that builds **on** it (reusing its people/objects/places/events vocabulary by reference), does the dominant interaction become clean `CROSS_IMPORT` at a higher volume than any of the first three cases, demonstrating that the taxonomy scales to genuine cross-domain reuse?

CIDOC-CRM is the right test: its event-centric model of actors, objects, places, time-spans, and activities is exactly what a downstream instrument **reuses** rather than redefines — the structural condition for high-volume clean cross-import.

**Hypotheses (each with an explicit falsification criterion).**

- **H1 — Mechanizability.** The linker assigns every cross-owner interaction to exactly one protocol class and terminates with a verdict. *Falsified if* any interaction is left unclassified or the tool errors on the real modules.

- **H2 — CROSS_IMPORT at volume + clean federation.** The dominant interaction is clean `CROSS_IMPORT` of CIDOC-CRM classes, at a volume strictly higher than the 4 cross-imports of Case 1, with the federation clean (gate passes), plus exactly one `CROSS_REFINE` where the instrument narrows a CIDOC class to its application reading. *Directional prediction, fixed before the run:* twelve `CROSS_IMPORT` + one `CROSS_REFINE`, 0 unresolved, `--gate` exit 0. *Falsified if* the dominant class is not `CROSS_IMPORT`, the volume does not exceed Case 1, or an unresolved class appears.

- **H3 — Determinism / integrity.** Re-running reproduces byte-identical output; each owned term's `def_hash` recomputes identically (the §2 integrity manifest). *Falsified if* output varies run-to-run or a manifest hash does not reproduce.

**Adjudication is in §4.**

---

## 2. Materials

### 2.1 Author A — CIDOC-CRM module (new; faithfully transcribed, sourced per class)

`experiments/negotiation_cultural_heritage_cidoc` (`paper_key: cidoc_crm_real`) **owns thirteen** CIDOC-CRM classes, each definition a verbatim quotation of the first one-to-two sentences of the class's official scope note (CIDOC-CRM version 7.1.3, February 2024), carrying its real class identifier (E-number):

| term_key | E-number | label |
|---|---|---|
| `crm-entity` | E1 | CRM Entity |
| `crm-temporal-entity` | E2 | Temporal Entity |
| `crm-period` | E4 | Period |
| `crm-event` | E5 | Event |
| `crm-activity` | E7 | Activity |
| `crm-production` | E12 | Production |
| `crm-physical-thing` | E18 | Physical Thing |
| `crm-person` | E21 | Person |
| `crm-human-made-object` | E22 | Human-Made Object |
| `crm-actor` | E39 | Actor |
| `crm-time-span` | E52 | Time-Span |
| `crm-place` | E53 | Place |
| `crm-type` | E55 | Type |

**Sources.** Doerr, Martin (2003), "The CIDOC Conceptual Reference Module: An Ontological Approach to Semantic Interoperability of Metadata," *AI Magazine* 24(3):75–92, DOI `10.1609/aimag.v24i3.1720` (foundational CIDOC-CRM paper); ISO 21127:2023 (the ISO ratification, corresponding to community version 7.1.3); CIDOC-CRM 7.1.3 class declarations, https://cidoc-crm.org/html/cidoc_crm_v7.1.3.html (scope notes quoted verbatim). Registered as VERIFIED substrate source `doerr-2003-cidoc-crm` (DOI `10.1609/aimag.v24i3.1720`; ISO 21127:2023; IRI `http://www.cidoc-crm.org/cidoc-crm/`).

### 2.2 Author B — Brand-Spectrometer provenance module (new)

`experiments/negotiation_cultural_heritage_cidoc` (`paper_key: spectrometer_provenance_real`) models a perception-provenance instrument that builds on CIDOC-CRM. It **owns two** local bridge terms (`perception-atom`, the SBT-specific unit of captured perception evidence; `capture-instant`, the instrument's zero-duration capture event, which CIDOC does not provide at that granularity), **imports twelve** CIDOC-CRM classes unchanged (the `CROSS_IMPORT` set), and **refines one** CIDOC class (`crm-production`/E12, narrowed with an explicit `narrows_to` to brand-artifact production — the `CROSS_REFINE`).

The instrument deliberately **owns** the finer-grained `capture-instant` concept rather than importing it from CIDOC, keeping the federation clean and distinct from Case 4's dangling story. An honest alternative — importing that instant from CIDOC, which does not own it — would have produced a `DANGLING_IMPORT` (the Case-4 class); Case 5 is deliberately the clean-reuse-at-volume case.

### 2.3 Integrity manifest

| term_key | def_hash | owner |
|---|---|---|
| `crm-entity` | `9f7a0168629b5de2` | cidoc |
| `crm-temporal-entity` | `09fdf86ea1ecc927` | cidoc |
| `crm-period` | `727dd1d4c0a67023` | cidoc |
| `crm-event` | `56c148e3e8e4f6b3` | cidoc |
| `crm-activity` | `a7004ccb44384d75` | cidoc |
| `crm-production` | `5ebdc5f9c2df661e` | cidoc |
| `crm-physical-thing` | `70aa72615e576185` | cidoc |
| `crm-person` | `1e98fc6263407f9f` | cidoc |
| `crm-human-made-object` | `9838de5026ea6e44` | cidoc |
| `crm-actor` | `1cd5aa3410ccc7a0` | cidoc |
| `crm-time-span` | `4b56c9702db077a8` | cidoc |
| `crm-place` | `1b503f0e3412aae7` | cidoc |
| `crm-type` | `6200e5813b1a31f0` | cidoc |
| `perception-atom` | `b1782fc0d602b3b5` | spectrometer |
| `capture-instant` | `cb076b9622ab2c1d` | spectrometer |

### 2.4 Instrument and isolation

`negotiate_modules.py` parses both modules with the single-author linker's parser, then classifies every cross-owner interaction. Both module files live only under `experiments/negotiation_cultural_heritage_cidoc`; neither is in `experiments/negotiation_cultural_heritage_cidoc` nor named `ONTOLOGY.yaml`, so the live linker never discovers them. The committed substrate and live ontology were neither read nor written.

---

## 3. Procedure

```
uv run python code/negotiate_modules.py \
    --author-a experiments/negotiation_cultural_heritage_cidoc \
    --author-b experiments/negotiation_cultural_heritage_cidoc \
    --sssom experiments/negotiation_cultural_heritage_cidoc
```

Repeated with `--gate` for the CI verdict. **Determinism:** no random component, no seed; `def_hash` is a pure function of definition text and the classifier a pure function of the two parsed module sets.

---

## 4. Results — the negotiation report (verbatim)

```
NEGOTIATION REPORT  cidoc  <->  spectrometer
================================================================

CROSS_REFINE  (1)
  - crm-production [skos:narrowMatch]: spectrometer narrows owner's term: 'the production
    event restricted to a brand-bearing human-made object whose emission the Brand
    Spectrometer subsequently captures and decomposes across the eight spectral dimensions'
      -> reconcile: REBASE (refiner's term narrows the owner's; assert narrowMatch)

CROSS_IMPORT  (12)
  - crm-activity, crm-actor, crm-entity, crm-event, crm-human-made-object, crm-period,
    crm-person, crm-physical-thing, crm-place, crm-temporal-entity, crm-time-span, crm-type
    [skos:exactMatch each]: spectrometer imports the other author's term
      -> reconcile: none (clean dependency edge)

----------------------------------------------------------------
13 interaction(s); 0 unresolved (CONFLICT / INCOMPATIBLE_REFINE / DANGLING_IMPORT).
Federation clean: all interactions are agreements, clean imports, or compatible refinements
-- the two module sets can be linked.
```

`--gate` exit code: **0** (federation clean). Tool exit code (report mode): **0**.

**Class tally:** `CROSS_IMPORT` = 12; `CROSS_REFINE` = 1; `DANGLING_IMPORT` = 0; `CONFLICT` = 0; `AGREEMENT` = 0; `INCOMPATIBLE_REFINE` = 0. Total interactions = 13; unresolved = 0.

**Hypothesis adjudication.**

- **H1 — supported.** All thirteen interactions were classified and the tool terminated with a clean verdict; no interaction was left unclassified; the tool did not error on the real modules.
- **H2 — supported in full.** Twelve `CROSS_IMPORT` (the dominant class) + one `CROSS_REFINE`, 0 unresolved, `--gate` exit 0 — matching the directional prediction. Twelve cross-imports is three times the four of Case 1: the resolved-class reuse scales to a genuine, independent, cross-domain standard, and the federation is clean.
- **H3 — supported.** The run reproduces byte-identically; the §2.3 manifest hashes recompute identically.

---

## 5. The SSSOM mapping proposal

`experiments/negotiation_cultural_heritage_cidoc` — twelve `CROSS_IMPORT` rows (`skos:exactMatch` / `semapv:LexicalMatching` at .95, clean dependency edges) and one `CROSS_REFINE` row (`skos:narrowMatch` / `semapv:ManualMappingCuration` at .5, the E12 narrowing the curators confirm). Every interaction yields a mapping row here (unlike Case 4, where the dangling imports carried none), because all thirteen interactions are resolved correspondences.

---

## 6. Analysis by interaction class

**CROSS_IMPORT (12) — clean cross-domain reuse at volume.** The instrument reuses CIDOC-CRM's actors, objects, places, time-spans, periods, events, and types unchanged to express the provenance of each captured perception atom. Each is a clean cross-author dependency edge onto a CIDOC-owned class; no reconciliation is owed. Twelve such edges in one pair is the highest cross-import volume in the program (vs. four in Case 1), demonstrating that the resolved classes are not an artifact of small intra-author fixtures.

**CROSS_REFINE (1) — a compatible narrowing.** The instrument narrows E12 Production to brand-artifact production with an explicit `narrows_to`; the linker proposes `skos:narrowMatch`, reconciled by rebasing the refinement onto the CIDOC-owned class. This is the same resolved-but-machine-actionable pattern Case 1 highlighted: even clean reuse records the narrowing as a typed edge rather than leaving it implicit.

**Why the clean federation is the point.** The genuine independence of CIDOC-CRM (a different community, an ISO standard, decades older) does not produce an adversarial class here — because the instrument **reuses** CIDOC rather than colliding with it. Independence per se does not force a conflict; the interaction class is a function of how the second author relates to the first (reuse vs. competing ownership). Case 5 is the existence proof that genuine cross-domain reuse links cleanly at volume.

---

## 7. Threats to validity and limitations

**Transcribed, not authored by the CIDOC CRM SIG.** The CIDOC module's definitions are verbatim scope-note quotations the SBT author transcribed from the published standard — not modules the SIG authored in this schema. The independence is in CIDOC's provenance (a different community, an ISO standard), not yet in a living co-author's authoring act (the paper's L1).

**A thirteen-class slice, not the full CRM.** CIDOC-CRM 7.1.3 has ~80 classes and ~150 properties; this slice transcribes thirteen classes (no properties). The experiment demonstrates clean cross-import at realistic per-pair volume, not a full-standard run. The instrument's reuse set was chosen to be the provenance-relevant classes; a fuller instrument would import more.

**The clean federation is a modeling choice.** The instrument owns its `capture-instant` concept rather than importing a non-owned one; importing it would have produced a `DANGLING_IMPORT`. Case 5 is deliberately the clean-reuse case (Case 4 is the dangling case), and the record states this choice openly so the clean gate is not mistaken for a claim that cross-domain reuse can never dangle.

---

## 8. Reproducibility statement

Anyone with the repository and Python 3.12 can reproduce this record exactly: (i) the two input modules in §2; (ii) the §3 command; (iii) byte-identical report and SSSOM; (iv) the `--gate` exit code 0; (v) the §2.3 integrity manifest, recomputable by hashing each definition. The CIDOC-CRM scope notes are independently checkable against the version-7.1.3 class declarations. No seed, network call, or API key is required for the negotiation run.

---

## 9. Data availability and publication plan

**Internal artifacts (canonical SSOT, present now):**

- `experiments/negotiation_cultural_heritage_cidoc` — CIDOC-CRM author module (new)
- `experiments/negotiation_cultural_heritage_cidoc` — Brand-Spectrometer provenance module (new)
- `experiments/negotiation_cultural_heritage_cidoc` — tool-emitted SSSOM (12 CROSS_IMPORT + 1 CROSS_REFINE)
- this experiment record

The committed substrate and live ontology were not modified by the run. The CIDOC-CRM source is registered as VERIFIED substrate source `doerr-2003-cidoc-crm`.

**Publication plan.** Published to the public mirror when the carrying paper (`federated_negotiation`) is published, under an `experiments/negotiation-cultural-heritage-cidoc/` directory, alongside Cases 1–4, per `experiments/negotiation_cultural_heritage_cidoc` and PAQS items 37a–37f.

---

## 10. Conclusion

Against CIDOC-CRM — a genuinely independent cultural-heritage standard (ISO 21127:2023) faithfully transcribed with verbatim scope notes and real E-numbers — the federated linker classified all thirteen interactions and terminated with a clean verdict (H1), producing twelve clean `CROSS_IMPORT` (three times Case 1's volume) plus one compatible `CROSS_REFINE`, 0 unresolved, `--gate` exit 0 (H2), reproducibly (H3). The cross-import-at-volume rung is filled with a cross-domain reuse pair, demonstrating that the taxonomy's resolved classes scale to genuine, independent, cross-domain reuse.
