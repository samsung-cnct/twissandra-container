############################################################
# Dockerfile to build Python WSGI Application Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Mikel Nelson <mikel.n@samsung.com>

# Add the application resources URL
RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.list

# Update the sources list
RUN apt-get update

# Install basic applications
RUN apt-get install -y tar git curl nano wget dialog net-tools build-essential

RUN apt-get install -y libev4 libev-dev

# Install Python and Basic Python Tools
RUN apt-get install -y python python-dev python-distribute python-pip

# use github for our development /twissandra instead of baking in
#
# add ssh key for github
#
# ssh/ is prepopulated the docker_rsa.pub key must be in github account first!
#
ADD /ssh /root/.ssh
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/*
# get key of destination ...
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
#
# may not be needed...
#RUN  echo "    IdentityFile ~/.ssh/deocker_rsa" >> /etc/ssh/ssh_config
#RUN git clone git@github.com:mikeln/twissandra.git twissandra

# Copy the application folder inside the container
#ADD /twissandra /twissandra

# Get pip to download and install requirements:
#RUN pip install -r /twissandra/requirements.txt

# Expose ports
EXPOSE 8222

# Set the default directory where CMD will execute
#WORKDIR /twissandra
#
ADD build.sh /usr/local/bin/build-start
RUN chmod 755 /usr/local/bin/build-start

# Set the default command to execute    
# when creating a new container
#
#ENTRYPOINT [ "python", "manage.py" ]
#
CMD [ "build-start", "app" ]
