# Terraform + Docker + Nginx - Guia Passo a Passo

Guia simples para provisionar um container Nginx usando Terraform e Docker no Windows.

---

## Visão Geral do Projeto

Este projeto demonstra como usar Terraform para provisionar um container Docker com Nginx, servindo uma página web simples. A infraestrutura é criada inteiramente via código (IaC - Infrastructure as Code).

**Resultado:** Uma página web acessível em `http://localhost:8080` com a mensagem "Alô Professor!".

---

## Pré-requisitos

- Docker Desktop instalado e rodando no Windows
- Prompt de Comando (CMD)
- Bloco de Notas (Notepad) ou editor de texto
- Conexão com internet

---

## Passo 1: Criar Pastas do Projeto

1. Abra o Prompt de Comando (CMD)
   - Pressione `Windows + R`
   - Digite: `cmd`
   - Pressione `Enter`

2. Crie a estrutura de pastas:

```bash
mkdir C:\terraform-docker-project
mkdir C:\terraform-docker-project\terraform
mkdir C:\terraform-docker-project\nginx
cd C:\terraform-docker-project
```

**Explicação:** Estamos criando a pasta principal do projeto e duas subpastas: `terraform` para os arquivos de configuração do Terraform e `nginx` para o arquivo HTML.

---

## Passo 2: Criar Arquivo index.html

1. Abra o Bloco de Notas
   - Pressione `Windows + R`
   - Digite: `notepad`
   - Pressione `Enter`

