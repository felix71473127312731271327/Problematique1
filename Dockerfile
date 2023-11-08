FROM node:16

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
RUN npm install -g nodemon

COPY . .

EXPOSE 1337
CMD ["npm", "run", "dev"]