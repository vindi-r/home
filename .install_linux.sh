#!/bin/bash

##  Copy checked out home dir into actual home.
if test $(pwd) != ~; then
  cp -r . ~
  cd ~
else
  echo "info: home dir already in place"
fi

if ! test ${BASHRC_LOADED}; then
  . ~/.bashrc
else
  echo "info: ~/.bashrc already loaded"
fi

##! Required by easy_install
mkdir -p ~/.local/python-site-packages/

if ! which pip 2>&1 > /dev/null; then
  ##  Works without sudo due to ~/.pydistutils.cfg and PYTHONPATH
  easy_install pip
else
  echo "info: pip already installed"
fi

