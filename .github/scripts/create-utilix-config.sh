#!/bin/bash

# Create config with write permissions!
cat > $HOME/.xenon_config <<EOF
[RunDB]
rundb_api_url = $RUNDB_API_URL
rundb_api_user = $RUNDB_API_USER
rundb_api_password = $RUNDB_API_PASSWORD
xent_url = $PYMONGO_URL
xent_user = $PYMONGO_USER
xent_password = $PYMONGO_PASSWORD
xent_database = $PYMONGO_DATABASE
xe1t_url = $XE1T_URL
xe1t_user = $XE1T_USER
xe1t_password = $XE1T_PASSWORD
xe1t_database = $XE1T_DATABASE
EOF

