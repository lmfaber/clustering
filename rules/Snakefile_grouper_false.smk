
# Run Salmon
rule salmon_index_false:
    input: INPUT
    output: directory('output/{sample}/salmon_false/index')
    threads: config['threads']
	conda: '../envs/salmon.yml'
	shell: 'salmon index -t {input} -i {output} -p {threads} --keepDuplicates'

rule salmon_quasi_mapping_false:
	input: 
		R1 = config['R1'],
		R2 = config['R2'],
		index = rules.salmon_index_false.output
	output: directory('output/{sample}/salmon_false/mapping')
	params: index = 'output/{sample}/salmon_false/index'
	threads: config['threads']
	conda: '../envs/salmon.yml'
	shell: 'salmon quant -i {input.index} -l A -1 {input.R1} -2 {input.R2} --validateMappings -o {output} --allowOrphans -p {threads} --dumpEq'

# Write Grouper config
rule grouper_config_false:
    input: rules.salmon_quasi_mapping_false.output
    output: 'output/{sample}/salmon_false/config.yaml'
    params: output = 'output/{sample}/grouper_false'
    shell:'''
    echo 'conditions:'  >> {output}
    echo ' - A' >> {output}
    echo 'samples:' >> {output}
    echo '  A:' >> {output}
    echo '  - {input}' >> {output}
    echo '' >> {output}
    echo 'outdir: {params.output}' >> {output}
    echo 'orphan: False' >> {output}
    echo 'mincut: False' >> {output}
    '''

# Run Grouper
rule grouper_false:
	input: rules.grouper_config_false.output
	output: grouper = 'output/{sample}/grouper_false/mag.clust'
	conda: '../envs/grouper.yml'
	shell: 'Grouper --config {input}'


rule extract_good_contigs_false:
	input:	grouper = rules.grouper_false.output.grouper,
		transrate = rules.transrate.output.contigs,
		contigs = INPUT
	output: 'output/{sample}/grouper_false.fasta'
	conda: '../envs/bio.yml'
	params: contigs = config["samples"]
	script: '../scripts/extract_good_contigs.py'
