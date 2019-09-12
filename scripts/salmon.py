import os
paired_data = snakemake.params['paired']
index = snakemake.input['index']
reads = snakemake.input['reads']
output = snakemake.output
threads = snakemake.threads

if paired_data == True:
    os.system(f"salmon quant -i {index} -l A -1 {reads[0]} -2 {reads[1]} --validateMappings -o {output} --allowOrphans -p {threads} --dumpEq")
else:
    os.system(f"salmon quant -i {index} -l A --unmatedReads {reads[0]} --validateMappings -o {output} --allowOrphans -p {threads} --dumpEq")