import os
paired_data = snakemake.params['paired']
reads = snakemake.input['reads']
fasta = snakemake.input['fasta']
outdir = snakemake.params['outdir']
output_file = snakemake.output
threads = snakemake.threads

if paired_data == True:
    os.system(f"karma.py -i {fasta} -1 {reads[0]} -2 {reads[1]} -o {outdir} --threads {threads}")
else:
    os.system(f"karma.py -i {fasta} --single {reads[0]} -o {outdir} --threads {threads}")
os.system(f"cp {outdir}/*.fa {output_file}")