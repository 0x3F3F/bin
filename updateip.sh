#!/bin/bash

# This command update the ip address in Op2Config with the supplied ip
# Usage 
# In .bashrc add:
# u () { $HOME/bin/updateip.sh $1 ; }

sed -r -i 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$1/ ~/.ssh/Op2Config

