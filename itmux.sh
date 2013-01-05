# itmux - convinence functions for using iTerm2/tmux integration over ssh.
#
# Usage:
#
#    $ source $0         # Preferably put in your .*shrc
#    $ itmux-ssh <host>
#
# To compile and install the iTerm2-enabled tmux on the remote host, you
# can try issuing:
# 
#    $ itmux-ssh-install <host>
#
# This is an automatic installer tested on Ubuntu Quantal 12.10 If this
# fails, you might have to install it manually.
#
# Author: Emil Stenqvist <emsten@gmail.com>
# Copyleft (C) 2013
#

local ITMUX_TMUX_RELATIVE_PATH=local/bin/tmux
local ITERM2_URL="http://iterm2.googlecode.com/files/iTerm2-1_0_0_20120726.zip"

local RED="\033[0;31m"
local GREEN="\033[0;32m"
local YELLOW="\033[0;33m"
local NORMAL="\033[0m"

function itmux-ssh() {
    local arg_attach

    CMD="ssh $@ -t $ITMUX_TMUX_RELATIVE_PATH -C"

    # Check if session exists on server and if so, attach to it.
    eval $CMD has-session &> /dev/null
    if [[ $? -eq 0 ]]; then
        arg_attach="attach"
    fi

    eval $CMD $arg_attach
    
    if [[ $? -eq 0 ]]; then
        echo -e $GREEN"Session detached."$NORMAL
    else
        echo $RED"tmux returned with error exit status - have you installed the required"
        echo "iTerm2 version of tmux on the remote host? Try doing:"
        echo $YELLOW"\$ itmux-ssh-install $@"$NORMAL
    fi

}

function itmux-ssh-install {
    local PACKAGES="autotools-dev automake autoconf pkg-config libevent-dev libncurses5-dev curl unzip"

    echo "$(cat <<EOF
[[ -x \$(which apt-get) ]] || {
    echo
    echo "Can't locate apt-get! tmux needs the following packages to build:"
    echo
    echo "  $PACKAGES"
    echo
    exit 1
}

DEBIAN_FRONTEND=noninteractive sudo apt-get -q -y install $PACKAGES

TMP=\$(mktemp -d)
pushd \$TMP &> /dev/null

curl -O $ITERM2_URL &&
unzip -q *.zip && 
tar xfz tmux-for-iTerm2-*.tar.gz &&
cd tmux &&
./configure --prefix=\$HOME/local &&
make && make install

[ \$? -eq 0 ] || {
    echo
    echo "installation failed, exiting."
    echo
    exit 1
}

echo 'export PATH="\$HOME/local/bin:\$PATH"' >> \$HOME/.bashrc

popd &> /dev/null
rm -rf \$TMP
EOF
)" | ssh $@
}

