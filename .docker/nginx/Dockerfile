FROM nginx:latest

COPY .docker/nginx/config/nginx.conf /etc/nginx/nginx.conf
COPY .docker/nginx/config/default.conf /etc/nginx/conf.d/default.conf

## Copy all the code into the container
COPY . /var/www/html