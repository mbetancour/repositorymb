## Instrucciones para instalar un nagios con docker

## Clonar el repositorio

Con el siguiente comando puedes clonar el repositorio:

```sh
git clone https://github.com/mbetancour/repositorymb.git
```

## Se construye la imagen del repositorio 

```sh
cd repositorymb
```

```sh
docker build -t lab-nagios .
```

## Se ejecuta el contenedor

```sh
docker run -it -d -p 0.0.0.0:80:80 lab-nagios
```

## Ingresar

Credenciales:
```sh
Usuario: rootmb	
Clave: Duoc.2024
```

Utiliza tu ip publica en "http://x.x.x.x/nagios/" repositorymb
