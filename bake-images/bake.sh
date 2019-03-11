#!/bin/bash

set -euo pipefail

# load the enviromental variables
source ../.env

# Build frontend app image
bake_app() {
    packer build app_ami.json
}

# Build backend app image
bake_api() {
    packer build api_ami.json
}

# Build database image
bake_db() {
    packer build db_ami.json
}

# main function to build all images
main () {
    bake_app
    bake_api
    bake_db
}

# run main function
main