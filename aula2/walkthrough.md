# Walkthrough de desenvolvimento Ansible

## 1. Criei o arquivo de inventario o `hosts.ini`:
```toml
[localhost]
127.0.0.1 ansible_connection=local
```

## 2. Criei o arquivo `playbook.yaml`:
```yaml

- name: Playbook para gerenciar arquivos locais
  hosts: localhost
  connection: local
  tasks:
    - name: Criar um arquivo de teste
      file:
        path: /tmp/arquivo_de_teste.txt
        state: touch

```

## 3. Executei o comando docker no ambiente windows na maquina local:
```bash
docker run --rm -v "${PWD}:/ansible" -w /ansible deltamir/terraform-ansible:1.8.0 ansible-playbook playbook.yaml
```


## 4. Resultados do terminal
```
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Playbook para gerenciar arquivos locais] *********************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Criar um arquivo de teste] ***********************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

## 5. Mudei uma pequena configuração no playbook
ao invez de deixar o caminho como /temp/arquivo_de_teste
eu coloquei /ansible/arquivo de teste, que junto com o comando docker fez com que ele criasse esse arquivo de teste na pasta raiz desse projeto ansible.