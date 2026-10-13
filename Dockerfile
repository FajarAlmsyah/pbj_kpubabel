FROM nginx:alpine

# Copy konfigurasi Nginx dari docker/nginx/
COPY docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy berkas web ke root Nginx
COPY . /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
