install
url --url http://mirror.unl.edu/centos/5.4/os/i386/
lang en_US.UTF-8
network --device eth0 --bootproto dhcp
# Bogus password, change to something sensible!
rootpw Change_This/ASAP
firewall --enabled --ssh
authconfig --enableshadow --enablemd5
selinux --enforcing 
timezone --utc America/Chicago
bootloader --location=mbr --driveorder=xvda,xvdb --append="console=xvc0"
reboot

# Partitioning
ignoredisk --drives=xvda,xvdh
clearpart --all --initlabel --drives=xvdb
part /boot --fstype ext3 --size=100 --ondisk=xvdb
part pv.2 --size=0 --grow --ondisk=xvdb
volgroup VolGroup00 --pesize=32768 pv.2
logvol / --fstype ext3 --name=LogVol00 --vgname=VolGroup00 --size=1024 --grow
logvol swap --fstype swap --name=LogVol01 --vgname=VolGroup00 --size=256 --grow --maxsize=512

%packages
@core

%post
( # Note that in this example we run the entire %post section as a subshell for logging.
for s in acpid anacron apmd autofs cpuspeed messagebus avahi-daemon bluetooth cpuspeed cups gpm haldaemon hidd irqbalance kudzu microcode_ctl netfs nfslock pcscd portmap rpcgssd rpcidmapd smartd; do
  chkconfig --level=12345 $s off
done
mkdir /mnt/newboot
mkfs.ext3 /dev/xvda
mount /dev/xvda /mnt/newboot
cp -a /boot /mnt/newboot
cd /mnt/newboot/boot
ln -s . boot
cd
umount /mnt/newboot
rmdir /mnt/newboot
umount /boot
e2label /dev/xvdb1 oldboot
e2label /dev/xvda /boot
# End the subshell and capture any output to a post-install log file.
) 1>/root/post_install.log 2>&1

