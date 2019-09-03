rule cdhitest:
	input: INPUT
	output: 'output/{sample}/cdhitest.fasta' #rules.all.input.cdhitest
	conda: '../envs/cdhitest.yml'
	shell: 'cd-hit-est -i {input} -o {output} -d 30 -c 1 -n 5 -T {threads}'

rule cdhitest90:
	input: INPUT
	output: 'output/{sample}/cdhitest90.fasta' #rules.all.input.cdhitest
	conda: '../envs/cdhitest.yml'
	shell: 'cd-hit-est -i {input} -o {output} -d 30 -c 0.9 -n 5 -T {threads}'
