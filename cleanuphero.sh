#!/bin/bash
#
find .  -name "test*" -type d -exec rm -rf {} +
rc=$?
echo "$rc"

gh repo delete --yes $(gh repo list | grep test | awk '{print$1}' | tail -1 | sed -e 's/^.*\///')
rc=$?
echo "$rc"
