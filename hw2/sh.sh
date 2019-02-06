sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sd[bc]3 --metadata=0.90
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[bc]2 --metadata=0.90
sudo mkfs.ext4 /dev/md1
sudo mkfs.ext4 /dev/md0

sudo mkdir /mnt/root
sudo mount /dev/md1 /mnt/root
sudo mount /mnt/root/boot
sudo mount /dev/md0 /mnt/root/boot
cd /
#sudo cp -r !(sys|mnt|boot|vagrant|swapfile|tmp|media|proc|dev|run) /mnt/root 
sudo cp -ax !(sys|mnt|vagrant|swapfile|media|proc|dev) /mnt/root 





sudo mdadm --stop /dev/md0
sudo mdadm --stop /dev/md1
sudo mdadm --zero-superblock /dev/sd[bc][23]
