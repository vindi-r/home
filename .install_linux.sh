#!/bin/bash

cp -r . ~
cd ~
. ~/.bashrc
<<<<<<< HEAD
##! Required by easy_install
mkdir -p ~/.local/python-site-packages/
##  Works without dudo due to ~/.pydistutils.cfg and PYTHONPATH
easy_install pip
=======
>>>>>>> 071676d79dea9c9941455bdc669e81b317427a7a

