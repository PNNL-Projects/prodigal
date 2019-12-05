APP = prodigal-2.6.3

up: 
	copy_from_manifest.py

template:
	jobs-template -A $(APP) > job.json

job:
	tapis jobs submit -F job.json

app:
	tapis apps create -F app.json

test: clean
	sbatch test.sh

imicrobe:
	sbatch -N 4 -n 4 run.sh -i $(WORK)/iplantc.org/data/imicrobe/projects -o $(WORK)/iplantc.org/data/imicrobe/uproc

fiore:
	sbatch run.sh -i $(WORK)/iplantc.org/data/imicrobe/projects/103/samples/1661 -o $(WORK)/iplantc.org/data/imicrobe/projects/103/samples/1661
