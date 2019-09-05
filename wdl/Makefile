.PHONY: clean single validate

CROMWELL = java -jar /Users/kyclark/work/cromwell/cromwell-45.jar
WOMTOOL = java -jar /Users/kyclark/work/cromwell/womtool-45.jar

single:
	$(CROMWELL) run single.wdl -i single.json

batch:
	$(CROMWELL) run batch.wdl -i batch.json

validate:
	$(WOMTOOL) validate 

clean:
	rm -rf cromwell-executions cromwell-workflow-logs
