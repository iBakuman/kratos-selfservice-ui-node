FROM node:20.10.0-bullseye-slim as builder

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

ARG LINK

COPY package.json ./
COPY package-lock.json ./
COPY .npmrc ./
RUN npm ci --fetch-timeout=600000
COPY . ./

RUN if [ "$LINK" == "true" ]; then (cd ./contrib/sdk/generated; rm -rf node_modules; npm ci; npm run build); \
    cp -r ./contrib/sdk/generated/* node_modules/@ory/kratos-client/; \
    fi

RUN npm run build

FROM nginx:alpine

WORKDIR /usr/share/nginx
EXPOSE 80

RUN apk upgrade --update \
    && apk add -U tzdata \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && rm -rf \
    /var/cache/apk/*

COPY deploy/start.sh start.sh
COPY deploy/nginx.conf /etc/nginx/templates/default.conf.template

COPY --from=builder /app/lib html

CMD ["sh", "start.sh"]
