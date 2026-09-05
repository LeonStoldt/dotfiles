#!/usr/bin/env bash
# Layer 3 — chezmoi dotfiles
# sourced by bootstrap.sh, which provides log()/warn() and repo_dir.

################################################################
# implementation
################################################################
log() {
    printf '\n\033[1m==> %s\033[0m\n' "$*"
}

warn() {
    printf '\033[33mwarning: %s\033[0m\n' "$*" >&2
}