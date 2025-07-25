---
title: KVM on Linux Mint 18
date: '2017-03-18 09:34:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
- vmware
- kvm
- koha
---

I've been running [Koha](https://koha-community.org/) on Debian 8 in a VMware Workstation virtual
machine, to test it prior to deployment on Linode for a real library.
Yesterday I decided to investigate running this VM in KVM, the native
Linux virtualization system that is used at Linode.  The conversion
went well on both Linux Mint 17 and 18.  What follows are the steps I
used on Mint 18 (Mate edition).

<!--more-->

First, install the necessary packages to use KVM via
a user-friendly GUI:

    sudo apt-get install virt-manager libvirt-bin
    suto apt-get install qemu-system gir1.2-spice-client-gtk-3.0

Then add yourself to the `libvirtd` group:

    sudo usermod -a -G libvirtd $USER

If your Workstation virtual disk is split into multiple files,
you'll need to convert it to a single file.  In this example,
I had a multi-file virtual disk whose configuration file was
`Debian.vmdk`.  I converted this using:

    vmware-vdiskmanager -r Debian8.vmdk -t 0 DebianKVM.vmdk

Then you'll need to convert this disk to a form that
can be used by KVM.  In this example, I used:

    qemu-img convert DebianKVM.vmdk -O qcow2 DebianKVM.qcow2

Now you can run `virt-manager` from the Menu.  Create a new virtual
machine, select "Import existing disk image", and at the next
step, specify the path to the qcow2 disk image that you just created
(`DebianKVM.qcow2` in this example).

The following network-related steps are optional.

KVM provides an IP address to the VM via DHCP, but that address could
change, depending on whether other VMs are also in use. If your VM
contains a server that you wish to access from the host,
it helps to lock down the VM to a fixed IP address.

After booting the VM, log into it and discover its MAC address using:

    ifconfig | egrep HWaddr

You should see something like this:

    eth0      Link encap:Ethernet  HWaddr 52:54:00:a4:37:19  

The MAC address is the colon-separated series of two digit hex numbers after "HWaddr".

Back on the host, use this command to edit the KVM network configuration:

    virsh net-edit default

An editor will run on the network configuration, with contents that
look something like this:

    <network>
      <name>default</name>
      <uuid>8311c6cc-f2fe-4618-bcf8-fe15167ac643</uuid>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <mac address='52:54:00:66:1b:8d'/>
      <ip address='192.168.122.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.122.2' end='192.168.122.254'/>
        </dhcp>
      </ip>
    </network>

In the dhcp section, change the range start to 192.168.122.20, and insert a line
like the following after the range start line:

          <host mac='52:54:00:a4:37:19' name='kvm' ip='192.168.122.11'/>

Be sure to change the MAC address to the one you determined earlier using ifconfig in the VM,
and choose an IP address that is below the DHCP range start.  The resulting configuration
should look like this:

    <network>
      <name>default</name>
      <uuid>8311c6cc-f2fe-4618-bcf8-fe15167ac643</uuid>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <mac address='52:54:00:66:1b:8d'/>
      <ip address='192.168.122.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.122.20' end='192.168.122.254'/>
          <host mac='52:54:00:a4:37:19' name='kvm' ip='192.168.122.11'/>
        </dhcp>
      </ip>
    </network>

After exiting the editor, restart the virtual network using:

    virsh net-destroy default
    virsh net-start default

In the VM, restart the network services to obtain a new IP address,
or reboot the VM to be on the convervative side.  In the VM, 
use the `ifconfig` command to verify that the new IP
address is the one that you configured earlier in the
"host mac" line.

Now you can access your VM from the host using
the new IP address.  To avoid having to memorize that
address and type it everywhere, add a line like the following
to `/etc/hosts` (as root, of course):

    192.168.122.11  kvm.example.com

If your situation is more complex (e.g., if you have more than one
virtual network), [this posting](http://serverfault.com/questions/627238/kvm-libvirt-how-to-configure-static-guest-ip-addresses-on-the-virtualisation-ho)
may help.

{{< callout type="info" >}}
If virt-manager complains that KVM is not available when you try
to create a virtual machine, the problem may be that virtualization is
not enabled in the BIOS.  On a ThinkPad, enter the BIOS by pressing the blue
ThinkVantage button after powering on the system.  Then press F1 to enter
the BIOS setup.  Select Config, then CPU, then enable Virtualization.
Press F10 to save and exit.  The system will power itself off, then power
on again with virtualization enabled.
{{< /callout >}}
