## CERTBOT for Docker
Generates the Let's Encrypt certificate for the domain. The generated certificates are saved to the ```certy``` folder
On the new configuration, it is worth carrying out a test certificate generation first, remember about the limits of about 5-7 requests per week for each domain.

### How run it:

#### 0. Preparation:
Remember that ports ```80``` and ```443``` should be open to the world.

#### 1. Build image or pull from Docker Hub:
```
docker build -t beastiecode/certbot .
```

#### 2. Generating a certificate:
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastiecode/certbot
```

**For test:**
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastiecode/certbot bin/sh /script/entrypoint-test.sh
```

#### 3. Certificate renewal:
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_RENEW=true -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastiecode/certbot
```

**For test:**
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_RENEW=true -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastiecode/certbot bin/sh /script/entrypoint-test.sh
```

#### 4. Certificate renewal with cron:
Log in to the machine as root and put commad:
```
crontab -e
```
Set: 
````
0 8 * * * /usr/bin/docker docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_RENEW=true -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastiecode/certbot >> /home/cron.log 2>&1
````
Logs will be saved in file ```/home/cron.log```

#### 5. Final STEP - Nginx configuration:

- Remember replace ```DOMAIN_NAME``` on correct domain name
- If you also use docker for run nginx notice have to add volume with certificates to Nginx container, for example: ```-v $(pwd)/certy:/etc/letsencrypt```

```
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name DOMAIN_NAME;

        server_tokens off;

        ssl_certificate /etc/letsencrypt/live/DOMAIN_NAME/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/DOMAIN_NAME/privkey.pem;

...

}
```