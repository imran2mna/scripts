#!/bin/bash

NAMESPACE="dhcp_qt"
HOST_END="machine_qt"
ROUTER_END="eth1"

SUBNET="10.0.18.0/24"
ROUTER_IP="10.0.18.1"
START="10.0.18.2"
END="10.0.18.50"

LOG_FILE="/tmp/dnsmasq.log"

ip netns add dhcptest
ip link add "${HOST_END}" type veth peer name "${ROUTER_END}"
ip link set dev "${ROUTER_END}" netns dhcptest


ip netns exec dhcptest ip addr add  "${ROUTER_IP}" dev "${ROUTER_END}"
ip netns exec dhcptest ip link set dev "${ROUTER_END}" up 
ip netns exec dhcptest ip route add "${SUBNET}" dev "${ROUTER_END}" 
ip netns exec dhcptest dnsmasq --dhcp-range="${START}","${END}",255.255.255.0 --interface="${ROUTER_END}" &> "${LOG_FILE}"
ip netns exec dhcptest pgrep -lf dnsmasq

ip link set dev "${HOST_END}" up