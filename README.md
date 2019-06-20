# Stretch-php7.2-apache

Docker image built with Stretch, Php7.2, Apache, xDebug for Yii2 Development.

## Default settings
- default root of apache is `/app`

## Run with docker-compose (recommended)
Following is a sample of docker-compose

> It maps current directory to `/app`

```
version: '3'
services:
  web:
    image: its404/stretch-php7.2-apache
    volumes:
      - ./:/app
    ports:
      - '8000:80'
```

1.Create a file with name `docker-compose.yml` in your root directory of project

2.Copy above sample into `docker-compose.yml`

3.Run command `docker-compose up -d`

4.Access http://localhost:8000 from browser

## Run with docker command

1.Replace `local_path` to your real path on the host machine. 
For example, it's `/Users/test/Desktop` on Mac,
then run the command:

```docker run -d -p 8081:80 -v local_path:/var/www/public its404/alpine-php7.2-nginx```

> `-d`: run the container background

2.Access `http://localhost:8081` from browser


## Configue xDebug
xDebug is enabled by default, but you need to configure `remote_host`, and they are different on Windows and Mac

### xDebug configuration
1.Host machine configuration
    
- __Mac:__ 
xDebug is enabled by default on Mac, needn't to configure
  
- __Windows 10:__
Need to configure `PHP_XDEBUG_REMOTE_HOST` to `docker.for.win.localhost` in either docker-compose or docker command

__docker-compose sample__

```
version: '3'
services:
  web:
    image: its404/stretch-php7.2-apache
    volumes:
      - ./:/app
    ports:
      - '8000:80'
    environment:
      PHP_XDEBUG_REMOTE_HOST: docker.for.win.localhost
```

__docker command__

`docker run -d -p 8000:80 -v local_path:/app/web -e PHP_XDEBUG_REMOTE_HOST=docker.for.win.localhost its404/stretch-php7.2-apache`

> Replace `local_path` to your real host machine path

2.Configure VS code, following is a sample configuration

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/app/web": "/Users/test"
            }
        },
        {
            "name": "Launch currently open script",
            "type": "php",
            "request": "launch",
            "program": "${file}",
            "cwd": "${fileDirname}",
            "port": 9000
        }
    ]
}
```
