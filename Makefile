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
all: fedora debian ubuntu cumulus freebsd


.PHONY: fedora
fedora: build/fedora/27/fedora-27

.PHONY: debian
debian: build/debian/stretch/debian-stretch

.PHONY: ubuntu
ubuntu: build/ubuntu/1604/ubuntu

.PHONY: cumulus
cumulus: build/cumulus/3.5/cumulusvx-3.5

.PHONY: freebsd
freebsd: \
	build/freebsd/11/freebsd-11 \
	build/freebsdr/11/freebsd-11r \
	build/freebsdd/11/freebsd-11d

.PHONY: install
install: fedora-install debian-install ubuntu-install cumulus-install freebsd-install freebsdr-install

###
### Fedora images
### 
FEDORA_MIRROR=http://mirrors.kernel.org/fedora/releases
F27_BASE=Fedora-Cloud-Base-27-1.6.x86_64.qcow2
F27_URL=${FEDORA_MIRROR}/27/CloudImages/x86_64/images/${F27_BASE}

build/fedora:
	sudo mkdir -p build/fedora

build/fedora/27/fedora-27: fedora-27.json cloud-init/fedora27-config.iso | build/fedora base/${F27_BASE} 
	cd cloud-init; ./build-iso-fedora.sh
	sudo rm -rf build/fedora/27
	sudo -E ${packer} build fedora-27.json

cloud-init/fedora27-config.iso: cloud-init/build-iso-fedora.sh cloud-init/fedora27/user-data cloud-init/fedora27/meta-data

base/$(F27_BASE): | base
	wget --directory-prefix base ${F27_URL}

.PHONY: fedora-clean
fedora-clean:
	rm -rf cloud-init/*fedora*.iso

.PHONY: fedora-install
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

build/debian/stretch/debian-stretch: debian-stretch.json | build/debian base/${STRETCH_BASE} 
	sudo rm -rf build/debian/stretch
	sudo -E ${packer} build debian-stretch.json

base/$(STRETCH_BASE): | base
	wget --directory-prefix base ${STRETCH_URL}

.PHONY: debian-clean
debian-clean:

.PHONY: debian-install
debian-install: build/debian/stretch/debian-stretch
	sudo install $< /var/rvn/img/debian-stretch.qcow2


###
### Ubuntu images
###
UBUNTU_MIRROR=https://cloud-images.ubuntu.com
UBUNTU_1604=ubuntu-16.04-server-cloudimg-amd64-disk1.img
UBUNTU_URL=${UBUNTU_MIRROR}/releases/16.04/release/${UBUNTU_1604}

build/ubuntu/1604/ubuntu: ubuntu-1604.json cloud-init/ubuntu-1604-config.iso | build/ubuntu base/${UBUNTU_1604} 
	sudo rm -rf build/ubuntu/1604
	sudo -E ${packer} build ubuntu-1604.json

cloud-init/ubuntu-1604-config.iso: cloud-init/build-iso-ubuntu.sh cloud-init/ubuntu1604/user-data cloud-init/ubuntu1604/meta-data 
	cd cloud-init; ./build-iso-ubuntu.sh

build/ubuntu:
	sudo mkdir -p build/ubuntu

base/$(UBUNTU_1604): | base
	wget --directory-prefix base ${UBUNTU_URL}

.PHONY: ubuntu-clean
ubuntu-clean:
	rm -rf cloud-init/*ubuntu*.iso

.PHONY: ubuntu-install
ubuntu-install: build/ubuntu/1604/ubuntu-1604
	sudo install $< /var/rvn/img/ubuntu-1604.qcow2


###
### Cumulus images
###
CUMULUS_MIRROR=http://cumulusfiles.s3.amazonaws.com
CUMULUS_BASE=cumulus-linux-3.5.0-vx-amd64.qcow2
CUMULUS_URL=${CUMULUS_MIRROR}/${CUMULUS_BASE}

build/cumulus:
	sudo mkdir -p build/cumulus

build/cumulus/3.5/cumulusvx-3.5: cumulus-35.json | build/cumulus base/${CUMULUS_BASE} 
	sudo rm -rf build/cumulus/3.5
	sudo -E ${packer} build cumulus-35.json

base/$(CUMULUS_BASE): | base
	wget --directory-prefix base ${CUMULUS_URL}

.PHONY: cumulus-install
cumulus-install: build/cumulus/3.5/cumulusvx-3.5
	sudo install $< /var/rvn/img/cumulusvx-3.5.qcow2


###
### Freebsd Images
###
FREEBSD_MIRROR=http://ftp.freebsd.org
FREEBSD11_BASE=FreeBSD-11.1-RELEASE-amd64-disc1.iso
FREEBSD11_URL=${FREEBSD_MIRROR}/pub/FreeBSD/releases/ISO-IMAGES/11.1/${FREEBSD11_BASE}

# freebsd-11

base/$(FREEBSD11_BASE): | base
	wget --directory-prefix base ${FREEBSD11_URL}

build/freebsd:
	sudo mkdir -p build/freebsd


build/freebsd/11/freebsd-11: freebsd-11.json | build/freebsd base/${FREEBSD11_BASE} 
	sudo rm -rf build/freebsd/11
	sudo -E ${packer} build freebsd-11.json

.PHONY: freebsd-install
freebsd-install: build/freebsd/11/freebsd-11
	sudo install $< /var/rvn/img/freebsd-11.qcow2

# freebsd-11r

build/freebsdr:
	sudo mkdir -p build/freebsdr

build/freebsdr/11/freebsd-11r: freebsd-11-router.json | base/${FREEBSD11_BASE} build/freebsdr 
	sudo rm -rf build/freebsdr/11
	sudo -E ${packer} build freebsd-11-router.json

.PHONY: freebsdr-install
freebsdr-install: build/freebsdr/11/freebsd-11r
	sudo install $< /var/rvn/img/freebsd-11r.qcow2

# freebsd-11d

build/freebsdd:
	sudo mkdir -p build/freebsdd

build/freebsdd/11/freebsd-11d: freebsd-11-deter.json | base/${FREEBSD11_BASE} build/freebsdd 
	sudo rm -rf build/freebsdd/11
	sudo -E ${packer} build freebsd-11-deter.json

.PHONY: freebsdd-install
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

.PHONY: clean
clean: fedora-clean debian-clean ubuntu-clean
	sudo rm -rf build

.PHONY: distclean
distclean: clean
	rm -rf base
