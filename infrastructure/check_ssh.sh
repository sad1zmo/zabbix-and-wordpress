#!/bin/bash

HOST=$1
PORT=22
TIMEOUT=300

for ((i=1; i<=TIMEOUT; i++)); do
  nc -z -w5 $HOST $PORT && echo "SSH is up!" && exit 0
  echo "Waiting for SSH to be available on $HOST..."
  sleep 1
done

echo "SSH not available on $HOST after $TIMEOUT seconds."
exit 1