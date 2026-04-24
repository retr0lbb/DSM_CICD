# Walkthrough DOCKER

## INICIO
Rodamos alguns comandos para preparar o ambiente

```
docker run --privileged -it ubuntu bash
apt update
apt install -y curl
apt install nano
apt install -y docker.io
dockerd > /tmp/docker.log 2>&1 &
docker run hello-world
ps aux | grep docker
```


## LAB 1 DOCKER
Esse laboratorio foi focado em construir uma ferramenta NGINX simples usando o DIND

`pkill dockerd` matamos o dockerd para criar os storage drivers

`dockerd --storage-driver=vfs > /tmp/docker.log 2>&1 &`

`docker pull nginx` rodamos o pull para pegar a imagem do nginx

`docker run -d --name webserver -p 8080:80 nginx` construimos um container com a imagem do nginx que acabamos de baixar

`docker ps` usado para ver se o container esta rodando

`curl http://localhost:8080` testar a conexão com o nginx lembre-se que estamos no bash do container em Ubunto

O resultado do comando anterior é esse: 
```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

`docker exec -it webserver bash` Executamos o webserver da imagem do nginx

```bash
docker stop webserver
docker rm webserver
```
Comandos para parar o web-server e o remove-lo.

## LAB 2 PYTHON FASTAPI
O objetivo desse laboratorio é criar um backend em python com fastapi, bem simples

### 1. criamos o arquivo principal do site

`touch main.py`

### 2. Adicionamos o codigo ao arquivo, usando o cat fica mais facil para arquivos multi linha
```bash
cat <<EOF > main.py
from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from a Dockerized FastAPI app!"}
EOF
```
adicionamos dependencias ao requirements.txt por ser apenas 2 linhas usamos um echo simples
```bash
echo -e "fastapi\nuvicorn" > requirements.txt
```

adicionamos o dockerfile para genrenciar o build da aplicação
```bash
cat <<EOF > Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF
```

### 3. Rodamos o build da imagem e rodamos logo em sequencia
```bash
docker build -t fastapi-app .
docker run -d -p 8000:8000 fastapi-app
```

### 4. Testamos

`curl http://localhost:8000/` Rodamos o Curl para testar se a api esta disponivel

E recebemos essa mensagem de volta
> {"message":"Hello from a Dockerized FastAPI app!"}root@74b8fd07a868:~/labs/docker/fastapi-app# 

Rodamos um comando para ver se os logs da api estao corretos

`docker logs $(docker ps -q --filter ancestor=fastapi-app)`

E esse é o resultado

INFO:     Started server process [1]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     172.18.0.1:45004 - "GET / HTTP/1.1" 200 OK


### 5. por fim destruimos o container (opicional)
```
docker ps -q --filter ancestor=fastapi-app | xargs docker stop | xargs docker rm
```