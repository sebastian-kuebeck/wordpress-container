.PHONY: run-nginx-fpm start-nginx-fpm start-nginx-fpm-fg stop-nginx-fpm

build-nginx-fpm:
	cd nginx-fpm && docker build -t wordpress-nginx-fpm  .

start-nginx-fpm:
	cd nginx-fpm && docker compose up -d

nginx-fpm-logs:
	cd nginx-fpm && docker compose logs -f

stop-nginx-fpm:
	cd nginx-fpm && docker compose down

run-nginx-fpm:
	cd nginx-fpm && docker compose up