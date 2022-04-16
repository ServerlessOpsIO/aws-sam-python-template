#!/bin/sh

# Create file treee
sed -i.bak '/```bash/r'<(tree ./ --noreport -a -I .git -i '.!*') README.md
rm README.md.bak

# Initialize project
make init

# Initialize git
git init
git add ./
git commit -m "Initial commit"

