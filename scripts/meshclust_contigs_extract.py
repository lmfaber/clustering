from Bio import SeqIO
import argparse
parser = argparse.ArgumentParser(description='Description.')
parser.add_argument('--output', required=True, dest='output')
parser.add_argument('--contigs', required=True, dest='contigs')
parser.add_argument('--cluster', required=True, dest='cluster')
args = parser.parse_args()


bestContigs = []
with open(args.cluster, 'r') as clusterReader, open(args.output, 'w') as writer:
    for line in clusterReader:
        line = line.replace('\n', '')
        if line.endswith('*'):
            line = line.split('>')[-1]
            line = line.split('...')[0]
            bestContigs.append(line)

contigObjects = SeqIO.to_dict(SeqIO.parse(args.contigs, 'fasta'))
with open(args.output, 'w') as outFile:
    for i in bestContigs:
        SeqIO.write(contigObjects[i], outFile, "fasta")