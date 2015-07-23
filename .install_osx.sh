#!/bin/bash

cp -r . ~
echo '\
  #!/bin/sh\
  . ~/.bashrc' > ~/.bash_profile
cd ~
. ~/.bashrc
##! Required by easy_install
mkdir -p ~/.local/python-site-packages/
##  Works without sudo due to ~/.pydistutils.cfg and PYTHONPATH
easy_install pip

