OM python:3.9

ENV STORAGE_ROOT /storage
ENV SERVER_PORT 8000
ENV ADMIN_EMAIL example@example.com
ENV HOST 127.0.0.1

# update upgrade
RUN apt update
RUN apt upgrade

RUN apt install -y sudo gcc make
RUN apt install -y python3-dev python3-pip
RUN apt install -y libffi-dev
RUN apt install -y build-essential

# application run on this directory
RUN mkdir /app

# default storage
RUN mkdir /storage

# start download packages
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get install -y nodejs

# download sourcecode
WORKDIR /app
RUN wget https://github.com/SweetCase-Cobalto/MicroCloudChip-NATURAL/archive/refs/tags/v0.0.1.tar.gz
RUN tar -zxvf v0.0.1.tar.gz

# Setting
WORKDIR /app/MicroCloudChip-NATURAL-0.0.1

# storage
RUN mkdir $STORAGE_ROOT/microcloudchip
RUN mkdir $STORAGE_ROOT/microcloudchip/storage

# install python
WORKDIR /app/MicroCloudChip-NATURAL-0.0.1/app
RUN pip install -r requirements.txt

# Setting Config File
WORKDIR /app/MicroCloudChip-NATURAL-0.0.1/bin
RUN perl setConfigure-sqlite.pl $STORAGE_ROOT/microcloudchip $SERVER_PORT $HOST $ADMIN_EMAIL

# install nodejs package and build static/template files
WORKDIR /app/MicroCloudChip-NATURAL-0.0.1/web
RUN npm i
RUN npm run build

# move tempalte/static files
WORKDIR /app/MicroCloudChip-NATURAL-0.0.1/app/server
RUN mkdir templates
RUN mv /app/MicroCloudChip-NATURAL-0.0.1/web/build/* ./templates/

# DJango Setting
RUN python manage.py collectstatic
RUN python manage.py makemigrations
RUN python manage.py migrate

CMD ["sh", "-c", "gunicorn --bind 0:$SERVER_PORT server.wsgi:application"]
