# develop stage, install all dependencies in a node container

#FROM node:13.14-alpine as develop-stage
#[2/4] Fetching packages...
#error fs-extra@11.1.0: The engine "node" is incompatible with this module. Expected version ">=14.14". Got "13.14.0"
##error Found incompatible module.
#info Visit https://yarnpkg.com/en/docs/cli/global for documentation about this command.
#The command '/bin/sh -c yarn global add @quasar/cli' returned a non-zero code: 1

FROM node:alpine3.17 as develop-stage
#docker pull node:alpine3.17
WORKDIR /app
COPY package*.json ./
RUN yarn global add @quasar/cli
COPY . .

# build stage, builds the application in a node container
FROM develop-stage as build-stage
RUN yarn
RUN quasar build

# production stage, serves the artifacts with NGIN
FROM nginx:1.17.5-alpine as production-stage
COPY --from=build-stage /app/dist/spa /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# docker build -t dockerize-quasar .
# docker run -it -p 8000:80 --rm dockerize-quasar
