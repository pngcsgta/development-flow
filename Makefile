VERSION              := `node -pe "require('./package.json').version"`
NAME                 := `node -pe "require('./package.json').name"`
FOLDER               := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BOOTSTRAP            := sh /root/bootstrap.sh
CMD_INSTALL          := ${BOOTSTRAP}; npm install
CMD_BUILD            := ${BOOTSTRAP}; npm run build
CMD_BUILD_DEV        := ${BOOTSTRAP}; npm run build:dev
CMD_TEST             := ${BOOTSTRAP}; npm run test
CMD_TDD              := ${BOOTSTRAP}; npm run tdd
CMD_TEST_UNIT        := ${BOOTSTRAP}; npm run test:unit
CMD_TEST_INTEGRATION := ${BOOTSTRAP}; npm run test:integration
CMD_TEST_FUNCTIONAL  := ${BOOTSTRAP}; npm run test:functional
IMAGE_REPO           := ngcs-dev-tools01.arsysdesarrollo.lan:5000
IMAGE_VERSION        := latest
IMAGE                := ${IMAGE_REPO}/gta-ci:${IMAGE_VERSION}


.PHONY: check
check:
ifeq ($(wildcard .env), .env)
include .env
else
ifneq ($(MAKECMDGOALS), boot)
$(error You must run "make boot" first)
endif
endif

.PHONY: boot
boot:
	@if [ ! -f .env ]; then echo "VERSION_VARIABLE=${VERSION}\nNAME_VARIABLE=${NAME}\nIMAGE=${IMAGE}" > .env; fi

clean:
	@rm -rf .env

###################
### Reglas Misc ###
###################

# Cambiar los permisos de todas las carpetas y ficheros
.PHONY: permissions
permissions:
	@sudo chown -fR root ${FOLDER}
	@sudo chmod -fR 777 ${FOLDER}

# Limpiar el entorno antes de instalar
.PHONY: clean-environment
clean-environment :
	@sudo rm -rf node_modules

##################
### Reglas NPM ###
##################

# Instalar dependencias en integracion continua
.PHONY: install-ci
install:
	@docker run --rm --name install-${NAME_VARIABLE}-${VERSION_VARIABLE} -v ${FOLDER}:/root/project ${IMAGE} /bin/bash -c '${CMD_INSTALL}'

# Instalar dependencias
.PHONY: install
install: clean-environment permissions
	@docker run --rm --name install-${NAME_VARIABLE}-${VERSION_VARIABLE} -v ${FOLDER}:/root/project ${IMAGE} /bin/bash -c '${CMD_INSTALL}'
	@$(MAKE) permissions

# Build
.PHONY: build
build:
	@docker run --rm --name install-${NAME_VARIABLE}-${VERSION_VARIABLE} -v ${FOLDER}:/root/project ${IMAGE} /bin/bash -c '${CMD_BUILD}'

# Build dev
.PHONY: build-dev
build-dev:
	@docker run --rm --name install-${NAME_VARIABLE}-${VERSION_VARIABLE} -v ${FOLDER}:/root/project ${IMAGE} /bin/bash -c '${CMD_BUILD_DEV}'

# Launch test
.PHONY: test
test: start-up
	@docker exec container-${NAME_VARIABLE}-${VERSION_VARIABLE} /bin/bash -c '${CMD_TEST}'
	@$(MAKE) destroy

# Launch tdd
.PHONY: tdd
tdd: start-up
	@docker exec container-${NAME_VARIABLE}-${VERSION_VARIABLE} /bin/bash -c '${CMD_TDD}'
	@$(MAKE) destroy

# Launch test-unit
.PHONY: test-unit
test-unit: start-up
	@docker exec container-${NAME_VARIABLE}-${VERSION_VARIABLE} /bin/bash -c '${CMD_TEST_UNIT}'
	@$(MAKE) destroy

# Launch test-integration
.PHONY: test-integration
test-integration: start-up
	@docker exec container-${NAME_VARIABLE}-${VERSION_VARIABLE} /bin/bash -c '${CMD_TEST_INTEGRATION}'
	@$(MAKE) destroy

# Launch test-functional
.PHONY: test-functional
test-functional: start-up
	@docker exec container-${NAME_VARIABLE}-${VERSION_VARIABLE} /bin/bash -c '${CMD_TEST_FUNCTIONAL}'
	@$(MAKE) destroy

#####################
### Reglas Docker ###
#####################

# Contenedor interactivo
.PHONY: interactive
interactive:
	@docker run --rm --name interactive-${NAME_VARIABLE}-${VERSION_VARIABLE} -v ${FOLDER}:/root/project -i -t ${IMAGE} /bin/bash

# Construir el entorno
.PHONY: start-up
start-up: boot
	@docker-compose up -d

# Construir el entorno
.PHONY: destroy
destroy: boot
	@docker-compose down
