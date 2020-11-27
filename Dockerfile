FROM node:12

WORKDIR /usr/src/action

COPY package*.json ./

RUN npm ci

COPY . .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/usr/src/action/entrypoint.sh"]
