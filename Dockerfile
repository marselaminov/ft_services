# установка контейнерной ОС
FROM alpine:3.12

# установка и обновление образов
RUN apk update && apk upgrade
RUN apk add nginx openssl

# копируем конфиг nginx
COPY ./srcs/nginx.conf /etc/nginx/conf.d/default.conf

# настройка ssl сертификата (поскольку существует настройка конфигурации для порта 443 (в конфиге nginx), мы должны установить ключ SSL в Dockerfile)
RUN openssl req -x509 -nodes -days 365 -subj "/C=RU/L=KAZAN/OU=21school/" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

RUN mkdir /var/srcs

# копируем наш инит
COPY ./srcs/init.sh /var/srcs
RUN chmod +x /var/srcs/init.sh
RUN mkdir -p /run/nginx
EXPOSE 80 443
# запускаем
CMD sh /var/srcs/init.sh