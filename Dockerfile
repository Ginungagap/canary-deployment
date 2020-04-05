FROM php:apache
COPY public/ /var/www/html/
EXPOSE 80