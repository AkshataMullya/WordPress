# Final App
FROM php:7.4-apache
 
# copy src
COPY . /var/www/html
 
# env
ARG build_version
ARG db_host
ARG db_database
ARG db_username
ARG db_password
ARG auth_key_val
ARG sercure_auth_key_val
ARG logged_in_key_val
ARG nonce_key_val
ARG auth_salt_val
ARG secure_auth_salt_val
ARG logged_in_salt_val
ARG nonce_salt_val
 
# copy config
RUN touch /var/www/html/wp-config-env.php
COPY wp-config-sample.php /var/www/html/wp-config.php
 
# set db
RUN echo "<?php" >> /var/www/html/wp-config-env.php
RUN echo "define( 'DB_HOST', '$db_host' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'DB_NAME', '$db_database' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'DB_USER', '$db_username' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'DB_PASSWORD', '$db_password' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'DB_CHARSET', 'utf8mb4' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'DB_COLLATE', '' );" >> /var/www/html/wp-config-env.php
 
# set salt
RUN echo "define( 'AUTH_KEY', '$auth_key_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'SECURE_AUTH_KEY', '$sercure_auth_key_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'LOGGED_IN_KEY', '$logged_in_key_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'NONCE_KEY', '$nonce_key_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'AUTH_SALT', '$auth_salt_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'SECURE_AUTH_SALT', '$secure_auth_salt_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'LOGGED_IN_SALT', '$logged_in_salt_val' );" >> /var/www/html/wp-config-env.php
RUN echo "define( 'NONCE_SALT', '$nonce_salt_val' );" >> /var/www/html/wp-config-env.php
 
# set build
RUN echo "define( 'WP_BUILD_VERSION', '$build_version' );" >> /var/www/html/wp-config-env.php
 
 
# make sure web user owns dir
RUN chown -R www-data:www-data /var/www/html
 
# optional copy apache config
# COPY custom-apache.conf /etc/apache2/sites-available/000-default.conf
 
# enable
RUN a2enmod rewrite
 
# restart apache
RUN service apache2 restart
 
# install some additional php
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    		libfreetype6-dev \
    		libjpeg-dev \
    		libmagickwand-dev \
    		libpng-dev \
    		libzip-dev \
    	; \
    	\
    	docker-php-ext-configure gd --with-freetype --with-jpeg; \
    	docker-php-ext-install -j "$(nproc)" \
    		bcmath \
    		exif \
    		gd \
    		mysqli \
    		zip \
    	; \
    	pecl install imagick-3.4.4; \
    	docker-php-ext-enable imagick;
 
# optional set different port besides 80
ENV PORT 80
CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground
