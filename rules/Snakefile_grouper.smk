
# Run Salmon
rule salmon_index:
    input: INPUT
    output: directory('output/{sample}/salmon/index')
    threads: config['threads']
	conda: '../envs/salmon.yml'
	shell: 'salmon index -t {input} -i {output} -p {threads} --keepDuplicates'

rule salmon_quasi_mapping:
	input: 
		R1 = config['R1'],
		R2 = config['R2'],
		index = rules.salmon_index.output
	output: directory('output/{sample}/salmon/mapping')
	params: index = 'output/{sample}/salmon/index'
	threads: config['threads']
	conda: '../envs/salmon.yml'
	shell: 'salmon quant -i {input.index} -l A -1 {input.R1} -2 {input.R2} --validateMappings -o {output} --allowOrphans -p {threads} --dumpEq'

# Write Grouper config
rule grouper_config:
    input: rules.salmon_quasi_mapping.output
    output: 'output/{sample}/salmon/config.yaml'
    params: output = 'output/{sample}/grouper'
    shell:'''
    echo 'conditions:'  >> {output}
    echo ' - A' >> {output}
    echo 'samples:' >> {output}
    echo '  A:' >> {output}
    echo '  - {input}' >> {output}
    echo '' >> {output}
    echo 'outdir: {params.output}' >> {output}
    echo 'orphan: True' >> {output}
    echo 'mincut: True' >> {output}
    '''

# Run Grouper
rule grouper:
	input: rules.grouper_config.output
	output: grouper = 'output/{sample}/grouper/mag.clust'
	conda: '../envs/grouper.yml'
	shell: 'Grouper --config {input}'

# Run TransRate and get the best contig score from each group

rule transrate:
	input: contigs = INPUT,
		R1 = config['R1'],
		R2 = config['R2']
	output: contigs = 'output/{sample}/transrate/{sample}/contigs.csv'
	conda: '../envs/transrate.yml'
	params: baseDir = 'output/{sample}/transrate'
	threads: config['threads']
	shell: 'transrate --assembly {input.contigs} --threads {threads} --output {params.baseDir} --left {input.R1} --right {input.R2}'

rule extract_good_contigs:
	input: 	grouper = rules.grouper.output.grouper,
		transrate = rules.transrate.output.contigs,
		contigs = INPUT
	output: 'output/{sample}/grouper.fasta'
	conda: '../envs/bio.yml'
	params: contigs = config["samples"]
	script: '../scripts/extract_good_contigs.py'
