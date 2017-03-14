#!/bin/bash

cp -r Main  $1

cd $1

ls |
sed -n 's/\(.*\)\(Main\)\(.*\)/mv "\1\2\3" "\1'$1'\3"/p' |
sh

cd Protocol

ls |
sed -n 's/\(.*\)\(Main\)\(.*\)/mv "\1\2\3" "\1'$1'\3"/p' |
sh

cd ..
cd View

ls |
sed -n 's/\(.*\)\(Main\)\(.*\)/mv "\1\2\3" "\1'$1'\3"/p' |
sh
cd ..
LC_ALL=C
find . -type f -name '*.*' -exec sed -i '' s/Main/"$1"/g {} +
