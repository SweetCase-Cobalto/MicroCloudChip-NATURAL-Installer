FROM python:3.9

ENV STORAGE_ROOT /storage
ENV SERVER_PORT 8000
ENV ADMIN_EMAIL example@example.com
ENV HOST 127.0.0.1

# MYSQL EVNS
ENV DB_NAME micro
ENV DB_USER root
ENV DB_PSWD test
ENV DB_HOST 127.0.0.1
ENV DB_PORT 3306

# update upgrade
RUN apt update
RUN apt upgrade -y

RUN apt install -y sudo gcc make
RUN apt install -y python3-dev python3-pip
RUN apt install -y libffi-dev
RUN apt install -y build-essential
RUN apt install -y default-libmysqlclient-dev
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
RUN wget https://github.com/SweetCase-Cobalto/microcloudchip-natural/archive/refs/tags/v0.1.0.beta2.tar.gz
RUN tar -zxvf v0.1.0.beta2.tar.gz

# Setting
WORKDIR /app/microcloudchip-natural-0.1.0.beta2

# install python
WORKDIR /app/microcloudchip-natural-0.1.0.beta2/app
RUN pip install -r requirements.txt

# download installer
WORKDIR /packages
RUN git clone -b 0.1.0.beta2 --single-branch https://github.com/SweetCase-Cobalto/MicroCloudChip-NATURAL-Installer.git

WORKDIR /packages/MicroCloudChip-NATURAL-Installer/dockerfiles/mysql

ENTRYPOINT ["sh", "-c", "perl run-in-docker.pl /app/microcloudchip-natural-0.1.0.beta2 $SERVER_PORT $ADMIN_EMAIL $HOST $DB_NAME $DB_USER $DB_PSWD $DB_HOST $DB_PORT $STORAGE_ROOT"]
