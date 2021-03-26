REGISTRY:=r.planetary-quantum.com/quantum-public
NAME=example-go-app
VERSION?=dev

CLI:=r.planetary-quantum.com/quantum-public/cli:2

## BUILDING

.PHONY: build
build:
	docker build -t $(REGISTRY)/$(NAME):$(VERSION) .

.PHONY: push
push:
	docker push $(REGISTRY)/$(NAME):$(VERSION)

## LOCAL DEVELOPMENT

.PHONY: dev
dev: build
	docker run \
		-it \
		--rm \
		-e HELLO_RESPONSE \
		-p 8080:8080 \
		$(REGISTRY)/$(NAME):$(VERSION)

## ONLINE DEPLOYMENT

.PHONY: deploy
deploy: build push
	docker run \
		--rm \
		-v $(CURDIR):/work -w /work \
		-e QUANTUM_USER \
		-e QUANTUM_PASSWORD \
		-e QUANTUM_ENDPOINT \
		-e QUANTUM_STACK \
		-e HELLO_RESPONSE \
		-e VERSION=$(VERSION) \
		$(CLI) quantum-cli stacks update --create --wait --stack ${QUANTUM_STACK}
