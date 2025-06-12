@echo on

copy "%PREFIX%\libcifpp\share\libcifpp\*" "dssp\test\"
mkdssp --output-format dssp dssp\test\1cbs.cif.gz dssp\test\1cbs-cif.dssp
findstr /C:"CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II" dssp\test\1cbs-cif.dssp >nul
