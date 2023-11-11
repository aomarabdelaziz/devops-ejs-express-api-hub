FROM node:16-alpine

LABEL Name="EJS Express API Hub" Version=0.1.0
LABEL Org.App.Repo.SRC = "https://github.com/aomarabdelaziz/ejs-express-api-hub"

WORKDIR /app

COPY *.json ./

RUN npm install --production --silent

COPY . ./

EXPOSE 3001

ENTRYPOINT [ "npm" , "start" ]