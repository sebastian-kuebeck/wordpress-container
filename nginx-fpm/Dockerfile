# derved from https://github.com/docker-library/wordpress/blob/master/latest/php8.3/fpm/Dockerfile

FROM php:8.3-fpm

ENV PATH=$PATH:/root/.local/bin

# persistent dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# Ghostscript is required for rendering PDF previews
		ghostscript \
		gnupg \
		sudo \
		cron \
		nginx \
		tmpreaper \
		pipx \
	; \
	rm -rf /var/lib/apt/lists/*; \
	pipx install encab

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libpng-dev \
		libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	; \
	docker-php-ext-install -j "$(nproc)" \
		bcmath \
		exif \
		gd \
		intl \
		mysqli \
		zip \
	;

COPY scripts scripts
COPY configs configs

RUN set -eux; \
	chmod a+x scripts/*.sh; \
	./scripts/install_imagemagic.sh; \
	./scripts/install_wordpress_cli.sh ; \
	./scripts/install_wordpress.sh

RUN set -eux; \
	./scripts/install_configs.sh; \
	mv scripts/startup.sh /usr/local/bin/; \
	mv scripts/wp_cli.sh /usr/local/bin/wp-cli; \
	mv scripts/install_database.sh /usr/local/bin/; \
	rm -rf scripts configs

VOLUME /var/www/html
ENTRYPOINT ["encab"]
