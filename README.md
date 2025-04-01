# Ansible Role: Setting Up Your System

## Metadata 
### **Installing tools and configuring your WorkStation**

With this repository you can install different tools that you need for your WorkStation, this repository will be prepared to install the tools in your Ubuntu, AlmaLinux or Manjaro distribution.

### **Requisites:**

 * Keys pair created and upload to SCM (Source Code Management)
 * Own User created in the Workstation

### **How to use:**

Run the next command in your home:

IMPORTANT: only execute this command the first time, this command is used only because its key pairs (public and private) are already generated in the machine that is being configured

```bash
mkdir SCM; cd SCM; GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"; git clone https://github.com/elsudano/setting-up-your-system
```

Prepare environment with the following command:

```bash
cd setting-up-your-system; chmod 0754 bootstrap.sh; ./bootstrap.sh
```

Delete the file `vault/Common.yml` and name `vault/Common.example` by the previous name, change the values of the variables by the correct data and save the file.

Please you need to do, the same procedure with the others files of the OS.

```bash
rm vault/Common.yml; mv vault/Common.example vault/Common.yml; nano vault/Common.yml
rm vault/Debian.yml; mv vault/Debian.example vault/Debian.yml; nano vault/Debian.yml
...
```

Then execute next command in the root path for to assign a secret encryption and decryption password, ofcourse change the text of *password*.

```bash
echo "password" > vault/credentials.txt
```

Run the next command for add you personal private key to the WorkStation

```bash
touch $HOME/.ssh/id_rsa; chmod 0600 $HOME/.ssh/id_rsa; nano $HOME/.ssh/id_rsa
```

Go to the root path of the project and run the differents targets in order, If you want see the different target in the Makefile only type `make`

Run the following command in order to download the Roles:

```bash
make 02_ansible-check
```

Run the next command in order to install the pre-requisites packages in your environment.

```bash
make 02_ansible-run EXTRA="-l local -t packages"
```

And finally run the following command in order to star with your configuration.

```bash
make 02_ansible-run EXTRA="-l local"
```

In this point of the installation is necessary reboot the VM

### **Dependencies:**

 - geerlingguy.ansible
 - geerlingguy.ntp
 - geerlingguy.docker
 - geerlingguy.pip
 - willshersystems.sshd

### **Author Information:**

Carlos de la Torre (<carlos.ariel.de.la.torre@gmail.com>)


## Variables
##### **Section generated automatically by ansible-autodoc. Do not modify, changes will be lost.**
---
###  Role vars
* `ntp_timezone`: In order to configure our NTP protocol we can choose which Time Zone we wantBy Default: Europe/Madrid
* `name_of_workstation`: We can change the name of our WorkstationBy Default: workstation
* `workstation_swapiness`: You can choose which is the value for your SwapinessBy Default is false
* `repo_list`: We can use this variable in order to set all the repositories that we want
* `package_list`: With this variable we can install or remove all the applications that we have or we want in our Workstation
* `workstation_string_of_public_key`: We will need the complete path of our Public Key in order to use our SCM (Source Code Management)
* `workstation_scm_name`: We will need set which is the name that we want in our SCM (Source Code Management)
* `workstation_scm_email`: We will need set which is the email that we want in our SCM (Source Code Management)

### Role defaults (required)
* `ntp_timezone`: In order to configure our NTP protocol we can choose which Time Zone we wantBy Default: Europe/Madrid
* `name_of_workstation`: We can change the name of our WorkstationBy Default: workstation
* `workstation_swapiness`: You can choose which is the value for your SwapinessBy Default is false
* `workstation_username`: In order to set the correct user name and the password we can use these variables
* `workstation_password`: In order to set the correct user name and the password we can use these variables
* `workstation_scm_token`: This variable regarding of Source Code Management is to make easier the connection with the SCM
* `workstation_id_gpg_key`: Value of GpG Key in order to sing your commits you can see which are you IDs with this command
* `workstation_private_key`: We will need the content of our Private Key in order to use our SCM (Source Code Management)

### Role defaults (non-required)
Not role defaults (non-required) found.
