# Sample Wordpress Docker Container

Example for an integrated [Docker Container](https://www.docker.com/resources/what-container/) using the following services and tools:

- [Nginx Web Server](https://nginx.org/)
- [PHP 8.5](https://www.php.net/releases/8.5/de.php)
- [FastCGI Process Manager (FPM)](https://www.php.net/manual/en/install.fpm.php)
- [Wordpress 6.9.4](https://wordpress.org/documentation/wordpress-version/version-6-9-4/)
- [Wordpress CLI 2.12.0](https://make.wordpress.org/cli/)
- Wordpress Cron Job via [cron](https://wiki.debian.org/cron)

## Installation

1. **Install Docker, see [Install Docker Engine](https://docs.docker.com/engine/install/)**

2. **Clone container**

```bash
    git clone https://github.com/sebastian-kuebeck/wordpress-container.git
```

3. **Copy `nginx-fpm/.env.template` to `nginx-fpm/.env`**

```bash
    cp nginx-fpm/.env.template nginx-fpm/.env
```

4. **Fill out confidantial parameter in [nginx-fpm/.env](https://github.com/sebastian-kuebeck/wordpress-container/blob/main/nginx-fpm/.env.template)**

5. **Preinstall plugins (optional)**

Add plugins that you want to have installed once the container starts up the first time.

Edit the following file: 

`nginx-fpm/scripts/preinstall_modules.sh`

Add the plugin install commands

Example:

```bash
    wp-cli plugin install bbpress --activate
```
see [Wordpress CLI documentation](https://developer.wordpress.org/cli/commands/plugin/install/) for details.

6. **Build container**

```bash
    make build-nginx-fpm
```

7. **Start container and database**

```bash
    make run-nginx-fpm
```

8. **Wait until containers have started and Wordpress has installed itself...**

```logs
    wordpress-1  | encab INFO : encab 1.0.4
    wordpress-1  | encab INFO : Using configuration file /etc/encab.yml, source: Default location.
    wordpress-1  | startup_script/sh INFO : WordPress not found in /var/www/html - copying now...
    wordpress-1  | startup_script/sh INFO : Complete! WordPress has been successfully copied to /var/www/html
    wordpress-1  | startup_script/sh INFO : No 'wp-config.php' found in /var/www/html, but 'WORDPRESS_...' variables supplied; copying 'wp-config-docker.php' (WORDPRESS_DB_HOST WORDPRESS_DB_NAME WORDPRESS_DB_PASSWORD WORDPRESS_DB_USER)
    wordpress-1  | startup_script/sh ERROR: PHP Warning:  Undefined array key "HTTP_HOST" in /var/www/html/wp-includes/functions.php on line 6298
    wordpress-1  | startup_script/sh ERROR: Warning: Undefined array key "HTTP_HOST" in /var/www/html/wp-includes/functions.php on line 6298
    wordpress-1  | startup_script/sh INFO : Database successfully installed.
    wordpress-1  | fpm ERROR: [10-Sep-2024 19:49:40] NOTICE: fpm is running, pid 65
    wordpress-1  | fpm ERROR: [10-Sep-2024 19:49:40] NOTICE: ready to handle connections
```

9. **View running Wordpress http://localhost:8080/**

10. **Log into Wordpress http://localhost:8080/wp-admin/**

   use credentials from `nginx-fpm/.env`

## Further Information

- [Official Wordpress Docker Image](https://github.com/docker-library/wordpress)
- [Official PHP Docker Image](https://github.com/docker-library/php/blob/master/8.3/bookworm/fpm/Dockerfile)