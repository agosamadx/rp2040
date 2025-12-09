all: debug

export USER_ID=$(shell id -u)
export GROUP_ID=$(shell id -g)
export SRC_DIR=${PWD}
export COMMIT=$(shell git rev-parse --short HEAD)

.PHONY: config
config:
	docker compose exec --workdir "${SRC_DIR}/program/build" builder cmake -G Ninja ..

.PHONY: debug
debug:
	docker compose exec --workdir "${SRC_DIR}/program/build" builder cmake --build . --config Debug --parallel

.PHONY: release
release: clean config
	docker compose exec --workdir "${SRC_DIR}/program/build" builder cmake --build . --config Release --parallel

.PHONY: install
install:
	docker compose exec --workdir "${SRC_DIR}/program/build" builder cmake --install . --prefix ../../firmware

.PHONY: format
format:
	docker compose exec --workdir "${SRC_DIR}" builder script/format_sources.sh program/include program/src

.PHONY: clean
clean:
	docker compose exec --workdir "${SRC_DIR}/program/build" builder git clean -fdx
	docker compose exec --workdir "${SRC_DIR}/app" builder git clean -fdx

.PHONY: up
up:
	docker compose up -d

.PHONY: down
down:
	docker compose down

.PHONY: restart
restart: down up

.PHONY: image
image:
	docker compose build

.PHONY: ps
ps:
	docker compose ps

.PHONY: bash
bash:
	docker compose exec builder /bin/bash

.PHONY: lsp
lsp:
	docker compose exec --workdir "${SRC_DIR}/program/build" builder clangd --compile-commands-dir=.

.PHONY: rmi
rmi:
	@./script/rmi_unused_images.sh
