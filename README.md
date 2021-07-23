# Skeleton: Docker + Apache + PHP7.1

Estrutura base para aplicações web com Apache v2.4 e PHP v7.1

## Introdução

A partir das instruções abaixo você terá em seu ambiente local o projeto rodando para desenvolvimento ou teste.

### Requisitos

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [mkcert](https://github.com/FiloSottile/mkcert)

### Build

Execute a seguinte instrução na pasta raiz do projeto para que o ambiente seja compilado e preparado para execução:

```
docker-compose up -d
```

Esse irá compilar o [Dockerfile](Dockerfile) do projeto, inicializando assim o container base da aplicação.


### Execução

O funcionamento do ambiente pode ser valido a partir do acesso ao seu ambiente local pela porta padrão HTTP (80).

 ```
 curl http://localhost
 ```

## Tooling

* [Docker](https://docs.docker.com/get-docker/)
* [Apache](https://httpd.apache.org/docs/2.4/)
* [PHP](https://www.php.net/docs.php)
* [Supervisord](http://supervisord.org/installing.html)