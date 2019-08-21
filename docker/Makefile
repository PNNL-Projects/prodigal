TAG = hurwitzlab/prodigal:2.6.3

build:
	docker build --tag=$(TAG) .

push: build
	docker push $(TAG)
