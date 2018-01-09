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
all: fedora debian cumulus freebsd


.PHONY: fedora
fedora: build/fedora/27/fedora-27

.PHONY: debian
debian: build/debian/stretch/debian-stretch  

.PHONY: cumulus
cumulus: build/cumulus/3.5/cumulusvx-3.5

.PHONY: freebsd
freebsd: \
	build/freebsd/11/freebsd-11 \
	build/freebsdr/11/freebsd-11r \
	build/freebsdd/11/freebsd-11d

.PHONY: install
install: fedora-install debian-install cumulus-install freebsd-install freebsdr-install

###
### Fedora images
### 
FEDORA_MIRROR=http://mirrors.kernel.org/fedora/releases
F27_BASE=Fedora-Cloud-Base-27-1.6.x86_64.qcow2
F27_URL=${FEDORA_MIRROR}/27/CloudImages/x86_64/images/${F27_BASE}

build/fedora:
	sudo mkdir -p build/fedora

build/fedora/27/fedora-27: base/${F27_BASE} build/fedora fedora-27.json cloud-init/build-iso.sh cloud-init/fedora27/user-data cloud-init/fedora27/meta-data
	cd cloud-init; ./build-iso.sh
	sudo rm -rf build/fedora/27
	sudo -E ${packer} build fedora-27.json

base/$(F27_BASE): base
	wget --directory-prefix base ${F27_URL}

fedora-clean:
	rm -rf cloud-init/*.iso

fedora-install: build/fedora/27/fedora-27
	sudo install $< /var/rvn/img/fedora-27.qcow2

###
### Debian images
###
DEBIAN_MIRROR=http://cdimage.debian.org/debian-cd
STRETCH_BASE=debian-9.3.0-amd64-netinst.iso
STRETCH_URL=${DEBIAN_MIRROR}/current/amd64/iso-cd/${STRETCH_BASE}

build/debian:
	sudo mkdir -p build/debian

build/debian/stretch/debian-stretch: base/${STRETCH_BASE} build/debian debian-stretch.json
	sudo rm -rf build/debian/stretch
	sudo -E ${packer} build debian-stretch.json

base/$(STRETCH_BASE): base
	wget --directory-prefix base ${STRETCH_URL}

debian-clean:

debian-install: build/debian/stretch/debian-stretch
	sudo install $< /var/rvn/img/debian-stretch.qcow2

###
### Cumulus images
###
CUMULUS_MIRROR=http://cumulusfiles.s3.amazonaws.com
CUMULUS_BASE=cumulus-linux-3.5.0-vx-amd64.qcow2
CUMULUS_URL=${CUMULUS_MIRROR}/${CUMULUS_BASE}

build/cumulus:
	sudo mkdir -p build/cumulus

build/cumulus/3.5/cumulusvx-3.5: base/${CUMULUS_BASE} build/cumulus cumulus-35.json
	sudo rm -rf build/cumulus/3.5
	sudo -E ${packer} build cumulus-35.json

base/$(CUMULUS_BASE): base
	wget --directory-prefix base ${CUMULUS_URL}

cumulus-install: build/cumulus/3.5/cumulusvx-3.5
	sudo install $< /var/rvn/img/cumulusvx-3.5.qcow2


###
### Freebsd Images
###
FREEBSD_MIRROR=http://ftp.freebsd.org
FREEBSD11_BASE=FreeBSD-11.1-RELEASE-amd64-disc1.iso
FREEBSD11_URL=${FREEBSD_MIRROR}/pub/FreeBSD/releases/ISO-IMAGES/11.1/${FREEBSD11_BASE}

# freebsd-11

base/$(FREEBSD11_BASE): base
	wget --directory-prefix base ${FREEBSD11_URL}

build/freebsd:
	sudo mkdir -p build/freebsd


build/freebsd/11/freebsd-11: base/${FREEBSD11_BASE} build/freebsd freebsd-11.json
	sudo rm -rf build/freebsd/11
	sudo -E ${packer} build freebsd-11.json

freebsd-install: build/freebsd/11/freebsd-11
	sudo install $< /var/rvn/img/freebsd-11.qcow2

# freebsd-11r

build/freebsdr:
	sudo mkdir -p build/freebsdr

build/freebsdr/11/freebsd-11r: base/${FREEBSD11_BASE} build/freebsdr freebsd-11-router.json
	sudo rm -rf build/freebsdr/11
	sudo -E ${packer} build freebsd-11-router.json

freebsdr-install: build/freebsdr/11/freebsd-11r
	sudo install $< /var/rvn/img/freebsd-11r.qcow2

# freebsd-11d

build/freebsdd:
	sudo mkdir -p build/freebsdd

build/freebsdd/11/freebsd-11d: base/${FREEBSD11_BASE} build/freebsdd freebsd-11-deter.json
	sudo rm -rf build/freebsdd/11
	sudo -E ${packer} build freebsd-11-deter.json

freebsdd-install: build/freebsdd/11/freebsd-11r
	sudo install $< /var/rvn/img/freebsd-11r.qcow2

###
### Helpers
###

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
