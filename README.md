# vagrant deviceTRUST

this repo provisions a complete test environment for deviceTRUST (https://devicetrust.de/) using Vagrant und VirtualBox.

It spins up the following VMs:

- DC - Windows Domain Controller
- RDSH - Windows Remote Desktop Session Host
- W10 - Windows 10 Client, which has joined the AD Domain
- BYOD -  Windows 10 Client without domain join

## Requirements
You need a decent notebook or PC with a good amount of RAM (16 GB or more is recommended). 
It doesn't matter if it's Windows, MacOS or Linux. Ensure that VirtualBox and Vagrant is installed. 
To install VirtualBox please checkout https://www.virtualbox.org/wiki/Downloads 
To install Vargant please checkout https://www.vagrantup.com/downloads.html

## Using this repo

Clone the repo using 
```
git clone https://github.com/andif888/vagrant-devicetrust
```

after cloning the repo, change to the local directory using
```
cd vagrant-devicetrust
```

to run the test environment run
```
vagrant up
```

now be patient, it will take a while. 
Dependent on your internet connection speed it will take some time to download the Windows base images for the first time.  
Sub sequent runs will start much faster.

to stop the test environment run
```
vagrant halt
```

to destroy and cleanup the test environment, run
```
vagrant destroy
```

## Logon credentials
Default domain logon credentials are defined in [ansible/vars/generic.yml](ansible/vars/generic.yml)

Every VM has also the default vagrant credentials for the local user:  
Username: vagrant  
Password: vagrant  