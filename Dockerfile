FROM node:20.18.1 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Set the HOST environment variable
ENV HOST=0.0.0.0

CMD ["npm", "run", "start"]