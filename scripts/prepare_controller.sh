#!/bin/bash -uex
chmod -R +x /tmp/scripts
/tmp/scripts/ansible_apt.sh
/tmp/scripts/download_deviceTRUST.sh