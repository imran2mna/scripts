#!/bin/bash

UUID="20161028"
RID="19870214"

ROUTER_IP="192.168.2.1/24"
DHCP_IP="192.168.2.2/24"
INST_IP="192.168.2.7/24"


## clear previous enviroment ##
ovs-vsctl del-br br-int
ovs-vsctl del-br br-ex
ovs-vsctl del-br br-tun

ip link delete qbr${UUID}
ip link delete tap${UUID}
ip link delete qvb${UUID}

ip netns exec qrouter-${RID} ip link delete qr_${RID}
ip netns exec qdhcp-${RID}   ip link delete qd_${RID}

ip netns del qrouter-${RID}
ip netns del qdhcp-${RID}

echo "Deleting previous configurations..." && sleep 3

##########################################################
# configure switch layers
##########################################################
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
ovs-vsctl add-br br-tun

ovs-vsctl add-port br-int patch-tun -- set interface patch-tun type=internal
ovs-vsctl set interface patch-tun type=patch 
ovs-vsctl set interface patch-tun options:peer=patch-int

ovs-vsctl add-port br-tun patch-int -- set interface patch-int type=internal
ovs-vsctl set interface patch-int type=patch 
ovs-vsctl set interface patch-int options:peer=patch-tun

ovs-vsctl add-port br-int int-br-ex -- set interface int-br-ex type=internal
ovs-vsctl set interface int-br-ex type=patch 
ovs-vsctl set interface int-br-ex options:peer=phy-br-ex 

ovs-vsctl add-port br-ex phy-br-ex  -- set interface phy-br-ex type=internal
ovs-vsctl set interface phy-br-ex type=patch 
ovs-vsctl set interface phy-br-ex options:peer=int-br-ex

# bring up bridges  
ip link set dev br-int up
ip link set dev br-ex up
ip link set dev br-tun up 

# add physical port into br-ex

##########################################################
# configure dhcp level 
##########################################################
ip netns add qrouter-${RID}
ip netns add qdhcp-${RID}

ip link add ri-${RID} type veth peer name qr_${RID}
ip link add di-${RID} type veth peer name qd_${RID}

ip link set dev qr_${RID} netns qrouter-${RID}
ip link set dev qd_${RID} netns qdhcp-${RID}

ip netns exec qrouter-${RID} ip addr add ${ROUTER_IP} dev qr_${RID}
ip netns exec qdhcp-${RID} ip addr add ${DHCP_IP} dev qd_${RID}

ip netns exec qrouter-${RID} ip link set dev qr_${RID} up
ip netns exec qdhcp-${RID} ip link set dev qd_${RID} up

ovs-vsctl add-port br-int ri-${RID} tag=20
ovs-vsctl add-port br-int di-${RID} tag=20

ip link set dev ri-${RID} up
ip link set dev di-${RID} up


##########################################################
# configure instance
##########################################################

brctl addbr qbr${UUID}
ip link add qvb${UUID} type veth peer name qvo${UUID} 
ip tuntap add tap${UUID} mode tap

brctl addif qbr${UUID} qvb${UUID}
ovs-vsctl add-port br-int qvo${UUID} tag=20

brctl addif qbr${UUID} tap${UUID}

ip addr add ${INST_IP} dev tap${UUID}

ip link set dev qbr${UUID} up
ip link set dev qvb${UUID} up
ip link set dev tap${UUID} up

