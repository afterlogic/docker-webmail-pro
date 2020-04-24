afterlogic/docker-webmail-pro
=============================

Out-of-the-box [Afterlogic WebMail Pro](http://www.afterlogic.com/webmail-client) image

Includes Apache, MySQL and PHP setup based on [fauria/docker-lamp package](https://github.com/fauria/docker-lamp)


Creating the image
------------------

	docker build -t afterlogic/docker-webmail-pro .


Running docker image
--------------------

Start your image binding the external port 80:

	docker run -d -p 80:80 afterlogic/docker-webmail-pro

and access the container via web browser at http://localhost/


Alternately, you can use any other port available, e.g. 800:

	docker run -d -p 800:80 afterlogic/docker-webmail-pro

and access the installation at http://localhost:800/


Accessing admin interface
------------------------------

To configure WebMail Pro installation, log into admin interface using main WebMail URL.

Default credentials are **superadmin** login and empty password.


Licensing Terms & Conditions
----------------------------

Content of this repository is available in terms of [AGPLv3 license](http://www.gnu.org/licenses/agpl-3.0.en.html) (see `LICENSE` file)