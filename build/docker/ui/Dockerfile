FROM node:16

WORKDIR ui

ADD ui/package.json .
RUN yarn install

ADD ui .
RUN yarn run build

FROM nginx
COPY --from=0 /home/node/ui/build/ /usr/share/nginx/html/

ENV PRODUCTION=1
