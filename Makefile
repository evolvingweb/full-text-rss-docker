TAG = full-text-rss

build:
	docker build -t $(TAG) .

debug:
	docker run -ti $$(docker images -q | head -n1) bash

run:
	docker run --name=$(TAG) $(TAG)

rm:
	docker stop $(TAG)
	docker rm $(TAG)

.PHONY: build debug

