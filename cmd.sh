#!/bin/bash

cd /opt/mitmoutput

# Start conversion, grabbing all params given
echo "Starting conversion..."

/usr/bin/mitmdump $@

echo "Conversion complete - reporting to EtcD."

# Reporting in to EtcD that our conversion is no longer running ("false") and set another endpoint to blank
# Customize the below to whatever you need to deliver status to EtcD - this is just an example

etcdctl put $CONVERTRUNNING_ETCD_ENDPOINT false
etcdctl put $CONVERTNAME_ETCD_ENDPOINT ""

exit 0
