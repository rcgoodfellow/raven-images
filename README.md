# Raven Images

This repository contains raven images as code.

## Requirements

Linux : kvm enabled (verify kvm-ok)

Packer : https://www.packer.io/downloads.html

OSX [Untested] : some hacks would be necessary to disable kvm in the packer scripts

## Adding a new image

1. Create a top level packer script (labeled as operating system with json extention)

Templates can be found here: https://github.com/kaorimatz/packer-templates

2. Modify the json file to point to the correct distro mirror and sha256

3. Make any other edits, such as using cloud-init (fairly easy) or preseeding the config.

3. Edit Makefile to add your new operating system to the build list

## Building

```
make -j`nproc`
```

### Other useful commands

To clear out build artifacts
```
make clean
```

To clear out upstream base images and build artifacts
```
make distclean
```

### No X-server

* set headless in json to false
* use -nographic instead of gtk/sdl

