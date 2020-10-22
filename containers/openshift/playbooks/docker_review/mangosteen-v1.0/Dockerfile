FROM 	httpd:2.4

# define environment variables
ENV 	ORG="Red Hat Inc." \
	PC="+1" \
	USER="google" \
	GROUP="engine" \
	GID="1001" \
	UID="1001"
	
# add group & user
RUN     groupadd -r -g ${GID} -f ${GROUP} && \
	useradd -r -u ${UID} -g ${GID} -m -d /${USER} -c "${USER} User" ${USER} 

ADD 	./mybin.tar /${USER}
RUN     ln -s /${USER}/mybin/init.sh /${USER}/init && \ 
	chown -R ${USER}:${GROUP} /${USER} && \
	chmod -R 755 /${USER}
WORKDIR /${USER}
USER    ${UID}
CMD 	[ "./init" ] 
