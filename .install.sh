#!/bin/bash

if test "$0" = ".install.sh"; then
  echo "error: script should be sourced, not executed"
  exit
else
  echo "starting with script name $0"
fi

##  Copy checked out home dir into actual home.
copyToHome() {
  if test $(pwd) != ~; then
    echo "info: copying repository into ~ ..."
    cp -r . ~ > /dev/null
    cd ~
  else
    echo "skip: home dir already in place"
  fi
}


setBashAutoload() {
  ##  OSX?
  if test "$OSTYPE" = "darwin"; then
    echo "info: configuring ~/.bashrc autoload ..."
    echo '\
      #!/bin/sh\
      . ~/.bashrc' > ~/.bash_profile
  fi
}


sourceBashConfig() {
  if ! test ${BASHRC_LOADED}; then
    echo "info: loading ~/.bashrc ..."
    . ~/.bashrc > /dev/null
  else
    echo "skip: ~/.bashrc already loaded"
  fi
}


createDocsDir() {
  if ! test -e "~/Documents"; then
    ##  Required for vim config.
    mkdir ~/Documents
  fi
}


copyToHome
setBashAutoload
sourceBashConfig
createDocsDir


if ! type curl 2>&1 > /dev/null; then
  echo "info: installing curl"
  if type apt-get 2>&1 > /dev/null; then
    sudo apt-get install -y curl > /dev/null
  else
    sudo dnf install -y curl > /dev/null
  fi
else
  echo "skip: curl already installed"
fi

if ! type make 2>&1 > /dev/null; then
  echo "info: installing build tools"
  if type apt-get 2>&1 > /dev/null; then
    sudo apt-get install -y build-essential > /dev/null
  else
    sudo dnf groupinstall -y "Development Tools"  > /dev/null
  fi
else
  echo "skip: build tools already installed"
fi

##! Required by easy_install
mkdir -p ~/.local/python-site-packages/

if ! type git 2>&1 > /dev/null; then
  if test "$OSTYPE" = "darwin"; then
    echo "error: no git found on osx"
  else
    echo "info: installing git ..."
    if type apt-get 2>&1 > /dev/null; then
      sudo apt-get install -y git > /dev/null
    else
      sudo dnf install -y git > /dev/null
    fi
  fi
else
  echo "skip: git already installed"
fi

if ! type hg 2>&1 > /dev/null; then
  echo "info: installing mercurial ..."
  if test "$OSTYPE" = "darwin"; then
    brew install hgsvn
  else
    if type apt-get 2>&1 > /dev/null; then
      sudo apt-get install -y hgsvn > /dev/null
    else
      sudo dnf install -y hgsvn > /dev/null
    fi
  fi
else
  echo "skip: mercurial already installed"
fi

if ! type ag 2>&1 > /dev/null; then
  echo "info: installing ag ..."
  if test "$OSTYPE" = "darwin"; then
    brew install the_silver_searcher
  else
    if type apt-get 2>&1 > /dev/null; then
      sudo apt-get install -y silversearcher-ag > /dev/null
    else
      sudo dnf install -y the_silver_searcher > /dev/null
    fi
  fi
else
  echo "skip: mercurial already installed"
fi

if ! type pip 2>&1 > /dev/null; then
  ##  Works without sudo due to ~/.pydistutils.cfg and PYTHONPATH
  if type easy_install 2>&1 > dev/null; then
    echo "info: installing pip via easy_install ..."
    easy_install pip > /dev/null
  else
    echo "info: installing pip via get-pip.py ..."
    curl -s https://bootstrap.pypa.io/get-pip.py | python > /dev/null
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

if ! test -d ~/.vim/bundle/Vundle.vim; then
  echo "info: installing vundle ..."
  URL=https://github.com/VundleVim/Vundle.vim.git
  git clone $URL ~/.vim/bundle/Vundle.vim 2>&1 > /dev/null
else
  echo "skip: vundle already installed"
fi

if ! type tmux 2>&1 > /dev/null; then
  echo "info: installing tmux with 32-bit color support ..."
  if test "$OSTYPE" = "darwin"; then
    brew install libevent-dev libncurses-dev > /dev/null
  else
    if type apt-get 2>&1 > /dev/null; then
      sudo apt-get install -y libevent-dev libncurses-dev > /dev/null
    else
      sudo dnf install -y libevent-devel ncurses-devel > /dev/null
    fi
  fi
  curl -L -s -o tmux.tar.gz https://goo.gl/oLa6qo
  tar xf tmux.tar.gz > /dev/null
  rm tmux.tar.gz
  cd ./tmux-2.1
  curl -L -s -o tmux.diff https://goo.gl/1WjB51
  patch -p1 < tmux.diff > /dev/null
  ./configure > /dev/null
  make > /dev/null
  sudo make install > /dev/null
  cd ..
  rm -rf ./tmux-2.1
else
  echo "skip: tmux already installed"
fi

if ! type vim 2>&1 > /dev/null; then
  echo "info: installing vim with 32-bit color support ..."
  if test "$OSTYPE" = "darwin"; then
    brew install python-dev libncurses-dev > /dev/null
  else
    if type apt-get 2>&1 > /dev/null; then
      sudo apt-get install -y python-dev libncurses-dev > /dev/null
    else
      sudo dnf install -y python-devel ncurses-devel > /dev/null
    fi
  fi
  hg clone https://bitbucket.org/ZyX_I/vim > /dev/null
  cd ./vim/src
  PYTHON_LIB_DIR="/usr/lib/python2.7/config"
  if test -e /usr/lib64; then
    PYTHON_LIB_DIR="/usr/lib64/python2.7/config"
  fi
  ./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp \
    --enable-pythoninterp \
    --with-python-config-dir=$PYTHON_LIB_DIR \
    --enable-luainterp \
    --enable-termtruecolor > /dev/null
  make > /dev/null
  sudo make install > /dev/null
  cd ./../../
  rm -rf ./vim
else
  echo "skip: vim already installed"
fi

