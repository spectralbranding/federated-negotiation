# Evaluation cases

Five real, independent vocabulary pairs that together exercise the full
interaction-class set. Each case is a pair of author module sets; the federated
linker (`../code/negotiate_modules.py`) classifies every cross-owner interaction
and proposes an SSSOM reconciliation (the `*.sssom.tsv` files). Run all five with
`../reproduce.sh`, or each individually as shown below.

| # | Case | Author A / Author B | Result |
|---|------|---------------------|--------|
| 1 | Clean intra-author federation | `negotiation_real_corpora/sbt` / `negotiation_real_corpora/ost` | 6 interactions, 0 unresolved — federation clean (CROSS_IMPORT + CROSS_REFINE) |
| 2 | Incumbent dangling reference | `negotiation_real_corpora/sbt` / `negotiation_independent_aaker/aaker` | 2 interactions, 2 unresolved — DANGLING_IMPORT (`brand`, `consumer`) |
| 3 | Same-key conflict | `negotiation_independent_spence/sbt` / `negotiation_independent_spence/spence` | 2 interactions, 2 unresolved — CONFLICT (`signal`) + DANGLING_IMPORT (`labor-market`) |
| 4 | OBO-scale dangling | `negotiation_obo_scale_go/go` / `negotiation_obo_scale_go/annotator` | 10 interactions, 2 unresolved — DANGLING_IMPORT on Gene Ontology IDs retired under OBO Principle 19 (`GO:0000005`, `GO:0006350`) |
| 5 | Cross-import at volume | `negotiation_cultural_heritage_cidoc/cidoc` / `negotiation_cultural_heritage_cidoc/spectrometer` | 13 interactions, 0 unresolved — federation clean; 12 CROSS_IMPORT (3x Case 1's volume) + 1 CROSS_REFINE |

Cases 1–3 are shared with the R14 (Research-as-Repository) negotiation
experiments; cases 4–5 are introduced here at larger scale and in new domains
(biomedical ontology and cultural-heritage standard). The per-case RECORD files
(`NEGOTIATION_*.md`) document each source vocabulary's version/IRI, the
transcribed terms with provenance, and the exact classification output.

## Reproduce a single case

```
python ../code/negotiate_modules.py \
    --author-a negotiation_real_corpora/sbt \
    --author-b negotiation_real_corpora/ost
```

Swap the `--author-a` / `--author-b` directories per the table above. Add
`--sssom out.tsv` to write the mapping proposal, or `--gate` to exit non-zero
when any interaction is unresolved (CONFLICT / INCOMPATIBLE_REFINE /
DANGLING_IMPORT).
