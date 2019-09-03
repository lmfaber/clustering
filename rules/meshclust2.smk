rule meshclust2:
    input: INPUT
    output: 'output/{sample}/meshclust2/meshclust2.clstr'
    threads: config['threads']
    conda: '../envs/meshclust2.yml'
    shell: 'meshclust2 {input} --threads {threads} --output {output}'

rule extract_meshclust_contigs:
    input: clstr = rules.meshclust2.output,
            contigs = INPUT
    output: 'output/{sample}/meshclust2.fasta'
    conda: '../envs/bio.yml'
    shell: 'python3 scripts/meshclust_contigs_extract.py --cluster {input.clstr} --output {output} --contigs {input.contigs}'
