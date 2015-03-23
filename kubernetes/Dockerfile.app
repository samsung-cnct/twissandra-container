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

# additions that seem to be needed now
RUN apt-get install -y libev4 libev-dev

# Install Python and Basic Python Tools
RUN apt-get install -y python python-dev python-distribute python-pip
#
# add container startup script
#
ADD init.sh /usr/local/bin/twiss-start
RUN chmod 755 /usr/local/bin/twiss-start

ADD schema.sh /usr/local/bin/twiss-schema
RUN chmod 755 /usr/local/bin/twiss-schema

ADD inject.sh /usr/local/bin/twiss-inject
RUN chmod 755 /usr/local/bin/twiss-inject

# Copy the application folder inside the container
ADD /twissandra /twissandra

# Get pip to download and install requirements:
RUN pip install -r /twissandra/requirements.txt

# Expose ports
EXPOSE 8000

#
# MOVE RUNNING TO init.sh script
#
# Set the default directory where CMD will execute
#WORKDIR /twissandra
# Set the default command to execute    
# when creating a new container
#
#ENTRYPOINT [ "python", "manage.py" ]
#
# CMD [ ""]
#
USER root
CMD [ "twiss-start" ]