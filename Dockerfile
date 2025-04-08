FROM node:20.18.1 as build
WORKDIR /app

COPY package*.json ./
RUN npm install
RUN npm install -g @vue/cli-service @vue/cli-plugin-babel

COPY . .

# Configure for port 80
ENV HOST=0.0.0.0
EXPOSE 80

USER root
CMD ["npm", "run", "start"]