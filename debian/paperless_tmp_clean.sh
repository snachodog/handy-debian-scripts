#!/bin/bash
find /var/lib/docker/overlay2/${TMP}/diff/tmp -type f -atime +1 -exec rm -f {} \;
