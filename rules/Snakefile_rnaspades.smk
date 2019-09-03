rule rnaspades:
	input: INPUT
	output: 'output/{sample}/rnaspades/K127/final_contigs.fasta'
	threads: config['threads']
	params: kmer = 127,
			dir = 'output/{sample}/rnaspades'
	conda: '../envs/rnaspades.yml'
	shell: 'rnaspades.py --threads {threads} -s {input} -o {params.dir} -k {params.kmer}'
	# shell: 'rnaspades.py --threads {threads} -s {input} -o {params.dir} -k {params.kmer} --only-assembler'

rule copyFile:
	input: rules.rnaspades.output
	output: 'output/{sample}/rnaspades.fasta'
	shell: 'cp {input} {output}'
