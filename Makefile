all: build-snap clean-stage

build-env:
	virtualenv --python=python3 --unzip-setuptools --clear env
	env/bin/pip install httpie_unixsocket
	env/bin/pip install pyyaml

stage-snap: build-env
	mkdir -pv stage
	cp -a bin meta README stage
	cp -a env/lib/python3.5/site-packages stage/libs

build-snap: stage-snap
	mksquashfs stage http_$(shell env/bin/python3 -c 'import yaml; print(yaml.load(open("meta/snap.yaml"))["version"])').snap -noappend -comp xz -all-root -no-xattrs

clean-stage:
	$(RM) -r stage

distclean: clean-stage
	$(RM) -r logs env *.snap

.PHONY: build-env stage-snap build-snap clean-stage distclean build

