# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :otuslinux => {
    :box_name => "centos/7",
    :ip_addr => '192.168.11.101',
    :disks => {
      :sata1 => {
        :dfile => 'sata1.vdi',
        :size => 250,
        :port => 1
      },
      :sata2 => {
        :dfile => 'sata2.vdi',
        :size => 250, # Megabytes
        :port => 2
      },
      :sata3 => {
        :dfile => 'sata3.vdi',
        :size => 250,
        :port => 3
      },
      :sata4 => {
        :dfile => 'sata4.vdi',
        :size => 250, # Megabytes
        :port => 4
      },
      :sata5 => {
        :dfile => 'sata5.vdi',
        :size => 250, # Megabytes
        :port => 5
    }
    }
  },
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "1024"]
            needsController = false
            boxconfig[:disks].each do |dname, dconf|
              unless File.exist?(dconf[:dfile])
                vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                needsController =  true
              end

            end
            if needsController == true
              vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
              boxconfig[:disks].each do |dname, dconf|
                vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
              end
            end
          end
     box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        yum install -y mdadm smartmontools hdparm gdisk lvm2
        mdadm --create --verbose /dev/md0 -l6 -n5 /dev/sd{b,c,d,e,f}
        parted -s /dev/md0 mklabel gpt
        parted -s /dev/md0 mkpart primary ext4  0% 20%
        parted -s /dev/md0 mkpart primary ext4 20% 40%
        parted -s /dev/md0 mkpart primary ext4 40% 60%
        parted -s /dev/md0 mkpart primary ext4 60% 80%
        parted -s /dev/md0 mkpart primary ext4 80% 100%
        for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
        mkdir -p /raid/part{1,2,3,4,5}
        for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done


#        pvcreate /dev/md0
#        vgcreate vg0 /dev/md0
#        lvcreate -l100%FREE -n lv01 vg0
#        mkfs.ext4 /dev/vg0/lv01
#        mkdir /u01
#        mount /dev/vg0/lv01 /u01
      SHELL

      end
  end
end

