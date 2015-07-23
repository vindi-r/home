#!/bin/bash

cp -r . ~
cd ~
. ~/.bashrc
##! Required by easy_install
mkdir -p ~/.local/python-site-packages/
##  Works without dudo due to ~/.pydistutils.cfg and PYTHONPATH
easy_install pip

