FROM nginx:stable-alpine3.20
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
EXPOSE 80