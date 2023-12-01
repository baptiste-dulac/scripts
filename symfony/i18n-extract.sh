#!/usr/bin/env bash
# Usage: bash i18n-extract.sh
ARG_1=$1
BLUE='\033[0;34m'
NC='\033[0m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
# Fail on error
set -e

echo -e "${BLUE}----------------------------------${NC}"
echo -e "${BLUE}- \033[0;34mExtracting i18n\033[0m"
echo -e "${BLUE}----------------------------------${NC}"

# Arg1 is a list of locales to extract, comma separated (e.g. en,fr)
IFS=',' read -ra LOCALES <<< "$ARG_1"

# Make sure we have at least one locale
if [ ${#LOCALES[@]} -eq 0 ]; then
    echo -e "${RED}✗ No locales specified${NC}"
    exit 1
fi

# Extract i18n
for LOCALE in "${LOCALES[@]}"; do
    echo -e "${YELLOW}➡ Extracting i18n for locale ${GREEN}${LOCALE}${NC}"
    symfony console t:e --force --domain messages --sort --format yaml $LOCALE -q
done

# Done (green)
echo -e "${GREEN}✓ Done${NC}"
