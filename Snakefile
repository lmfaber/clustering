SAMPLES = config["samples"]

rule all:
	input:
		cdhitest = expand("output/{dataset}/cd-hit-est-100.fasta", dataset=SAMPLES),
		cdhitest90 = expand("output/{dataset}/cd-hit-est-90.fasta", dataset=SAMPLES),
		rnaspades = expand("output/{sample}/rnaspades.fasta", sample=SAMPLES),
		grouper = expand("output/{dataset}/grouper.fasta", dataset=SAMPLES),
		grouper_false = expand("output/{dataset}/grouper_false.fasta", dataset=SAMPLES),
		meshclust = expand("output/{dataset}/meshclust.fasta", dataset=SAMPLES),
		meshclust2 = expand("output/{dataset}/meshclust2.fasta", dataset=SAMPLES),
		linclust = expand("output/{dataset}/linclust.fasta", dataset=SAMPLES),
		karma = expand("output/{dataset}/karma.fasta", dataset=SAMPLES)

include: "rules/read_independant_methods.smk"
include: "rules/read_dependant_methods.smk"