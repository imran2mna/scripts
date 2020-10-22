#!/bin/bash
rnd_interval=301
wd=$(date +%w)
rnd=$(dd if=/dev/urandom bs=1 count=4 2>/dev/null | hexdump -e '"%u"')
seconds=$(echo "scale=0; ${rnd}*${rnd_interval}/4294987296" | bc)

# echo "Sleep ${seconds} seconds."
sleep ${seconds}
# If you want only security patches?
yum --security -y -d 1 update-minimal
#
# Regular patching
# yum -y update

yum_retval=$?


if [[ ${yum_retval} -eq 0 ]]; then {
  logger -t "${0}" -i "yum -y update return value was 0, OK."
}
else {
  logger -t "${0}" -i "yum -y update return value was ${yum_retval}, problem!"
  exit 1
}
fi


if [[ ${wd} == "0" ]]; then {
  logger -t "${0}" -i "It's sunday and automatic reboot time in Riyadh."
  /sbin/shutdown -r now "It's sunday and automatic reboot time in Riyadh."
}
fi

