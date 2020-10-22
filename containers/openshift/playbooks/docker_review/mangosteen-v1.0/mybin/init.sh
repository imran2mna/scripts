#!/bin/bash
echo "My pid -> $$" > ./pid.info
echo "I belong to ${ORG}" >> ./pid.info
sleep $[ 3 * 8 ] 
