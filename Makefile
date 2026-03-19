.PHONY: dev build preview install clean

install:
	bun install

dev:
	bun run dev

build:
	bun run build

preview:
	bun run preview

clean:
	rm -rf dist node_modules

.DEFAULT_GOAL := dev

# --- Docker & Homelab ---
# These targets are used when deploying to the homelab k3d cluster.
# Customize APP_NAME and image registry as needed.

APP_NAME ?= __APP_NAME__
REGISTRY ?= ghcr.io/emandor

docker-build:
	docker build -t $(REGISTRY)/$(APP_NAME):latest .

docker-run: docker-build
	docker run --rm -p 8080:80 $(REGISTRY)/$(APP_NAME):latest

k8s-apply:
	kubectl apply -f k8s/ -n apps

deploy-homelab: docker-build
	k3d image import $(REGISTRY)/$(APP_NAME):latest -c homelab
	kubectl set image deployment/$(APP_NAME) -n apps $(APP_NAME)=$(REGISTRY)/$(APP_NAME):latest
	kubectl rollout status deployment/$(APP_NAME) -n apps --timeout=120s

# ─── Homelab deployment targets ──────────────────────────────────────────────
APP_NAME := $(notdir $(CURDIR))

docker-build:
	docker build -t ghcr.io/emandor/$(APP_NAME):latest .

k8s-apply:
	kubectl apply -f k8s/ -n apps

deploy-homelab: docker-build
	k3d image import ghcr.io/emandor/$(APP_NAME):latest -c homelab
	kubectl set image deployment/$(APP_NAME) -n apps $(APP_NAME)=ghcr.io/emandor/$(APP_NAME):latest
	kubectl rollout status deployment/$(APP_NAME) -n apps --timeout=120s
