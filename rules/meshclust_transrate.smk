rule extract_meshclust_contigs_with_transrate:
    input: meshclust = rules.meshclust.output,
            contigs = INPUT,
            transrate = rules.transrate.output
    output: 'output/{sample}/meshclust_transrate.fasta'
    conda: '../envs/bio.yml'
    shell: 'python3 scripts/meshclust_contigs_extract_transrate.py --cluster {input.meshclust} --output {output} --contigs {input.contigs} --transrate {input.transrate}'
