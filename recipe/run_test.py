import gzip

from mkdssp import dssp


with gzip.open("test/1cbs.cif.gz", "rt") as f:
    file_content = f.read()

dssp = dssp(file_content)

print("residues: ", dssp.statistics.residues)

for res in dssp:
    print(res.asym_id, res.seq_id, res.compound_id, res.type)
