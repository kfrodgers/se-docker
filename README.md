# se-docker
Dockerfile and scripts to create and run Solutions Enabler in a Docker container

Creates a centos 7 base container running solutions enabler. The container uses a /usr/emc folder on the local system to maintain state between starts and stops. The container must run in privileged mode to obtain access to the /dev/sdX disk devices.

# Initial Setup

## Step 1: Clone GitHub Repo
Now that you're in your staging directory, you can clone [my GitHub repository](https://github.com/kfrodgers/se-docker.git) into your directory. You can do this via the 'git' CLI, or you can download one of the various git GUIs instead.

```bash
git clone https://github.com/kfrodgers/se-docker.git
```

## Step 2: Download Solutions Enabler Linux Binary
Unfortunately I can't distribute Solutions Enabler outside of the normal channel ([support.emc.com](http://support.emc.com)).

You want the Linux 64-bit binaries even if you're doing this on Mac or Windows, because Solutions Enabler will ultimately be running in a Linux container.

* Download [SE 8.2.0](https://download.emc.com/downloads/DL69077_Solutions_Enabler_8.2.0.0_for_Linux_x64.gz) and move it into the "./se-docker" directory.

## Step 3: Build Container
You can now use docker build to create the container image for solutions enabler

```bash
sudo docker build --rm -t se8200 ./se-docker
```

## Step 4: Run Start/Stop Command
The emc_se script is a very simple /etc/init.d script to start and stop your solutions enabler container. 

```bash
sudo cp ./se-docker/emc_se /etc/init.d
sudo /etc/init.d/emc_se start
```

This first start of SE will create the folder /usr/emc and populate it with the usual configuration, log, and database files.

## Step 5: Create Aliases
Edit the aliases file to set the desired location of the private key file (keypair.pem). Source the aliases file and verify connectivity. Note ssh access to the container is only possible via 127.0.0.1, this can be changed by modifying the emc_se script.

```bash
. ./se-docker/aliases
symcfg list
```

And that's it. 

## To Do's
* Remove requirement for privileged mode, first step to having multiple containers running on the same system
* User definable lockbox password
* Import license file
* Enable additional daemons. Currently only the storapid, storgnsd, storevntd and storwatchd daemons are running
* Enable remote SYMCLI server and client
* Docker Volumes/Flocker support. For a simple HA Solutions Enabler
