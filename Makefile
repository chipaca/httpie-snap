all: build-env stage-snap build-snap clean-stage

build-env:
	virtualenv --python=python3 --unzip-setuptools --clear env
	env/bin/pip install -U requests[socks]
	env/bin/pip install -U httpie
	env/bin/pip install -U httpie_unixsocket
	env/bin/pip install -U pyyaml

p := env/lib/python3.5/site-packages

stage-snap:
	$(eval snapVer := $(shell env/bin/python3 -c 'import yaml; print(yaml.load(open("meta/snap.yaml"))["version"])'))
	$(eval httpVer := $(shell env/bin/http --version))
	echo $(snapVer) | grep -q "^$(httpVer)-"
	mkdir -pv stage/libs
	env/bin/http --help | sed -e '/^[^ ].*:$$/ { s/\([^:]\)/_\1/g} ; /^ *[A-Z_]\+$$/ s/\([^ ]\)/\1\1/g' > stage/README
	echo '\nbut note that bugs in the snap package itself (or in the snapd:// schema)\nshould go to https://github.com/chipaca/httpie-snap instead.' >> stage/README
	cp -a bin meta stage
	cp -a -t stage/libs \
		$(p)/httpie \
		$(p)/httpie_unixsocket.py \
		$(p)/socks.py \
		$(p)/pygments \
		$(p)/requests \
		$(p)/requests_unixsocket \
		$(p)/pkg_resources
	find stage -type f \( -name '*.py[co]' -o -name '*~' \) -delete
	find stage -type d -empty -delete


build-snap:
	mksquashfs stage http_$(shell env/bin/python3 -c 'import yaml; print(yaml.load(open("meta/snap.yaml"))["version"])').snap -noappend -comp xz -all-root -no-xattrs

clean-stage:
	$(RM) -r stage

distclean: clean-stage
	$(RM) -r logs env *.snap

.PHONY: build-env stage-snap build-snap clean-stage distclean all
