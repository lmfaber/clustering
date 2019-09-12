###############
### GROUPER ###
###############
# Run Salmon
rule salmon_index:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: directory('output/{sample}/salmon/index')
    threads: config['threads']
    conda: '../envs/salmon.yml'
    shell: 'salmon index -t {input} -i {output} -p {threads} --keepDuplicates'

rule salmon_quasi_mapping:
    input:  reads = lambda wildcards: config['samples'][wildcards.sample]['reads'].split(', '),
        index = rules.salmon_index.output
    output: directory('output/{sample}/salmon/mapping')
    params: index = 'output/{sample}/salmon/index',
        paired = lambda wildcards: True if len(config['samples'][wildcards.sample]['reads'].split(', ')) == 2 else False
    threads: config['threads']
    conda: '../envs/salmon.yml'
    script: '../scripts/salmon.py'

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
    benchmark: 'output/{sample}/benchmarks/grouper.csv'
    shell: 'Grouper --config {input}'

rule extract_good_contigs:
    input: 	grouper = rules.grouper.output.grouper,
        contigs = lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/grouper.fasta'
    conda: '../envs/bio.yml'
    script: '../scripts/extract_longest_contig.py'

#####################
### GROUPER FALSE ###
#####################

# Write Grouper config
rule grouper_config_false:
    input: rules.salmon_quasi_mapping.output
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
    benchmark: 'output/{sample}/benchmarks/grouper_false.csv'
    shell: 'Grouper --config {input}'

rule extract_good_contigs_false:
    input:	grouper = rules.grouper_false.output.grouper,
        contigs = lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/grouper_false.fasta'
    conda: '../envs/bio.yml'
    script: '../scripts/extract_longest_contig.py'

#############
### KARMA ###
#############

rule karma:
    input:  fasta = lambda wildcards: config['samples'][wildcards.sample]['fasta'],
        reads = lambda wildcards: config['samples'][wildcards.sample]['reads'].split(', '),
    output: 'output/{sample}/karma.fasta'
    threads: config['threads']
    conda: '../envs/karma.yml'
    benchmark: 'output/{sample}/benchmarks/karma.csv'
    params: outdir = 'output/{sample}/karma',
        paired = lambda wildcards: True if len(config['samples'][wildcards.sample]['reads'].split(', ')) == 2 else False
    script: '../scripts/karma.py'