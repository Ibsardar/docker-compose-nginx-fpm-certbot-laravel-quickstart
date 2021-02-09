# docker-compose-nginx-fpm-certbot-laravel-quickstart

 Quickstart your Docker Composed App using Nginx, PHP-FPM, Certbot, MySQL, PHPMyAdmin, and almost any version of Laravel

---


## Quickstart:
- Drop the contents of `drop-into-your-project` into your project.

- Edit as needed using the **[guidelines below](https://github.com/Ibsardar/docker-compose-nginx-fpm-certbot-laravel-quickstart#what-to-edit-guide)**.

- Login to machine where docker-compose is installed.

- Pull your project (after the drop + any edits) onto the server.

- Navigate to your project's main directory (where `docker-compose.yml` is).

- Run `chmod +x init-letsencrypt.sh` so you can run the next command

- Run `./init-letsencrypt.sh` to get SSL certifcate(s)

- If you receive an error:

  - Make sure `etc\letsencrypt\<dnsprovider>.ini` exists and is correctly matching the API key given by your DNS provider
  - If you are not using DNS, make sure in `dns_cred_path` is set to an empty string in `init-letsencrypt.sh`
  
- ### For demo:

  - Edit `docker-compose.production.yml` by setting `MODE` to `demo`

  - Run `docker-compose -f docker-compose.production.yml build && docker-compose -f docker-compose.production.yml up`

- ### For production:

  - Run `docker-compose -f docker-compose.production.yml build && docker-compose -f docker-compose.production.yml up`
  
- ### For staging:

  - Edit `docker-compose.production.yml` by setting `MODE` to `stage`

  - Run `docker-compose -f docker-compose.production.yml build && docker-compose -f docker-compose.production.yml up`
  
- ### For development (VS Code):

    - Run `rm -r node_modules && rm -r vendor`
  
    - Setup: https://code.visualstudio.com/docs/remote/containers
  
    - Run `Remote Containers: Open Folder in Container` > Choose Predefined Docker in Docker
    
      *(terminal should auto attach to the container directory: `/workspace/\<name of your project>`
      ...if not, manually attach to the running container in a terminal)*
      
    - Edit/Add to `/.devcontainer/devcontainer.json` like so:
    
      ```` json
      "forwardPorts": [81, 8000]
      ````
  
    - Run `chown -R vscode /workspaces/<name of your project>`
    
    - Run `docker-compose build --no-cache`
    
    - Run `docker-compose up`
    
    - Open your broswer on the host to `localhost:81` to discover your webapp
    
    - Open your browser on the host to `localhost:8000` to discover phpmyadmin of the mysql database of your webapp

---

## What-to-Edit Guide:

File | Detail | Example
--- | --- | ---
`dockerfiles/*.Dockerfile` | Change `"IBRAHIM"` unless it is your name also (yay!) | `LABEL MAINTAINER="JOHN DOE"`
`dockerfiles/phpfpm.Dockerfile` | Uncomment `#ENTRYPOINT sh "${E_NGINX_ROOT}/server/init_phpfpm.sh"` if you want to have a custom entrypoint there instead of the default entrypoint (command(s) would be specified in `server/init_phpfpm.sh`) | `ENTRYPOINT sh "${E_NGINX_ROOT}/server/init_phpfpm.sh"`
`server/init_*.sh` | Add your own set of commands to be run (will be run every time the container is started) | `echo container started!`
`server/vhost.conf` | Replace all instances of `example.org` with your website name | `example.org`
`server/vhost.conf` | Replace all instances of `/my/custom/root` to the directory you want to serve | `/var/www/html/public`
`server_dev/.env` | Edit as needed for your development environment |
`server_dev/vhost.conf` | Replace all instances of `/my/custom/root` to the directory you want to serve | `/var/www/html/public`
`.gitignore` | You can merge your existing `.gitignore` into this one | 
`docker-compose.yml` | Change the `MODE`. Must `prod`, `stage`, `dev`, or `demo` | `MODE: dev`
`docker-compose.yml` | Set the `NGINX_ROOT`. Must at least prepend the root set in `server_dev/vhost.conf` | `NGINX_ROOT: /var/www/html`
`docker-compose.production.yml` | Change the `MODE`. Must `prod`, `stage`, `dev`, or `demo` | `MODE: prod`
`docker-compose.production.yml` | Set the `NGINX_ROOT`. Must at least prepend the root set in `server/vhost.conf` | `NGINX_ROOT: /var/www/html`
`docker-compose.production.yml` | Change port numbers on the left (these are the exposed ports on your host machine) | `8080:80` *(if you want `example.com:8080`)*
`docker-compose.production.yml` | Change volume locations on the host server so they do not conflict with other running docker-compositions on the same host server | `/docker/\<MY_PROJECT\>/volumes/nginx_logs:/var/log/nginx`
`docker-compose.production.yml` | Change `digitalocean.ini` under `services.certbot_service.volumes` to `\<dnsprovider>.ini` or comment out if you are not using DNS | `/etc/letsencrypt/cloudflare.ini:/etc/letsencrypt/cloudflare.ini`
`init-letsencrypt.sh` | Replace `domains_list=("example.com www.example.com" "anotha.one www.anotha.one")` with all domains you want to generate certificates for. Each string will generate 1 certificate for that set of domains | `domains_list=("example.com www.example.com")`
`init-letsencrypt.sh` | Set your email by replacing `your@email.com` | `johndoe@gmail.com`
`init-letsencrypt.sh` | Set `staging=1` if you just want to test generating fake certificates | `staging=1`
`init-letsencrypt.sh` | Replace all instances of `digitalocean` with the name of you DNS provider (see comments in the script file for more details) | `cloudflare`

---

#### Troubleshoot:
Run `docker-compose config --services` to check the names of services.

Run `docker-compose ps` to check the status of the services.

Run `docker container ls` to check the status of the containers.

Run `docker-compose exec <SERVICE_NAME> bash` to enter into an up and running service for further investigation. (use sh if bash not available)

Run `docker-compose build --no-cache && docker-compose up` to rebuild everything from scratch.

Run `docker system prune` to clean up everything docker related on your machine

---

#### Some Credits:

- https://github.com/wmnnd/nginx-certbot

- https://github.com/wmnnd/nginx-certbot/issues/70
