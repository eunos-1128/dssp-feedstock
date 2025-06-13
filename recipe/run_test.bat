@echo on

@REM copy "%PREFIX%\libcifpp\share\libcifpp\*" "dssp\test\"
cd dssp\test
mkdssp --output-format dssp 1cbs.cif.gz 1cbs-cif.dssp
findstr /C:"CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II" 1cbs-cif.dssp >nul
type 1cbs-cif.dssp
