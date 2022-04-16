#!/bin/sh

# Create file treee
sed -i.bak '/```bash/r'<(tree ./ --noreport -a -I .git -I README.md.bak -I '.!*') README.md
rm README.md.bak

# Initialize project
make init

# Initialize git
git init
git add ./
git commit -m "Initial commit"

