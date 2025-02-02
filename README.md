# My git config

This is my local config for [git](https://git-scm.com/).

## Install

This project uses [just](https://github.com/casey/just) and [stow](https://www.gnu.org/software/stow/) for the installation.

```bash
just install
```

Considering `git` is already installed, you can just run:

```bash
just config
```

> [!IMPORTANT]
> Be sure to set the environment variables `GIT_NAME` and `GIT_EMAIL` to correctly set up the config:
> ```bash
> export GIT_NAME="John Doe"
> export GIT_EMAIL="john.doe@example.com"
> ```
