# development-flow

##Content
+ [Makefile](#Makefile)

###Makefile
This file contains useful commands you can use to easyly work with NodeJs/Javascript code (installl, build, test....) using docker containers.
Steps:
+ Navigate to the your local folder where the project is
+ Download this file. Use the command `wget https://raw.githubusercontent.com/pngcsgta/development-flow/master/Makefile -O Makefile`
+ Execute a command:
	+ **make boot**: Initialize/configure your "environment" creating an .env file
	+ **make clean**: clean your environment removing the .env file
	+ **make reboot**: reconfigure your environment removing the .env fil and creating another one
	+ **make install**: install repository dependencies
	+ **make build**: launcha webpack to build the distribution files
	+ **make build-dev**: launcha webpack to build the distribution files, for dev environment
	+ **make test**: Launch tests
	+ **make tdd**: Launch tdd tests
	+ **make test-unit**: Launch unit tests
	+ **make test-integration**: Launch integration tests
	+ **make test-functional**: Launch functional tests (gherkin)
	+ **make interactive**: Crate a container and start it interactively to allow you execute commands inside (install a dependency, install an app...)
