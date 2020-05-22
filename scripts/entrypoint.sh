#!/bin/bash
export HOME=/tmp
composer global require --no-progress "fxp/composer-asset-plugin:~1.4.2"
exec $@
