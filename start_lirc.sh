#!/bin/bash
/etc/init.d/lirc stop
rmmod lirc_it87
echo activate > /sys/devices/pnp0/00:09/resources
modprobe lirc_it87
/etc/init.d/lirc start
