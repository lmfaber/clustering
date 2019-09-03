import pandas as pd
from Bio import SeqIO

# Snakemake inputs
cluster = str(snakemake.input['grouper'])
scoresFile = str(snakemake.input['transrate'])
contigs = str(snakemake.input['contigs'])
outFile = str(snakemake.output)

print(f'{cluster}, {scoresFile}, {contigs}, {outFile}')
outFileName = outFile
contigScores = pd.read_csv(scoresFile, sep=',', usecols=[0,13], index_col=0)

# Determine the best contig of each cluster through the best contig value from transrate
bestContigs = []
with open(cluster, 'r') as clusters:
    for cl in clusters:
        cl = cl.split()
        maxValue = 0
        for contig in cl:
            score = contigScores.loc[contig]['score']
            if score > maxValue:
                maxValue = score
                maxContig = contig
        bestContigs.append(maxContig)

# Write only the best contigs to a fasta file
contigObjects = SeqIO.to_dict(SeqIO.parse(contigs, 'fasta'))
with open(outFile, 'w') as outFile:
    for i in bestContigs:
        SeqIO.write(contigObjects[i], outFile, "fasta")

print("A total of {0} contigs have been written to {1}".format(str(len(bestContigs)), outFileName))
