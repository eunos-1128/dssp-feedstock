set -exo pipefail

mkdir -p "${PREFIX}/share/libcifpp"
curl -L -o "${PREFIX}/share/libcifpp/components.cif" \
    https://files.wwpdb.org/pub/pdb/data/monomers/components.cif
mkdssp --output-format dssp test/1cbs.cif.gz test/1cbs-cif.dssp
grep -q "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II" test/1cbs-cif.dssp
