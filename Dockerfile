FROM node:latest

WORKDIR /home/choreouser

COPY files/* /home/choreouser/

ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 vim &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x index.js start.sh nezha-agent ttyd &&\
    npm install -r package.json

#ENTRYPOINT [ "node", "server.js" ]

USER 10001

EXPOSE 80
EXPOSE 443
CMD ./start.sh