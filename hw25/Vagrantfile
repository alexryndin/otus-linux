# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :nginx => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.10', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "vpn-net"},
                ]
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxname.to_s

      boxconfig[:net].each do |ipconf|
        box.vm.network "private_network", ipconf
      end

      if boxconfig.key?(:public)
        box.vm.network "public_network", boxconfig[:public]
      end

      if boxconfig.key?(:private_net)
        box.vm.network "private_network", ip: boxconfig[:private_net][:ip]
      end

      box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
        SHELL

      case boxname.to_s
      when "nginx"
        config.vm.network "forwarded_port", guest: 8080, host: 80
        config.vm.network "forwarded_port", guest: 8080, host: 8080
        box.vm.provision "shell", run: "always", inline: <<-SHELL
            yum install epel-release -y
            yum install nginx -y
            cp /vagrant/nginx.conf /etc/nginx
            systemctl start nginx
            SHELL
      end
    end
  end
end
