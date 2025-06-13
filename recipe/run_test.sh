set -exo pipefail

# cp ${PREFIX}/libcifpp/share/libcifpp/* dssp/test/
cd dssp/test
mkdssp --output-format dssp 1cbs.cif.gz 1cbs-cif.dssp
grep -q "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II" 1cbs-cif.dssp
