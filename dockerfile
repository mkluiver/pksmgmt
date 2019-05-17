FROM ubuntu:18.04
MAINTAINER Mdk
# Install required libraries
RUN apt-get update -y && \
  apt-get install -y ruby ruby-dev openssl build-essential && \
  apt-get clean all
#Set default directory when attaching to container
WORKDIR /home
# Set Environment variables
#NV test /opt/test
#Rubygems file and folder to install
ARG Rubygems=rubygems-3.0.3.tgz
ARG Rubygems_FOL=rubygems-3.0.3
ARG Kubectl=kubectl-linux-amd64-1.13.5
ARG PKSCLI=pks-linux-amd64-1.4.0-build.194
ARG BOSHCLI=bosh-cli-5.5.0-linux-amd64
#Copy RPM to Image

COPY ${Kubectl} ${PKSCLI} ${Rubygems} ${BOSHCLI} /tmp/

#Copy Files when needed

# Set file permissions of configuration scripts
RUN cd /tmp && \
    tar -xzf ${Rubygems}
RUN cd /tmp/${Rubygems_FOL} && \
    ruby setup.rb
#Install MarkLogic
RUN gem install cf-uaac
RUN chmod +x /tmp/${Kubectl} && mv /tmp/${Kubectl} /usr/local/bin/kubectl
RUN chmod +x /tmp/${PKSCLI} && mv /tmp/${PKSCLI} /usr/local/bin/pks
RUN chmod +x /tmp/${BOSHCLI} && mv /tmp/${BOSHCLI} /usr/local/bin/bosh
RUN rm -rf /tmp
#ENTRYPOINT ["/bin/bash"]
# Setting ports to be exposed by the container. Add more if your application needs them
#EXPOSE 7997 7998 7999 8000 8001 8002