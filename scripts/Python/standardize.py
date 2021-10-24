# coding: utf-8
import pubchempy
import sys
import os

print(sys.version)
print(sys.argv[1] + '_standardized')
print(sys.argv[1] + '_failed')
print(os.getcwd())
print('writable?', os.access(os.getcwd(), os.W_OK))

with open(sys.argv[1]) as inhandle, open(sys.argv[1] + '_standardized', 'w') as success_handle, open(sys.argv[1] + '_failed', 'w') as fail_handle:
    print('opening files')
    for line in inhandle.readlines():
        id_, smiles = line.split('\t')
        smiles = smiles.strip()
        if (len(smiles) == 0):
            continue
        try:
            c = pubchempy.get_compounds(smiles, 'smiles')[0]
            success_handle.write('\t'.join([id_, c.isomeric_smiles]) + '\n')
        except Exception as e:
            fail_handle.write('\t'.join([id_, smiles, str(e).strip()]) + '\n')
    # make sure output files (even if empty) exist
    success_handle.write('')
    fail_handle.write('')
    print('finished, trying to close')
