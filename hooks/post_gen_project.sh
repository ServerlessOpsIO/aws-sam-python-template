#!/bin/sh

# Create file treee
sed -i.bak '/```bash/r'<(tree ./ -a -I .git) README.md
rm README.md.bak

# Initialize project
make init

# Initialize git
git init
git add ./
git commit -m "Initial commit"

