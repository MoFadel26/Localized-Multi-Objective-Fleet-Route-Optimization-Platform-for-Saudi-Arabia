#!/bin/bash
# Initialize git repo and create initial commit
cd "$(dirname "$0")"
git init
git add .
git commit -m "Initial commit"
echo "Done. Repository initialized with initial commit."
