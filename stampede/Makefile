APP = prodigal-2.6.3
EMAIL = kyclark@email.arizona.edu

clean:
	find . \( -name \*.out -o -name \*.param \) -exec rm {} \;

up: 
	copy_from_manifest.py

template:
	jobs-template -A $(APP) > job.json

job:
	jobs-submit -F job.json

rmbin:
	rm -rf bin

scriptsgz:
	(cd scripts && tar cvf ../scripts.tgz *)

app:
	apps-addupdate -F app.json

test: clean
	sbatch test.sh

imicrobe:
	sbatch -N 4 -n 4 run.sh -i $(WORK)/iplantc.org/data/imicrobe/projects -o $(WORK)/iplantc.org/data/imicrobe/uproc

files:
	find /work/05066/imicrobe/iplantc.org/data/imicrobe/projects -type f \( -name \*.fa -o -name \*.fasta -o -name \*.fna \) > files

fiore:
	sbatch run.sh -i $(WORK)/iplantc.org/data/imicrobe/projects/103/samples/1661 -o $(WORK)/iplantc.org/data/imicrobe/projects/103/samples/1661
