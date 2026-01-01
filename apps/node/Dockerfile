FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Run unit tests
RUN npm test

RUN npm run build

EXPOSE 8004

CMD ["npm", "start"]
