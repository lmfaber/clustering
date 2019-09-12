rule cd_hit_est_100:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/cd-hit-est-100.fasta'
    conda: '../envs/cdhitest.yml'
    benchmark: 'output/{sample}/benchmarks/cd-hit-est-100.csv'
    params: temp_dir = 'output/{sample}/cd-hit-est',
        temp_name = 'cd-hit-est-100.fasta'
    shell: """
    mkdir -p {params.temp_dir}
    cd-hit-est -i {input} -o {params.temp_dir}/{params.temp_name} -d 30 -c 1 -n 5 -T {threads}
    cp {params.temp_dir}/{params.temp_name} {output}
    """

rule cd_hit_est_90:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/cd-hit-est-90.fasta'
    conda: '../envs/cdhitest.yml'
    benchmark: 'output/{sample}/benchmarks/cd-hit-est-90.csv'
    params: temp_dir = 'output/{sample}/cd-hit-est',
        temp_name = 'cd-hit-est-90.fasta'
    shell: """
    mkdir -p {params.temp_dir}
    cd-hit-est -i {input} -o {params.temp_dir}/{params.temp_name} -d 30 -c 0.9 -n 5 -T {threads}
    cp {params.temp_dir}/{params.temp_name} {output}
    """

################
### LINCLUST ###
################

rule linclust:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/linclust.fasta'
    threads: config['threads']
    conda: '../envs/linclust.yml'
    params: dir = 'output/{sample}/linclust'
    benchmark: 'output/{sample}/benchmarks/linclust.csv'
    shell: '''
    mkdir -p {params.dir}
    # Create database
    mmseqs createdb {input} {params.dir}/DB
    # Cluster the database
    mmseqs linclust {params.dir}/DB {params.dir}/DB_clu {params.dir}/tmp
    # Extract the sequences
    mmseqs result2repseq {params.dir}/DB {params.dir}/DB_clu {params.dir}/DB_clu_rep
    mmseqs result2flat {params.dir}/DB {params.dir}/DB {params.dir}/DB_clu_rep {output} --use-fasta-header	
    '''

#################
### MESHCLUST ###
#################
rule meshclust:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/meshclust/meshclust.clstr'
    threads: config['threads']
    conda: '../envs/meshclust.yml'
    benchmark: 'output/{sample}/benchmarks/meshclust.csv'
    shell: 'meshclust {input} --output {output} --threads {threads}'

rule extract_meshclust_contigs:
    input: meshclust = rules.meshclust.output,
        contigs = lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/meshclust.fasta'
    conda: '../envs/bio.yml'
    shell: 'python3 scripts/meshclust_contigs_extract.py --cluster {input.meshclust} --output {output} --contigs {input.contigs}'

##################
### MESHCLUST2 ###
##################
rule meshclust2:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/meshclust2/meshclust2.clstr'
    threads: config['threads']
    conda: '../envs/meshclust2.yml'
    benchmark: 'output/{sample}/benchmarks/meshclust2.csv'
    shell: 'meshclust2 {input} --threads {threads} --output {output}'

rule extract_meshclust_contigs2:
    input: clstr = rules.meshclust2.output,
        contigs = lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/meshclust2.fasta'
    conda: '../envs/bio.yml'
    shell: 'python3 scripts/meshclust_contigs_extract.py --cluster {input.clstr} --output {output} --contigs {input.contigs}'

##################
### RNASPADES ####
##################
rule rnaspades:
    input: lambda wildcards: config['samples'][wildcards.sample]['fasta']
    output: 'output/{sample}/rnaspades/K127/final_contigs.fasta'
    threads: config['threads']
    params: kmer = 127,
        dir = 'output/{sample}/rnaspades'
    conda: '../envs/rnaspades.yml'
    benchmark: 'output/{sample}/benchmarks/rnaspades.csv'
    shell: 'rnaspades.py --threads {threads} -s {input} -o {params.dir} -k {params.kmer}'
    # shell: 'rnaspades.py --threads {threads} -s {input} -o {params.dir} -k {params.kmer} --only-assembler'

rule copyFile:
    input: rules.rnaspades.output
    output: 'output/{sample}/rnaspades.fasta'
    shell: 'cp {input} {output}'