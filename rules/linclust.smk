rule linclust:
    input: INPUT
    output: 'output/{sample}/linclust/linclust.fasta'
    threads: config['threads']
    conda: '../envs/linclust.yml'
    params: dir = 'output/{sample}/linclust'
    shell: '''
	# Create database
	mmseqs createdb {input} {params.dir}/DB
	# Cluster the database
	mmseqs linclust {params.dir}/DB {params.dir}/DB_clu {params.dir}/tmp
	# Extract the sequences
	mmseqs result2repseq {params.dir}/DB {params.dir}/DB_clu {params.dir}/DB_clu_rep
	mmseqs result2flat {params.dir}/DB {params.dir}/DB {params.dir}/DB_clu_rep {output} --use-fasta-header	
	'''
