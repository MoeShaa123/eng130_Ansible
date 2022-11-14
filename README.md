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
- Enter `sudo ssh vagrant@192.168.56.10` enter then password `vagrant`, you should now be inside the web VM
- To return back to controller enter `exit`
- Now we want to ssh into web db from inside the controller VM
- Enter `sudo ssh vagrant@192.168.56.11` enter then password `vagrant`
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


