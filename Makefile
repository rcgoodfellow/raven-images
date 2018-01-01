# =============================================================================
# Raven images build script
# -------------------------
#
#  This makefile builds the currently supported raven base images from
#  upstream OS base images. Packer is used to bring up the base OS image
#  in a QEMU virtual machine and add the raven public key as well as ensuing
#  python is installed for ansible usage.
#
# =============================================================================

.PHONY: all
all: \
	build/fedora/27/fedora-27 \
	build/debian/stretch/debian-stretch \
	build/cumulus/3.5/cumulusvx-3.5

.PHONY: fedora
fedora: build/fedora/27/fedora-27

.PHONY: debian
debian: build/debian/stretch/debian-stretch  

.PHONY: cumulus
cumulus: build/cumulus/3.5/cumulusvx-3.5

###
### Fedora images
### 
FEDORA_MIRROR=http://mirrors.kernel.org/fedora/releases
F27_BASE=Fedora-Cloud-Base-27-1.6.x86_64.qcow2
F27_URL=${FEDORA_MIRROR}/27/CloudImages/x86_64/images/${F27_BASE}

build/fedora:
	sudo mkdir -p build/fedora

build/fedora/27/fedora-27: base/${F27_BASE} build/fedora
	cd cloud-init; ./build-iso.sh
	sudo -E ${packer} build fedora-27.json

base/$(F27_BASE): base
	wget --directory-prefix base ${F27_URL}

fedora-clean:
	rm -rf cloud-init/*.iso

###
### Debian images
###
DEBIAN_MIRROR=http://cdimage.debian.org/debian-cd
STRETCH_BASE=debian-9.3.0-amd64-netinst.iso
STRETCH_URL=${DEBIAN_MIRROR}/current/amd64/iso-cd/${STRETCH_BASE}

build/debian:
	sudo mkdir -p build/debian

build/debian/stretch/debian-stretch: base/${STRETCH_BASE} build/debian
	sudo -E ${packer} build debian-stretch.json

base/$(STRETCH_BASE): base
	wget --directory-prefix base ${STRETCH_URL}

debian-clean:

###
### Cumulus images
###
CUMULUS_MIRROR=http://cumulusfiles.s3.amazonaws.com
CUMULUS_BASE=cumulus-linux-3.5.0-vx-amd64.qcow2
CUMULUS_URL=${CUMULUS_MIRROR}/${CUMULUS_BASE}

build/cumulus:
	sudo mkdir -p build/cumulus

build/cumulus/3.5/cumulusvx-3.5: base/${CUMULUS_BASE} build/cumulus
	sudo -E ${packer} build cumulus-35.json

base/$(CUMULUS_BASE): base
	wget --directory-prefix base ${CUMULUS_URL}

# cracklib comes with an executable called 'packer' that typically goes into
# /usr/sbin, so when executing `sudo packer` on a system with cracklib that is 
# what gets resolved, save the packer path here for later use with sudo
packer=`which packer`

base:
	mkdir -p base

clean: fedora-clean debian-clean
	sudo rm -rf build

distclean: clean
	rm -rf base

