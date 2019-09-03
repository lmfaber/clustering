SAMPLES = config["samples"]

def generateOutputFiles():
	"""
	Generates output file paths for all listed input files.
	"""
	endings = ['grouper', 'rnaspades', 'cdhitest']
	outputFiles = ['output/' + SAMPLES + '/' + SAMPLES + '_' + ending for ending in endings]

	return(outputFiles)

rule all:
	input: cdhitest = expand("output/{dataset}/cdhitest.fasta", dataset=SAMPLES),
		cdhitest90 = expand("output/{dataset}/cdhitest90.fasta", dataset=SAMPLES),
		rnaspades = expand("output/{sample}/rnaspades.fasta", sample=SAMPLES),
		grouper = expand("output/{dataset}/grouper.fasta", dataset=SAMPLES),
		grouper_false = expand("output/{dataset}/grouper_false.fasta", dataset=SAMPLES),
		meshclust = expand("output/{dataset}/meshclust.fasta", dataset=SAMPLES),
		meshclust_transrate = expand("output/{dataset}/meshclust_transrate.fasta", dataset=SAMPLES)
		 

		
# INPUT = [config['samples'][value] for value in config['samples']]

PATHS = [config['samples'][value].split('/')[:-1] for value in config['samples']]
PATHS = ['/'.join(a) for a in PATHS]

INPUT = expand('{path}/{sample}.fasta', zip, path=PATHS, sample=SAMPLES)

include: "rules/Snakefile_grouper.smk"
include: "rules/Snakefile_rnaspades.smk"
include: "rules/Snakefile_cdhit.smk"
include: "rules/Snakefile_grouper_false.smk"
include: "rules/meshclust.smk"
include: "rules/meshclust_transrate.smk"
