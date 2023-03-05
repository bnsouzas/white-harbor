#!/bin/sh
set -e
rm -rf krakend/krakend.json
if [ -f "./.env" ]; then
    echo "Set environment from .env file"
    source ./.env
fi
sed "s/_GOOGLE_CLOUD_PROJECT/${PROJECT_ID}/g" krakend/krakend.tpl.json | \
sed "s|_IRON_BANK_HOST_URL|${_IRON_BANK_HOST_URL}|g" | \
sed "s|_WALL_REGISTER_HOST_URL|${_WALL_REGISTER_HOST_URL}|g" | \
sed "s|_AUTH_JWK_URL|${_AUTH_JWK_URL}|g" | \
sed "s|_AUTH_AUDIENCE|${_AUTH_AUDIENCE}|g" | \
sed "s|_AUTH_SSO_AUDIENCE|${_AUTH_SSO_AUDIENCE}|g" | \
sed "s/_PROJECT_REGION/$$PROJECT_REGION/g" > krakend/krakend.json
echo "generated"