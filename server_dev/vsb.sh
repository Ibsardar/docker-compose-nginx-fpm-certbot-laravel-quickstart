#!/bin/bash

cd /workspaces/website
docker-compose down
rm -r node_modules
rm -r vendor
chown -R vscode /workspaces/website
docker-compose build --no-cache
