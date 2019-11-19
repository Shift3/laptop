Shift3 Laptop setup and Dotfiles
================================

[![CircleCI](https://circleci.com/gh/Shift3/laptop.svg?style=svg)](https://circleci.com/gh/Shift3/laptop)

The scripts contained in this repo will setup your Mac, Ubuntu, Debian, or
Fedora computer with a base development environment, installing tools that we
find helpful and configuring them with sensible defaults.

It also maintains your dotfiles and provides a way for you to customize them to
your liking if desired.

The `setup` script is designed to be ran multiple times if necessary, it is
non-destructive, and will backup your previous dotfile setup if any exist.

Install
-------

You will need to keep the repo around somewhere safe, so lets make a folder for
it and clone the repo into it.

```sh
# Clone the repo (or download a zip file for a temporary setup)
cd
mkdir src && cd src
git clone git@github.com:Shift3/laptop.git
cd laptop

# run the setup script
./setup

# if prompted for your password at any point, please enter it, if asked any
# Y/N prompts, please hit Y <enter>
```


What it installs
----------------

macOS tools (if on mac):

* [Homebrew] package manager for mac

[Homebrew]: http://brew.sh/

Unix tools:

* [Git] for version control
* [OpenSSL] for Transport Layer Security (TLS)
* [The Silver Searcher] for finding things in files
* [Tmux] for saving project state and switching between projects
* [Watchman] for watching for filesystem events
* [Zsh] as your shell

[Git]: https://git-scm.com/
[OpenSSL]: https://www.openssl.org/
[The Silver Searcher]: https://github.com/ggreer/the_silver_searcher
[Tmux]: http://tmux.github.io/
[Watchman]: https://facebook.github.io/watchman/
[Zsh]: http://www.zsh.org/

GitHub tools:

* [Hub] for interacting with the GitHub API

[Hub]: http://hub.github.com/

Image tools:

* [ImageMagick] for cropping and resizing images

[ImageMagick]: https://imagemagick.org/index.php

Databases:

* [Postgres] for storing relational data
* [Redis] for storing key-value data
* [Mongo] for non-relational data

[Postgres]: http://www.postgresql.org/
[Redis]: http://redis.io/
[Mongo]: https://www.mongodb.com/
