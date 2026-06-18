#!/usr/bin/env bash
# Reproduce all five federated-negotiation evaluation cases.
# Requires Python 3.12 + pyyaml (see pyproject.toml). Run: ./reproduce.sh
set -uo pipefail
cd "$(dirname "$0")"
PY="python"
TOOL="code/negotiate_modules.py"
E="experiments"

run() {
  echo
  echo "=================================================================="
  echo "CASE: $1"
  echo "------------------------------------------------------------------"
  "$PY" "$TOOL" --author-a "$2" --author-b "$3" | tail -n 3
}

# Case 1 — clean intra-author federation (SBT <-> OST): 6 interactions, 0 unresolved.
run "1  SBT <-> OST  (clean federation)" \
    "$E/negotiation_real_corpora/sbt" "$E/negotiation_real_corpora/ost"

# Case 2 — incumbent vocabulary dangling reference (SBT <-> Aaker): 2 unresolved (DANGLING_IMPORT).
run "2  SBT <-> Aaker  (dangling reference)" \
    "$E/negotiation_real_corpora/sbt" "$E/negotiation_independent_aaker/aaker"

# Case 3 — same-key conflict (SBT <-> Spence): 2 unresolved (CONFLICT + DANGLING_IMPORT).
run "3  SBT <-> Spence  (same-key conflict)" \
    "$E/negotiation_independent_spence/sbt" "$E/negotiation_independent_spence/spence"

# Case 4 — OBO-scale dangling (Gene Ontology <-> annotator): 10 interactions, 2 DANGLING_IMPORT.
run "4  Gene Ontology <-> annotator  (OBO-scale dangling)" \
    "$E/negotiation_obo_scale_go/go" "$E/negotiation_obo_scale_go/annotator"

# Case 5 — cross-import at volume (CIDOC-CRM <-> spectrometer): 13 interactions, 0 unresolved.
run "5  CIDOC-CRM <-> spectrometer  (cross-import at volume)" \
    "$E/negotiation_cultural_heritage_cidoc/cidoc" "$E/negotiation_cultural_heritage_cidoc/spectrometer"

echo
echo "Done. The SSSOM mapping proposals for each case are alongside its module dirs (*.sssom.tsv)."
