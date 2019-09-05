CROMWELL = java -jar /Users/kyclark/work/cromwell/cromwell-45.jar

single:
	cwl-runner prodigal-single.cwl input-single.yml

batch:
	cwl-runner prodigal-batch.cwl input-batch.yml

crom:
	$(CROMWELL) run prodigal-single.cwl -i input-single.yml
