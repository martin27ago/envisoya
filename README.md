# README

Obligatorio 1
* Arquitectura de software en la práctica
* Maria Ines Fernandez - 186503
* Martin Gonzalez -  146507


* Descripcion
El sistema fue desarrollado para la empresa Envios Ya, que quiere revolucionar el mercado de los envíos de paquetes, debido a que hoy dia es un proceso que consume mucho tiempo, el costoso y tedioso. La idea fue aplicar un modelo de economía colaborativa, ofreciendo un servicio fácil de usar a través de un sistema web moderno. Se desarrolló usando la tecnología Ruby on Rails.

* Tecnologias
  - Framework Ruby on rails
  - Base de datos postgres
  - Deploy en servidor bluemix : enviosya-arq-gf-app.mybluemix.net

* Servicios 
  Base de datos postgres
  servidor redis
  jobs sidekiq

* Manual de instalacion 

1.	Bajarse del repositorio el código fuente.
2.	Abrir una consola y prender el servidor redis mediante el comando: redis-server
3.	En otra consola prender el servidor de sidekiq con el comando : sidekiq
4.	Cambiar el database.yml en el proyecto con la configuración de base de datos.
5.	Correr los siguientes comandos para crear la base de datos y cargar datos de prueba
a.	rake db:setup
b.	rake db:seed
6.	Prender el servidor rail.
7.	La aplicación esta lista para ser usada!
