#!/usr/bin/env bash
NPM_EXEC=$1
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
# Check if npm exec is set or set it to pnpm
if [ -z "$NPM_EXEC" ]
then
    NPM_EXEC=pnpm
fi


function title
{
    #write title
    echo -e "$GREEN -----------------------------------------------"
    echo -e " -"
    echo -e " - $1"
    echo -e " -"
    echo -e " -----------------------------------------------$NC"
}

# Set -e to fail if any command fails
set -e

# Git pull
title "Git pull"
git pull

# Composer install
title "Composer install"
composer install

# Npm install
title "$NPM_EXEC install"
$NPM_EXEC install

# Npm run build
title "$NPM_EXEC run build"
$NPM_EXEC run build

# Clear cache
title "Clear cache"
php bin/console cache:clear

# Migrate database
title "Migrate database"
php bin/console doctrine:migrations:migrate -n
