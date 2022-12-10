FROM node

WORKDIR ui

ADD ui/package.json .
RUN yarn install

ADD ui .
RUN yarn run build

FROM nginx
COPY --from=0 /home/node/ui/build/ /usr/share/nginx/html/
