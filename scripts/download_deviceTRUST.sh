#!/bin/bash -uex

if [ -d "/tmp/deviceTRUST" ]; then
  rm -rf /tmp/deviceTRUST
fi

if [ -f "/tmp/deviceTRUST.zip" ]; then
  rm -f /tmp/deviceTRUST.zip
fi

wget --progress=bar:force -O /tmp/deviceTRUST.zip 'https://minio.prianto.com/devicetrust/deviceTRUST-19.1.100.zip'

unzip /tmp/deviceTRUST.zip -d /tmp/deviceTRUST/
