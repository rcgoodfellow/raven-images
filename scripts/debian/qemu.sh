sudo sed \
  -ie \
  's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet net.ifnames=0 biosdevname=0"/g' \
  /etc/default/grub

sudo sed \
  -ie \
  "s/ens3/eth0/g" \
  /etc/network/interfaces

sudo update-grub

