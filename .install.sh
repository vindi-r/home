#!/bin/bash

##  Copy checked out home dir into actual home.
if test $(pwd) != ~; then
  echo "info: copying repository into ~ ..."
  cp -r . ~ > /dev/null
  cd ~
else
  echo "skip: home dir already in place"
fi

##  OSX?
if test "$OSTYPE" = "darwin"; then
  echo "info: configuring ~/.bashrc autoload ..."
  echo '\
    #!/bin/sh\
    . ~/.bashrc' > ~/.bash_profile
fi

if ! test ${BASHRC_LOADED}; then
  echo "info: loading ~/.bashrc ..."
  . ~/.bashrc > /dev/null
else
  echo "skip: ~/.bashrc already loaded"
fi

##! Required by easy_install
mkdir -p ~/.local/python-site-packages/

if ! which pip 2>&1 > /dev/null; then
  ##  Works without sudo due to ~/.pydistutils.cfg and PYTHONPATH
  if which easy_install 2>&1 > dev/null; then
    echo "info: installing pip via easy_install ..."
    easy_install pip > /dev/null
  else
    echo "info: installing pip via get-pip.py ..."
    curl https://bootstrap.pypa.io/get-pip.py | python
  fi
else
  echo "skip: pip already installed"
fi

if ! test -d ~/.git-radar; then
  echo "info: installing git-radar ..."
  URL=https://github.com/michaeldfallen/git-radar
  git clone $URL .git-radar 2>&1 > /dev/null
else
  echo "skip: git-radar already installed"
fi

