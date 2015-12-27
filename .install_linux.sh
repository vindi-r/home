#!/bin/bash

cp -r . ~
cd ~
. ~/.bashrc
##! Required by easy_install
mkdir -p ~/.local/python-site-packages/
##  Works without sudo due to ~/.pydistutils.cfg and PYTHONPATH
##FIXME: Fedora
##  easy_install pip

