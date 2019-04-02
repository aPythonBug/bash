#!/bin/bash
# Author: Dante
# Purpose: Create an LXD CentOS 7 VM on top of Ubuntu 16.04 LTS server
# License: GPL v2.0+
# ----------------------------------------------------------------------
## Set defaults ##
if_net="eth0" # vm interface
br_net="lxdbr0" # host bridge
if_net_sub="10.105.28.1/24" # subnet for br_net
if_net_ip="10.105.28.2" # IP for vm ## VM name ##
vm_name="dev" ## Vm distro. I am using CentOS ##

## You can use Gentoo, Arch, OpenSuse, Ubuntu, Debian, etc. 
vm_distro="centos/7/amd64" ## bin path ##
_apt="/usr/bin/apt-get"
_lxd="/usr/bin/lxd"
_lxc="/usr/bin/lxc" 

## Update base host ##
$_apt update
$_apt -y upgrade 

## Install LXD on base os ##
$_apt -y install lxd

## Create new networking bridge ##
$_lxd init --auto 
$_lxc network create ${br_net} ipv6.address=none ipv4.address=${if_net_sub} ipv4.nat=true 

## Create vm ##
$_lxc init images:${vm_distro} ${vm_name} 

## Config vm networking ##
$_lxc network attach ${br_net} ${vm_name} ${if_net}
$_lxc config device set ${vm_name} ${if_net} ipv4.address ${if_net_ip} 

## Start vm ##
$_lxc start ${vm_name} 

## Make sure vm boot after host reboots ##
$_lxc config set ${vm_name} boot.autostart true 

## Install updates in CentOS 7 VM ##
$_lxc exec ${vm_name} -- /usr/bin/yum -y update
$_lxc exec ${vm_name} -- /usr/bin/yum -y upgrade ## Install package (optional) ##
$_lxc exec ${vm_name} -- /usr/bin/yum -y install epel-release
$_lxc exec ${vm_name} -- /usr/bin/yum -y install htop vim git
