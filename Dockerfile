FROM node:16.14.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY ./*.json /app/
COPY . /app/

RUN npm install -g @angular/cli
RUN npm install
RUN npm run build:prod

FROM nginx:1.19.5-alpine
COPY --from=build /app/dist/jetkins_ng /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
