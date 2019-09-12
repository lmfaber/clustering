import pandas as pd
from Bio import SeqIO

# Snakemake inputs
cluster = str(snakemake.input['grouper'])
contigs = str(snakemake.input['contigs'])
outFile = str(snakemake.output)

outFileName = outFile

# Load contigs into dict
contigObjects = SeqIO.to_dict(SeqIO.parse(contigs, 'fasta'))

# Determine the best contig of each cluster through the longest contig
bestContigs = []
with open(cluster, 'r') as clusters:
    for cl in clusters:
        cl = cl.split()
        longest_seq = 0
        for contig in cl:
            seq_length = len(contigObjects[contig].seq)
            if seq_length > longest_seq:
                longest_seq = seq_length
                maxContig = contigObjects[contig].name
        bestContigs.append(maxContig)

# Write only the best contigs to a fasta file
with open(outFile, 'w') as outFile:
    for i in bestContigs:
        SeqIO.write(contigObjects[i], outFile, "fasta")

print("A total of {0} contigs have been written to {1}".format(str(len(bestContigs)), outFileName))
