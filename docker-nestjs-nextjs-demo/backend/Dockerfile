FROM node:20-alpine
WORKDIR /app
RUN apk add --no-cache bash \
  && npm i -g @nestjs/cli@latest

CMD ["npm", "run", "start:dev"]
