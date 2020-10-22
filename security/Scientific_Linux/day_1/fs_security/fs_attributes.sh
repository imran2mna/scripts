#!/bin/bash

DOCKER_TXT="docker.txt"

# Create file, display attribute
echo 'We are searching for container orchestration engine...\n' > ${DOCKER_TXT} T&& lsattr ${DOCKER_TXT}

# Set to immutable
chattr +i ${DOCKER_TXT} && lsattr ${DOCKER_TXT}

# Overwrite
date > ${DOCKER_TXT}
# Append
date >> ${DOCKER_TXT}

# Delete file
rm -fv ${DOCKER_TXT}

# Set to Append
chattr -i ${DOCKER_TXT} 
chattr +a ${DOCKER_TXT} 

# Overwrite
date > ${DOCKER_TXT}
# Append
date >> ${DOCKER_TXT}

# Delete file
rm -fv ${DOCKER_TXT}
cat ${DOCKER_TXT}

# ******* Below script clear off file ****** #
chattr -a ${DOCKER_TXT}
rm ${DOCKER_TXT}

