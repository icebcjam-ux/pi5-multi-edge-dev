#!/bin/bash
cd "$(dirname "$0")"

MSG=${1:-"update: auto commit and push"}

git add .
git commit -m "$MSG"
git push origin main

echo "----------------------------------------"
echo " Success: Code pushed to GitHub! "
echo "----------------------------------------"