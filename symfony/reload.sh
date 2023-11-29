NPM_EXEC=$1

# Check if npm exec is set or set it to pnpm
if [ -z "$NPM_EXEC" ]
then
    NPM_EXEC=pnpm
fi

#!/usr/bin/env bash
function title
{
    #write title
    echo "\033[32m -----------------------------------------------"
    echo " $1"
    echo " -----------------------------------------------\033[0m"
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
php bin/console doctrine:migrations:migrate
