FROM python:3.9

ENV STORAGE_ROOT /storage
ENV SERVER_PORT 8000
ENV ADMIN_EMAIL example@example.com
ENV HOST 127.0.0.1

# update upgrade
RUN apt update
RUN apt upgrade -y

RUN apt install -y sudo gcc make
RUN apt install -y python3-dev python3-pip
RUN apt install -y libffi-dev
RUN apt install -y build-essential
RUN apt install -y git

# application run on this directory
RUN mkdir /app

# default storage
RUN mkdir /storage

# for download packages/installer
RUN mkdir /packages

# start download packages
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get install -y nodejs

# download sourcecode
WORKDIR /app
RUN wget https://github.com/SweetCase-Cobalto/microcloudchip-natural/archive/refs/tags/v0.1.0.beta1.tar.gz
RUN tar -zxvf v0.1.0.beta1.tar.gz

# Setting
WORKDIR /app/microcloudchip-natural-0.1.0.beta1

# install python
WORKDIR /app/microcloudchip-natural-0.1.0.beta1/app
RUN ls
RUN pip install -r requirements.txt

# download installer
WORKDIR /packages
RUN git clone -b 0.1.0.beta1 --single-branch https://github.com/SweetCase-Cobalto/MicroCloudChip-NATURAL-Installer.git

WORKDIR /packages/MicroCloudChip-NATURAL-Installer/dockerfiles/internal

ENTRYPOINT ["sh", "-c", "perl run-in-docker.pl /app/microcloudchip-natural-0.1.0.beta1 $SERVER_PORT $ADMIN_EMAIL $HOST $STORAGE_ROOT"]
