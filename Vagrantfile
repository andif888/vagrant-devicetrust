# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

Vagrant.configure("2") do |config|

    config.vm.provider :virtualbox do |v, override|
        #v.gui = true
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["modifyvm", :id, "--vram", 128]
        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end

    #
    # Domain Controller
    #

    config.vm.define "dc" do |dc|
      dc.vm.box = "gusztavvargadr/windows-server"
      dc.vm.communicator = "winrm"

      # Admin user name and password
      dc.winrm.username = "vagrant"
      dc.winrm.password = "vagrant"

      dc.vm.guest = :windows
      dc.windows.halt_timeout = 15

      dc.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true

      dc.vm.network "private_network", ip: "192.168.123.2",
        virtualbox__intnet: true

      dc.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 2048]
        vb.customize ["modifyvm", :id, "--cpus", 2]
      end

      dc.vm.provision "shell",
        name: "enable-winrm-for-ansible",
        path: "scripts/enable-winrm-for-ansible.ps1"

    end

    #
    # Remote Desktop Session Host
    #

    config.vm.define "rdsh" do |rdsh|
      rdsh.vm.box = "gusztavvargadr/windows-server"
      rdsh.vm.communicator = "winrm"

      # Admin user name and password
      rdsh.winrm.username = "vagrant"
      rdsh.winrm.password = "vagrant"

      rdsh.vm.guest = :windows
      rdsh.windows.halt_timeout = 15

      rdsh.vm.network :forwarded_port, guest: 3389, host: 3390, id: "rdp", auto_correct: true

      rdsh.vm.network "private_network", ip: "192.168.123.3",
        virtualbox__intnet: true

      rdsh.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 3072]
        vb.customize ["modifyvm", :id, "--cpus", 2]
      end

      rdsh.vm.provision "shell",
        name: "enable-winrm-for-ansible",
        path: "scripts/enable-winrm-for-ansible.ps1"

    end

    #
    # Window Corporate Client
    #

    config.vm.define "w10" do |w10|
      w10.vm.box = "gusztavvargadr/windows-10"
      w10.vm.communicator = "winrm"

      # Admin user name and password
      w10.winrm.username = "vagrant"
      w10.winrm.password = "vagrant"

      w10.vm.guest = :windows
      w10.windows.halt_timeout = 15

      w10.vm.network :forwarded_port, guest: 3389, host: 3391, id: "rdp", auto_correct: true

      w10.vm.network "private_network", ip: "192.168.123.4",
        virtualbox__intnet: true

      w10.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 3072]
        vb.customize ["modifyvm", :id, "--cpus", 2]
      end

      # w10.vm.provision "firewall", type: "shell",
      #   inline: "netsh advfirewall set allprofiles state off",
      #   run: "always"

      w10.vm.provision "powerconfig", type: "shell",
        inline: "POWERCFG /SETACTIVE SCHEME_MIN"

      w10.vm.provision "winrm", type: "shell",
        name: "enable-winrm-for-ansible",
        path: "scripts/enable-winrm-for-ansible.ps1"

    end

    #
    # Unmanaged Client
    #

    config.vm.define "byod" do |byod|
      byod.vm.box = "gusztavvargadr/windows-10"
      byod.vm.communicator = "winrm"

      # Admin user name and password
      byod.winrm.username = "vagrant"
      byod.winrm.password = "vagrant"

      byod.vm.guest = :windows
      byod.windows.halt_timeout = 15

      byod.vm.network :forwarded_port, guest: 3389, host: 3393, id: "rdp", auto_correct: true

      byod.vm.network "private_network", ip: "192.168.123.5",
        virtualbox__intnet: true

      byod.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 3072]
        vb.customize ["modifyvm", :id, "--cpus", 2]
      end

      byod.vm.provision "powerconfig", type: "shell",
        inline: "POWERCFG /SETACTIVE SCHEME_MIN"

      byod.vm.provision "winrm", type: "shell",
        name: "enable-winrm-for-ansible",
        path: "scripts/enable-winrm-for-ansible.ps1"

    end


    #
    # Controller Machine for Ansible
    #

    config.vm.define "ctrl" do |ctrl|
      ctrl.vm.box = "ubuntu/xenial64"

      ctrl.vm.network :forwarded_port, guest: 3389, host: 3392, id: "rdp"

      ctrl.vm.network "private_network", virtualbox__intnet: true, ip: "192.168.123.99"

      ctrl.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 2048]
        vb.customize ["modifyvm", :id, "--cpus", 2]
      end

      ctrl.vm.provision "copy_scripts", type: "file", source: "./scripts", destination: "/tmp/scripts"      

      ctrl.vm.provision "shell_prepare_controller", type: "shell", inline: <<-SHELL
        /tmp/scripts/prepare_controller.sh
        rsync -a /vagrant/ansible/ /tmp/ansible/
      SHELL

      ctrl.vm.provision "shell_download_ansible_roles", type: "shell", inline: <<-SHELL
        ansible-galaxy install -v -r /tmp/ansible/requirements.yml -p /tmp/ansible/roles/
      SHELL

      ctrl.vm.provision "shell_run_ansible_playbook", type: "shell", inline: <<-SHELL
        cd /tmp/ansible
        ansible-playbook site.yml --inventory-file=inventory
      SHELL

    end


end
