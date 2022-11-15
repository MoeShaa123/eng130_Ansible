## What is Infrastructure as Code

- Infrastructure as Code (IaC) is the managing and provisioning of infrastructure through code instead of through manual processes.

- With IaC, configuration files are created that contain your infrastructure specifications, which makes it easier to edit and distribute configurations.

- Orchestration means arranging or coordinating multiple systems. It’s also used to mean “running the same tasks on a bunch of servers at once

- Automating infrastructure provisioning with IaC means that developers don’t need to manually provision and manage servers, operating systems, storage, and other infrastructure components each time they develop or deploy an application.

![image](https://user-images.githubusercontent.com/106158041/201669403-3d8404e0-dc0e-463e-9a04-57f62468e73a.png)


## What is Ansible

- Ansible is the simplest way to automate apps and IT infrastructure.

- It uses YAML which is simple and easy to learn.

- In Ansible, there are two categories of computers: the control node and managed nodes. The control node is a computer that runs Ansible.

- Ansible is agentless, which means the nodes it manages do not require any software to be installed on them.

![ansible drawio](https://user-images.githubusercontent.com/106158041/201671556-2631ce7c-1e76-4563-bc52-306ad0000b6d.png)

- The Ansible inventory file defines the hosts and groups of hosts upon which commands, modules, and tasks in a playbook operate.

- Ansible roles allow you to develop reusable automation components by grouping related automation artifacts, like configuration files, templates, tasks, and handlers. Because roles isolate these components, it's easier to reuse them and share them with other people.


## Setup

- SSH into Controller VM
- Run Update and Upgrade
- Run `sudo apt-get install software-properties-common`
- Run `sudo apt-add-repository ppa:ansible/ansible`
- Run `Sudo apt-get update`
- Run `sudo apt-get install ansible -y`
- Install tree `sudo apt-get install tree `
- cd into `cd /etc/ansible`
- Enter `sudo ssh vagrant@192.168.33.10` enter then password `vagrant`, you should now be inside the web VM
- To return back to controller enter `exit`
- Now we want to ssh into web db from inside the controller VM
- Enter `sudo ssh vagrant@192.168.33.11` enter then password `vagrant`
- Now exit to go back to controller VM
- Enter `cd /etc/ansible` and `sudo nano hosts`
- In Ex 2 edit the hosts
```
[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```
- Now run `sudo ansible all -m ping` to ensure ping receives pong from both nodes
- To run command for both nodes from controller `sudo ansible all -a "date"` 

- To copy data from controller to agent nodes `sudo ansible web -m copy -a "src=hosts dest=/home/vagrant"`

- To run the provision file when starting VM add this to Vagrantfile `controller.vm.provision "shell", path: "provision.sh"`

## YAML Playbooks

### Installing Nginx
```
# Yaml file start
---
# create a script to configure nginx in our web server

# who is the host - name of the server
- hosts: web

# gather data
  gather_facts: yes

# We need admin access
  become: true

# add the actual instruction
  tasks:
  - name: Install/configure Nginx Web server in web-VM
    apt: pkg=nginx state=present

# we need to ensure a the end of the script the status of nginx is running
```

### Installing Nodejs
```
# Yaml file start
---
# create a script to install node in our web server

# who is the hosts - means name of the server
- hosts: web

# gather data
  gather_facts: yes
# we need admin access
  become: true
# add the actual instructions
  tasks:
  - name: "Add nodejs apt key"
    apt_key:
      url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key 
      state: present
# Add nodesource repository
  - name: "Add nodejs 12.x ppa for apt repo"
    apt_repository:
      repo: deb https://deb.nodesource.com/node_12.x bionic main
      update_cache: yes
# Install Node.js
  - name: "Install nodejs"
    apt:
      update_cache: yes
      name: nodejs
      state: present
      
```
### Copying the App folder to the Web server
```
# Yaml File
---
- name: Ansible Copy Directory Example Local to Remote
  hosts: web
  tasks:
    - name: Copying the Directory's contents (sub directories/files)
      become: true
      copy:
        src: /home/vagrant/app
        dest: /home/vagrant
        mode: 0644
```

### Setting up Reverse Proxy 
```
        # Set up reverse proxy

  - name: Remove Nginx default file
    file:
      path: /etc/nginx/sites-enabled/default
      state: absent

  - name: Create file reverse_proxy.config with read and write permissions for everyone
    file:
      path: /etc/nginx/sites-enabled/reverse_proxy.conf
      state: touch
      mode: '666'

  - name: Inject lines into reverse_proxy.config
    blockinfile:
      path: /etc/nginx/sites-enabled/reverse_proxy.conf
      block: |
        server{
          listen 80;
          server_name development.local;
          location / {
              proxy_pass http://localhost:3000;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection 'upgrade';
              proxy_set_header Host $host;
              proxy_cache_bypass $http_upgrade;
          }
        }

        # Links the new configuration file to NGINX’s sites-enabled using a command.

  - name: link reverse_proxy.config
    file:
      src: /etc/nginx/sites-enabled/reverse_proxy.conf
      dest: /etc/nginx/sites-available/reverse_proxy.conf
      state: link

  - name: Restart Nginx
    shell: |
      sudo systemctl restart nginx

```
### Installing MongoDB and changing conf file

```
---

# Specifies the host
- hosts: db

# Get the facts
  gather_facts: yes

# Give us admin access
  become: true

  tasks:

# Installs mongodb
  - name: Install mongodb
    apt: pkg=mongodb state=present

# Deletes the configuration file as we need to make changes to it
  - name: Delete mongodb.conf file
    file:
      path: /etc/mongodb.conf
      state: absent

# Create a new file called mongodb.conf with read and write permissions for everyone

  - name: Create new mongodb.conf file with read and write permissions for everyone
    file:
      path: /etc/mongodb.conf
      state: touch
      mode: '666'

# Fills the file with the information again but with bindIp being 0.0.0.0
  - name: Inject lines into the newly created mongodb.conf
    blockinfile:
      path: /etc/mongodb.conf
      block: |
        "storage:
          dbPath: /var/lib/mongodb
          journal:
            enabled: true
        systemLog:
          destination: file
          logAppend: true
          path: /var/log/mongodb/mongod.log
        net:
          port: 27017
          bindIp: 0.0.0.0"
```
