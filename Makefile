TAG = full-text-rss
PORT = 14080

build:
	docker build -t $(TAG) .


PUBLISH = -p $(PORT):80
RUN = docker run -t $(PUBLISH)
debug: rm
	$(RUN) -i $$(docker images -q | head -n1) bash

run: rm
	$(RUN) --name=$(TAG) $(OPTS) $(TAG)

rm:
	-docker kill $(TAG) 2>/dev/null
	-docker rm $(TAG) 2>/dev/null

.PHONY: build debug run rm
