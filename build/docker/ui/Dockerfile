FROM common_react

WORKDIR /ui

ADD ui/package.json .
RUN yarn config set network-timeout 300000
RUN yarn install

ADD ui/public/ public/
ADD ui/scripts/ scripts/
ADD ui/config/ config/
ADD ui/src/ src/
ADD ui/tsconfig.json tsconfig.json
RUN yarn run build

FROM nginx
COPY --from=0 /ui/build/ /usr/share/nginx/html/
COPY build/docker/ui/default.conf /etc/nginx/conf.d/default.conf

ENV PRODUCTION=1
