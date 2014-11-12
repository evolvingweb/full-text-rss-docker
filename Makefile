TAG = full-text-rss
PORT = 14080
REPO = https://bitbucket.org/fivefilters/full-text-rss.git
BRANCH = master

assets/full-text-rss:
	git clone -b $(BRANCH) $(REPO) $@

PASSWORD = $(shell dd if=/dev/urandom count=1 2>/dev/null | hexdump -e '"%x"' -n 10)
assets/password:
	echo $(PASSWORD) > $@

assets/custom_config.php: custom_config.php assets/password
	sed -e 's/@PASSWORD@/'"$$(cat assets/password)"/ $< > $@

assets-dir:
	mkdir -p assets

assets: \
	assets-dir \
	assets/full-text-rss \
	assets/custom_config.php

build: assets
	docker build -t $(TAG) .

PUBLISH = -p $(PORT):80
RUN = docker run -t $(PUBLISH)
debug: rm
	$(RUN) -i $$(docker images -q | head -n1) bash

run: rm
	$(RUN) --name=$(TAG) $(OPTS) $(TAG)

MOUNTS = -v /var/www/html:$(PWD)/full-text-rss
run_mounted: rm
	$(RUN) --name=$(TAG) $(MOUNTS) $(OPTS) $(TAG)

rm:
	-docker kill $(TAG) 2>/dev/null
	-docker rm $(TAG) 2>/dev/null

.PHONY: build debug run rm assets assets_dir pull
