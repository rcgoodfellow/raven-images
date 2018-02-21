# update grub
sudo sed \
  -ie \
  's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' \
  /etc/default/grub

# this seems to be the line that fixes eth0
sudo sed -ie 's/ens3/eth0/g' /etc/udev/rules.d/70-persistent-net.rules

sudo sed -ie "s/ens3/eth0/g" /etc/network/interfaces.d/50-cloud-init.cfg

sudo update-grub
