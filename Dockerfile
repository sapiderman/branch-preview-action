FROM nginx:1.19-alpine

COPY public/ /var/www/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]