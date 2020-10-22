#!/bin/bash
RED='\033[0;31m'
CL='\033[0m'
echo -e "${RED}Check docker0 brigde in network interfaces...${CL}"
ip link
sudo systemctl start docker
echo -e "${RED}Check docker0 is UP or DOWN \nUP means atleast one container is running... ${CL}"
ethtool -i docker0
docker run --name local_server  -p 9080:80 -d docker.io/httpd
echo -e "${RED}Check whether you can identify any latest network interfaces added to system...${CL}"
ip link

process_pid=$(docker inspect -f '{{ .State.Pid }}' local_server)
netns_dir=$(docker inspect  local_server | grep -o '\/.*netns\/')

sudo ln -s ${netns_dir} /var/run/netns

ns_id=$(ip netns | grep -o '[[:digit:][:alpha:]]*[[:space:]]' | head -1)

echo -e "${RED}Below IP settings are inside a container...${CL}"
sudo ip netns exec ${ns_id} ip addr

echo -e "${RED}Now you are entering into the container using namespace...\nType \"exit\" in the end...${CL}"
sudo nsenter -t ${process_pid} --mount --uts --ipc --net --pid bash
