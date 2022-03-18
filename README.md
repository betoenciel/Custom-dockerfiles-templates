# Custom-dockerfiles-templates

Algunas plantillas dockerfiles para crear imagenes docker basadas en Centos 7 con systemd habilitado.

Para construir la imágen utilizo:
$ docker build --rm --no-cache -t {{nombreDeImagen}} .

Para ejecutar el contanedor
$ docker run --privileged --name {{nombreDeContenedor}} -v /sys/fs/cgroup:/sys/fs/cgroup:ro --network proxy -p 443:443 -p 80:80 -d {{nombreDeImagen}}

Finalmente para habilitar los servicios se deben reiniciar los contenedores o ejecutar $ systemctl start {{servicio}}

En el caso del dockerfile de mariaDB es necesario ejecutar lo siguiente dentro del bash del contenedor:

$ systemctl start httpd
$ systemctl start mariadb
$ mysqladmin -u root password {{password}}
$ mariadb-secure-installation
