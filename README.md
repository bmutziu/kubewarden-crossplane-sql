# go-policy-template

This is a template repository you can use to scaffold a Kubewarden policy written using Go language.

Don't forget to check Kubewarden's
[official documentation](https://docs.kubewarden.io)
for more information about writing policies.

## Introduction

This repository has a working policy written in Go.

## Code organization

The code that takes care of parsing the settings is in the `settings.go` file.
Actual validation code is in the `validate.go` file.
The `main.go` only has the code to registers the entry points of the policy.

## Testing

This policy comes with unit tests implemented using the Go testing
framework.

As usual, the tests are defined in `_test.go` files.
As these tests aren't part of the final WebAssembly binary, the official Go compiler can be used to run them.

The unit tests can be run via a simple command:

```console
make test
```

It's also important to test the final result of the TinyGo compilation:
the actual WebAssembly module.

This is done with a second set of end-to-end tests.
These tests use the `kwctl` cli provided by the Kubewarden project to load and execute the policy.

The e2e tests are implemented using
[bats](https://github.com/bats-core/bats-core),
the Bash Automated Testing System.

The end-to-end tests are defined in the `e2e.bats` file and can be run using:

```console
make e2e-tests
```

## Automation

This project has the following [GitHub Actions](https://docs.github.com/en/actions):

- `e2e-tests`: this action builds the WebAssembly policy,
installs the `bats` utility and then runs the end-to-end test.
- `unit-tests`: this action runs the Go unit tests.
- `release`: this action builds the WebAssembly policy and pushes it to a user defined OCI registry
([ghcr](https://ghcr.io) is a good candidate).

## Distributing Policies
```console
docker run \
	--rm \
	-e GOFLAGS="-buildvcs=false" \
	-v ${PWD}:/src \
	-w /src tinygo/tinygo:0.30.0 \
	tinygo build -o policy.wasm -target=wasi -no-debug .

kwctl annotate policy.wasm \
    --metadata-path metadata.yml \
    --output-path annotated-policy.wasm
    
kwctl push annotated-policy.wasm \
    c8n.io/bmutziu/kubewarden-crossplane-sql:v0.0.2
```

