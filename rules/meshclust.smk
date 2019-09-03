rule meshclust:
    input: INPUT
    output: 'output/{sample}/meshclust/meshclust.clstr'
    threads: config['threads']
    conda: '../envs/meshclust.yml'
    shell: 'meshclust {input} --threads {threads} --output {output}'

rule extract_meshclust_contigs:
    input: meshclust = rules.meshclust.output,
            contigs = INPUT
    output: 'output/{sample}/meshclust.fasta'
    conda: '../envs/bio.yml'
    shell: 'python3 scripts/meshclust_contigs_extract.py --cluster {input.meshclust} --output {output} --contigs {input.contigs}'