2. Cole o conteúdo abaixo:

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alô Professor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h1 {
            color: #667eea;
            font-size: 3em;
            margin: 0;
        }
        p {
            color: #666;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎓 Alô Professor!</h1>
        <p>Infraestrutura provisionada com Terraform em Docker</p>
        <p><small>Nginx rodando com sucesso!</small></p>
    </div>
</body>
</html>
```

3. Salvar o arquivo:
   - Clique em `Arquivo` > `Salvar Como...`
   - Navegue até: `C:\terraform-docker-project\nginx`
   - No campo "Nome do arquivo" digite: `index.html`
   - **IMPORTANTE:** Em "Tipo", selecione `"Todos os Arquivos (*.*)"`
   - Clique em `Salvar`

4. Feche o Bloco de Notas

**Explicação:** Este é o arquivo HTML que será servido pelo Nginx. Ele contém uma página estilizada com título, texto e um visual moderno com gradiente roxo.

---

## Passo 3: Criar Arquivo main.tf

1. Abra o Bloco de Notas novamente
   - Pressione `Windows + R`
   - Digite: `notepad`
   - Pressione `Enter`

2. Cole o conteúdo abaixo:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx-alo-professor"

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "/c/terraform-docker-project/nginx/index.html"
    container_path = "/usr/share/nginx/html/index.html"
    read_only      = true
  }

  restart = "unless-stopped"
}

output "container_id" {
  description = "ID do container Nginx"
  value       = docker_container.nginx.id
}

output "container_name" {
  description = "Nome do container"
  value       = docker_container.nginx.name
}

output "url" {
  description = "URL para acessar a aplicação"
  value       = "http://localhost:8080"
}
```

3. Salvar o arquivo:
   - Clique em `Arquivo` > `Salvar Como...`
   - Navegue até: `C:\terraform-docker-project\terraform`
   - No campo "Nome do arquivo" digite: `main.tf`
   - **IMPORTANTE:** Em "Tipo", selecione `"Todos os Arquivos (*.*)"`
   - Clique em `Salvar`

4. Feche o Bloco de Notas

**Explicação:**
- **Bloco `terraform`:** Define o provider Docker (kreuzwerker/docker) que permite ao Terraform gerenciar recursos Docker.
- **Bloco `provider`:** Configura a conexão com o Docker Engine.
- **Recurso `docker_image`:** Baixa a imagem oficial do Nginx do Docker Hub.
- **Recurso `docker_container`:** Cria um container com a imagem Nginx, expose a porta 8080 no host mapeada para 80 no container, e monta o arquivo HTML como volume.
- **Blocos `output`:** Exibem informações úteis após a criação (ID do container, nome e URL).

---

## Passo 4: Verificar se os Arquivos Foram Criados

No CMD, execute:

```bash
dir C:\terraform-docker-project\nginx
dir C:\terraform-docker-project\terraform
```

Você deve ver:
- `index.html` na pasta `nginx`
- `main.tf` na pasta `terraform`

**Explicação:** Este passo garante que os arquivos foram salvos corretamente. Se você ver arquivos com extensão `.txt`, refaça o passo de salvamento certificando-se de selecionar "Todos os Arquivos".

---

## Passo 5: Verificar se o Docker Está Rodando

No CMD, execute:

```bash
docker --version
```

Você deve ver algo como: `Docker version 24.x.x`

**Explicação:** Este comando verifica se o Docker está instalado e acessível. Se der erro, abra o Docker Desktop e aguarde até que ele mostre "Docker Desktop is running".

---

## Passo 6: Baixar a Imagem do Terraform

Execute o comando abaixo no CMD:

```bash
docker pull hashicorp/terraform:latest
```

Aguarde o download terminar. Pode demorar alguns minutos dependendo da sua conexão.

Para verificar se a imagem foi baixada:

```bash
docker images
```

Você deve ver `hashicorp/terraform` na lista.

**Explicação:** Estamos usando o Terraform via Docker container em vez de instalá-lo localmente. Esta imagem contém o binário do Terraform pronto para uso.

---

## Passo 7: Inicializar o Terraform

Execute o comando abaixo **completo** no CMD:

```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest init
```

Você deve ver a mensagem:
```
Terraform has been successfully initialized!
```

**Explicação:**
- `--rm`: Remove o container após a execução
- `-it`: Modo interativo com terminal
- `-v .../terraform:/workspace`: Monta a pasta terraform do host no container
- `-v .../nginx:/workspace/nginx`: Monta a pasta nginx do host no container
- `-v //./pipe/docker_engine://./pipe/docker_engine`: Permite acesso ao Docker Engine do Windows
- `-w /workspace`: Define o diretório de trabalho
- `init`: Inicializa o Terraform (baixa providers, cria estado inicial)

---

## Passo 8: Ver o Plano de Execução (Opcional)

Este passo mostra o que o Terraform vai criar. É opcional mas recomendado.

Execute:

```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest plan
```

Você verá que o Terraform vai criar:
- 1 `docker_image` (nginx)
- 1 `docker_container` (nginx-alo-professor)

**Explicação:** O comando `plan` mostra o que será criado, modificado ou destruído sem realmente executar as mudanças. É uma forma de revisar antes de aplicar.

---

## Passo 9: Criar a Infraestrutura

Agora vamos realmente criar o container com Nginx:

```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest apply -auto-approve
```

Aguarde o processo terminar. Você verá:
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

E os outputs:
- `container_id`
- `container_name`
- `url`

**Explicação:**
- `apply`: Aplica as mudanças definidas no `main.tf`
- `-auto-approve`: Executa sem pedir confirmação manual

---

## Passo 10: Verificar se Está Funcionando

### 1. Verificar se o container está rodando:

```bash
docker ps
```

Você deve ver `nginx-alo-professor` na lista.

### 2. Testar no navegador:

- Abra seu navegador (Chrome, Edge, Firefox)
- Digite na barra de endereço: `http://localhost:8080`
- Pressione `Enter`

Você deve ver a página "Alô Professor!" com fundo roxo/azul.

### 3. Testar via CMD (opcional):

```bash
curl http://localhost:8080
```

**Explicação:** Estes comandos verificam se o container está em execução e se a página está acessível. O mapeamento de porta 8080 (host) para 80 (container) permite acessar o Nginx do navegador.

---

## Passo 11: Ver os Outputs do Terraform

Para ver as informações do que foi criado:

```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest output
```

Mostrará:
- `container_id` = "abc123..."
- `container_name` = "nginx-alo-professor"
- `url` = "http://localhost:8080"

**Explicação:** O comando `output` exibe os valores definidos nos blocos `output` do `main.tf`. Útil para obter IDs e URLs programaticamente.

---

## Passo 12: Destruir a Infraestrutura (Cleanup)

Quando quiser parar e remover tudo:

```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest destroy -auto-approve
```

Você verá:
```
Destroy complete! Resources: 2 destroyed.
```

Para confirmar que foi removido:

```bash
docker ps
```

O container `nginx-alo-professor` não deve mais aparecer.

**Explicação:** O comando `destroy` remove todos os recursos criados pelo Terraform. Isso demonstra a capacidade de criar e destruir infraestrutura de forma reprodutível.

---

## Resumo dos Comandos Principais

### Inicializar (executar 1 vez após criar/modificar main.tf):
```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest init
```

### Ver Plano:
```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest plan
```

### Criar/Atualizar Infraestrutura:
```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest apply -auto-approve
```

### Destruir Infraestrutura:
```bash
docker run --rm -it -v C:\terraform-docker-project\terraform:/workspace -v C:\terraform-docker-project\nginx:/workspace/nginx -v //./pipe/docker_engine://./pipe/docker_engine -w /workspace hashicorp/terraform:latest destroy -auto-approve
```

---

## Comandos Úteis do Docker

### Ver containers rodando:
```bash
docker ps
```

### Ver todos os containers (incluindo parados):
```bash
docker ps -a
```

### Parar o container:
```bash
docker stop nginx-alo-professor
```

### Iniciar o container (se existir):
```bash
docker start nginx-alo-professor
```

### Remover o container:
```bash
docker rm nginx-alo-professor
```

### Ver logs do container:
```bash
docker logs nginx-alo-professor
```

### Entrar no container (shell interativo):
```bash
docker exec -it nginx-alo-professor /bin/bash
```

### Ver imagens:
```bash
docker images
```

### Remover imagem:
```bash
docker rmi nginx:latest
```

---

## Estrutura Final dos Arquivos

```
C:\terraform-docker-project\
│
├── nginx\
│   └── index.html                    (criado por você)
│
├── terraform\
│   ├── main.tf                       (criado por você)
│   ├── .terraform\                   (criado pelo init)
│   ├── .terraform.lock.hcl           (criado pelo init)
│   └── terraform.tfstate             (criado pelo apply)
│
└── README.md                          (este arquivo)
```

**Explicação:**
- `nginx/index.html`: Página web a ser servida
- `terraform/main.tf`: Configuração principal do Terraform
- `terraform/.terraform/`: Diretório interno do Terraform (não editar)
- `terraform/.terraform.lock.hcl`: Lock file das versões dos providers
- `terraform/terraform.tfstate`: Estado da infraestrutura (importante!)

---

## Possíveis Problemas e Soluções

### Problema 1: "Cannot connect to the Docker daemon"
**Solução:**
- Abra o Docker Desktop
- Aguarde até aparecer "Docker Desktop is running"
- Tente novamente

### Problema 2: "No such file or directory"
**Solução:**
- Verifique se está na pasta correta: `cd C:\terraform-docker-project`
- Verifique se os arquivos existem:
  ```bash
  dir C:\terraform-docker-project\nginx\index.html
  dir C:\terraform-docker-project\terraform\main.tf
  ```

### Problema 3: Arquivos com extensão .txt
**Solução:**
- Ao salvar no Notepad, selecione `"Todos os Arquivos (*.*)"`
- Digite o nome completo com extensão: `index.html` ou `main.tf`

### Problema 4: "Port 8080 is already allocated"
**Solução:**
- Algum outro programa está usando a porta 8080
- Opção 1: Pare o outro programa
- Opção 2: Mude a porta no `main.tf`:
  ```hcl
  ports {
    internal = 80
    external = 8081  # Mude para outra porta
  }
  ```
  Execute `terraform apply` novamente
  Acesse `http://localhost:8081`

### Problema 5: Página não carrega
**Solução:**
- Verifique se o container está rodando: `docker ps`
- Veja os logs: `docker logs nginx-alo-professor`
- Tente reiniciar o container:
  ```bash
  docker restart nginx-alo-professor
  ```

### Problema 6: "Error locking state"
**Solução:**
- Aguarde alguns segundos e tente novamente
- Se persistir, delete o arquivo de lock:
  ```bash
  del C:\terraform-docker-project\terraform\.terraform.tfstate.lock.info
  ```

### Problema 7: Terraform não encontra o provider
**Solução:**
- Execute `terraform init` novamente
- Verifique se há conexão com internet

---

## Checklist de Verificação

Execute nesta ordem:

- [ ] 1. Docker Desktop está rodando?
- [ ] 2. Pastas criadas (`terraform` e `nginx`)?
- [ ] 3. Arquivo `index.html` criado e salvo corretamente?
- [ ] 4. Arquivo `main.tf` criado e salvo corretamente?
- [ ] 5. Imagem do Terraform baixada (`docker pull`)?
- [ ] 6. Terraform inicializado (`init`)?
- [ ] 7. Plano visualizado (`plan`)?
- [ ] 8. Infraestrutura criada (`apply`)?
- [ ] 9. Container aparece em `docker ps`?
- [ ] 10. Página abre no navegador em `localhost:8080`?

Se todos os itens estiverem OK, parabéns! Funcionou! 🎉

---

## Conclusão

Este projeto demonstra os fundamentos de Infrastructure as Code (IaC) usando Terraform com Docker:

- **Reproducibilidade:** A infraestrutura pode ser criada e destruída quantas vezes quiser
- **Declaratividade:** Você define o estado final desejado, não os passos
- **Automação:** Tudo via linha de comando, sem interface gráfica
- **Versionamento:** Os arquivos podem ser commitados no Git

Parabéns por completar este tutorial!

---

*Este guia foi criado para fins educacionais - DSM 202601*
