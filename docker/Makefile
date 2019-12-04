TAG = hurwitzlab/prodigal:2.6.3

img:
	docker build --tag=$(TAG) .

run:
	docker run --rm $(TAG)

test:
	docker run --rm -v /Users/kyclark/work/data:/data $(TAG) run_prodigal -q /data/dolphin/fasta/Dolphin_1_z04.fa -o /data/prodigal-out -sda -f gbk

push:
	docker push $(TAG)
