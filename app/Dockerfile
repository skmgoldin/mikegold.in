FROM node:7-alpine

COPY ./ /app/

RUN npm install --prefix /app /app

EXPOSE 80

CMD npm run --prefix /app serve

