# itmux
### convinence functions for using iTerm2/tmux integration over ssh.

# Installation

Just source `itmux.sh` in your shell and you will get the alias
`itmux-ssh`, that you use instead of `ssh` to automatically create or
attach to a iTerm2/tmux session directly upon connection.

# Usage

```bash
$ source $0         # Preferably put in your .*shrc
$ itmux-ssh <host>
```

To compile and install the iTerm2-enabled tmux on the remote host, you
can try issuing:

```bash
   $ itmux-ssh-install <host>
```

This is an automatic installer tested on Ubuntu Quantal 12.10 If this
fails, you might have to install it manually.

## Using with vagrant

Using `vagrant`? If you install [this](https://github.com/kvs/vagrant-proxyssh) great gem, you can ssh
to your vagrant machine by just doing `ssh vagrant`. This means 
you can also do

```bash
   $ itmux-ssh-install vagrant
```

# Credits

Author: Emil Stenqvist <emsten@gmail.com>
Copyleft (C) 2013

