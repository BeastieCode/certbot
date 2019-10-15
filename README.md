## CERTBOT for Docker
Generuje certyfikat Let's Encrypt dla domeny. Wygenerowane certyfikty zapisuje do folderu ```certy```
Na nowej konfiguracji warto przeprowadzić najpierw testowe generowanie certyfikatów, nalezy pamiętac o limitach około 5-7 requestów na tydzień.

### Uruchomienie:

#### 0. Przygotowanie:
Należy pamiętać aby porty ```80``` oraz ```443``` były otwarte na świat (wyłączyć dla  tych portów Firewall).

#### 1. Budowanie obrazu:
```
docker build -t beastie/cert .
```

#### 2. Generowanie certyfikatu:
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastie/cert
```

Testowo:
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastie/cert bin/sh /script/entrypoint-test.sh
```

#### 3. Odnownienie certyfikatu:
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_RENEW=true -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastie/cert
```

Testowo:
```
docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_RENEW=true -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastie/cert bin/sh /script/entrypoint-test.sh
```

#### 4. Odnowienie za pomocą cron:
Logoujemy się jako root wpisujemy w terminal:
```
crontab -e
```
Ustawiamy 
````
0 8 * * * /usr/bin/docker docker container run --rm -it -p 80:80 -e CERTBOT_EMAIL="test@example.com" -e CERTBOT_RENEW=true -e CERTBOT_DOMAIN="example.dev" -v $(pwd)/certy:/etc/letsencrypt beastie/cert >> /home/cron.log 2>&1
````

Logi będa zapisywane w pliku ```/home/cron.log```

#### 5. Konfiguracja nginx

- Pamaiętaj podmienić ```DOMAIN_NAME``` na właściwą nazwę
- Pamiętaj dodać folder z certami jako wolumen dockera ```-v $(pwd)/certy:/etc/letsencrypt```

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