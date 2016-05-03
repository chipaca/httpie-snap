all: build-env build-snap clean-stage

build-env:
	virtualenv --python=python3 --unzip-setuptools --clear env
	env/bin/pip install httpie_unixsocket
	env/bin/pip install pyyaml

stage-snap:
	mkdir -pv stage
	env/bin/http --help | sed -e '/^[^ ].*:$$/ { s/\([^:]\)/_\1/g} ; /^ *[A-Z_]\+$$/ s/\([^ ]\)/\1\1/g' > stage/README
	echo '\nbut note that bugs in the snap package itself (or in the snapd:// schema)\nshould go to https://github.com/chipaca/httpie-snap instead.' >> stage/README
	cp -a bin meta stage
	cp -a env/lib/python3.5/site-packages stage/libs

build-snap: stage-snap
	mksquashfs stage http_$(shell env/bin/python3 -c 'import yaml; print(yaml.load(open("meta/snap.yaml"))["version"])').snap -noappend -comp xz -all-root -no-xattrs

clean-stage:
	$(RM) -r stage

distclean: clean-stage
	$(RM) -r logs env *.snap

.PHONY: build-env stage-snap build-snap clean-stage distclean build

