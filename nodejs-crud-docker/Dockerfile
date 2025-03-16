FROM node:latest
RUN mkdir -p /usr/src/node-curd-api
WORKDIR /usr/src/node-curd-api
COPY package.json /usr/src/node-curd-api/
RUN npm install
COPY . /usr/src/node-curd-api
EXPOSE 3000
CMD [ "npm", "run", "start" ]
