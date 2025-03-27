# Usar PHP con Apache
FROM php:8.2-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev unzip \
    && docker-php-ext-install zip pdo pdo_mysql

# Habilitar mod_rewrite para Laravel
RUN a2enmod rewrite

# Copiar los archivos de Laravel al contenedor
WORKDIR /var/www/html
COPY . .

# Instalar Composer y las dependencias de Laravel
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

# Asignar permisos de escritura a Laravel
RUN chmod -R 777 storage bootstrap/cache

# Exponer el puerto 80
EXPOSE 80

# Comando de inicio del servidor Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
