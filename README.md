
# Bachelor Thesis Project: Automated Setup of Suricata, Zeek, and Snort on AlmaLinux, Alpine, and Debian

This repository contains Vagrant environments that automate the installation and configuration of Network Intrusion Detection and Prevention Systems (NIDPS), including Suricata, Zeek, and Snort, on AlmaLinux, Alpine, and Debian. These environments automatically perform tests to measure the memory usage of these systems.

## Project Overview

This project is part of my bachelor thesis. Its goal is to compare the memory usage of three different NIDPS tools (Suricata, Zeek, and Snort) across three Linux distributions: AlmaLinux, Alpine, and Debian. The results provide insights into the memory efficiency of each tool in these different environments.

### Tools & Systems

- **Suricata**: A high-performance Network IDS, IPS, and Network Security Monitoring engine.
- **Zeek**: A powerful network analysis framework designed for traffic analysis.
- **Snort**: An open-source network intrusion detection system capable of detecting various types of attacks and probes.
- **Operating Systems**: AlmaLinux, Alpine Linux, and Debian

## Prerequisites

Before running these Vagrant environments, make sure you have the following installed:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Git (to clone this repository)

## How to Run the Environments

### Step 1: Clone the Repository

Clone this repository to your local machine using Git:

```bash
git clone https://github.com/your-username/your-repo-name.git
```

### Step 2: Navigate to the Desired Tool Directory

Navigate to the directory for the NIDPS tool and operating system you want to run. For example, to run Suricata on AlmaLinux:

```bash
cd almalinux/suricata
```
### Step 3: Adjusting Memory Allocation

If you wish to adjust the memory allocation for the virtual machine, you can do so by editing the `Vagrantfile` inside the respective directory. Locate the memory setting of the router and change it to your desired value. For example:

```ruby
    router.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"  # Adjust this value (in MB) as needed
      vb.cpus = 1
    end
```

Change the `2048` to the amount of memory you want to allocate in megabytes.

### Step 5 (optional): Changing the Attack Test

If you want to change the attack being tested, edit the `TestScript.sh` and `Attacker.sh` scripts located in the `provision` folder. At the bottom of each script, you can swap out the tests according to your needs by replacing the `#` in each script.

`Attacker.sh`
```
#sudo nohup ./AttackNmap.sh &

sudo nohup ./AttackSQL.sh &
```

`TestScript.sh`
```
# Nmap test
#cp "$logfile" /vagrant/Results/

# SQL test
cp "$logfile" /vagrant/Results/SQL/
```

### Step 6: Start the Vagrant Environment

Once inside the desired directory, start the virtual machine by running the following command:

```bash
vagrant up
```

This command will provision the virtual machine, install the necessary NIDPS tool, and run memory usage tests automatically. That will be stored in the results folder.



### Step 7: Destroy the Environment

If the test is done, remove the environment

```bash
vagrant destroy
```

## Test Results

After running the memory usage tests, the results will be saved in the respective NIDPS tool's directory. You can review these logs to assess memory usage performance across different operating systems.

## Customization

You can customize the environments by modifying the `Vagrantfile` or any included scripts to adjust system settings or extend the tests. Feel free to add new configurations based on your needs.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
