TAG = full-text-rss
PORT = 14080
REPO = https://bitbucket.org/fivefilters/full-text-rss.git
BRANCH = master

assets/full-text-rss:
	git clone -b $(BRANCH) $(REPO) $@

ADMIN = admin
assets/admin:
	echo $(ADMIN) > $@

PASSWORD = $(shell dd if=/dev/urandom count=1 2>/dev/null | hexdump -e '"%x"' -n 10)
assets/password:
	echo $(PASSWORD) > $@

assets/custom_config.php: custom_config.php assets/password assets/admin
	sed -e 's/@PASSWORD@/'"$$(cat assets/password)"/ \
		-e 's/@ADMIN@/'"$$(cat assets/admin)"/ $< > $@

assets/update_url: assets/admin assets/password
	( \
		echo -n 'http://localhost/admin/update.php?key='; \
		echo -n $$(cat assets/admin)+$$(cat assets/password) \
			| sha1sum | cut -c1-40 \
	) > $@

assets-dir:
	mkdir -p assets

assets: \
	assets-dir \
	assets/full-text-rss \
	assets/custom_config.php \
	assets/update_url

build: assets
	docker build -t $(TAG) .

PUBLISH = -p $(PORT):80
RUN_OPTS = -d
RUN = docker run -t $(PUBLISH) $(RUN_OPTS)
debug:
	$(RUN) -i $$(docker images -q | head -n1) bash

run:
	$(RUN) --name=$(TAG) $(TAG)

MOUNTS = -v /var/www/html:$(PWD)/full-text-rss
run_mounted:
	$(RUN) --name=$(TAG) $(MOUNTS) $(TAG)

rm:
	docker rm -f $(TAG)

.PHONY: build debug run rm assets assets_dir pull
