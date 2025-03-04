FROM node:20.18.1 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

CMD ["npm", "run", "start"]