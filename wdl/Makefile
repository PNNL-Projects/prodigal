.PHONY: clean

CROMWELL = java -jar /Users/kyclark/work/cromwell/cromwell-45.jar
WOMTOOL = java -jar /Users/kyclark/work/cromwell/womtool-45.jar
WDL = workflow.wdl 

run:
	$(CROMWELL) run $(WDL) -i input.json

validate:
	$(WOMTOOL) validate $(WDL)

clean:
	rm -rf cromwell-executions cromwell-workflow-logs
