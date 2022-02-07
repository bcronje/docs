
docker pull squidfunk/mkdocs-material
docker build -t mkdocs-enclave .
docker run --rm -it -p 8000:8000 -v ${PSScriptRoot}:/docs mkdocs-enclave
