FROM node:20.18.1 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Prod stage
FROM node:20.18.1 as production
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY package*.json ./
RUN npm install --only=production
COPY server.js ./

EXPOSE 8081
CMD ["node", "server.js"]