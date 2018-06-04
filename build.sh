#!/usr/bin/env bash

TAG=conjur-authn-k8s-client:dev

function finish {
    rm -f authenticator
}
trap finish EXIT

echo "---"
echo "building conjur-authn-k8s-client-go with tag ${TAG} <<"

docker build -t conjur-authn-k8s-client-go:builder .
docker run --rm -v $PWD:/go/src/github.com/cyberark/conjur-authn-k8s-client \
  conjur-authn-k8s-client-go:builder env CGO_ENABLED=0 GOOS=linux \
  go build -a -installsuffix cgo -o authenticator .
docker build -f Dockerfile.scratch -t "${TAG}" .

echo "---"
