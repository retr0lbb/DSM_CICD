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