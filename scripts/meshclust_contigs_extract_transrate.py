from Bio import SeqIO
import argparse
import pandas as pd

parser = argparse.ArgumentParser(description='Description.')
parser.add_argument('--output', required=True, dest='output')
parser.add_argument('--contigs', required=True, dest='contigs')
parser.add_argument('--cluster', required=True, dest='cluster')
parser.add_argument('--transrate', required=True, dest='transrate')
args = parser.parse_args()


contigScores = pd.read_csv(args.transrate, sep=',', usecols=[0,13], index_col=0)


bestContigs = []
with open(args.cluster, 'r') as clusterReader:
    first_cluster = True
    for line in clusterReader:

        if line.startswith('>'):
            if first_cluster:
                new_cluster = []
                first_cluster = False
            else:
                if len(new_cluster) == 1:
                    bestContigs.append(new_cluster[0])
                else:
                    maxValue = 0
                    for contig in new_cluster:
                        score = contigScores.loc[contig]['score']
                        if score > maxValue:
                            maxValue = score
                            maxContig = contig
                    bestContigs.append(maxContig)
                new_cluster = []
        # Fill new cluster with contig names
        else:
            line = line.split('>')[-1]
            line = line.split('...')[0]
            new_cluster.append(line)


contigObjects = SeqIO.to_dict(SeqIO.parse(args.contigs, 'fasta'))
with open(args.output, 'w') as outFile:
    for i in bestContigs:
        SeqIO.write(contigObjects[i], outFile, "fasta")