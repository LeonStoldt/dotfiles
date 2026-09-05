#!/usr/bin/env bash
# Provision machine: layer 2 (nix/home-manager) and layer 3 (chezmoi dotfiles) on top of the OS.
# Idempotent — safe to re-run to pick up changes.
set -euo pipefail
shopt -s nullglob

################################################################
# args
################################################################
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
flake="${repo_dir}/nix"
user="$(id -un)"
marker="${HOME}/.local/state/machine-setup/bootstrap.done"

# shellcheck source=lib/logging.sh
source "${repo_dir}/lib/logging.sh"
# shellcheck source=lib/chezmoi.sh
source "${repo_dir}/lib/chezmoi.sh"

################################################################
# implementation
################################################################
# Only asks on the very first run (before "${marker}" exists) — later manual re-runs are idempotent and don't need to ask again.
confirm_start_on_first_run() {
  [ -e "${marker}" ] && return 0
  cat <<'EOF'
==============================================================
  Machine setup
==============================================================
This will:
  1. Install/apply the Nix + home-manager configuration
  2. Initialize and apply your chezmoi-managed dotfiles

Safe to re-run any time to pick up later changes.
==============================================================
EOF
  read -rp "Press Enter to start (Ctrl+C to abort)... " _
}

check_nix() {
  if command -v nix >/dev/null 2>&1; then
    return 0
  fi

  cat >&2 <<'EOF'
error: nix is not available.

The OS layer is supposed to provide it (OS installs nix + nix-daemon).
Check: 'systemctl status nix-setup.service nix.mount nix-daemon.service'
EOF
  exit 1
}

enable_nix_flakes() {
  mkdir -p "${HOME}/.config/nix"
  if ! grep -qs 'experimental-features.*flakes' "${HOME}/.config/nix/nix.conf" 2>/dev/null; then
    log "Enabling nix flakes for ${user}"
    echo 'experimental-features = nix-command flakes' >> "${HOME}/.config/nix/nix.conf"
  fi
}

apply_home_manager() {
  log "Applying home-manager configuration (#${user})"
  if command -v home-manager >/dev/null 2>&1; then
    home-manager switch --flake "${flake}#${user}"
  else
    # First run: home-manager isn't installed yet, so do via `nix run`.
    nix run home-manager/master -- switch --flake "${flake}#${user}"
  fi
}

# Marks bootstrap as completed
# (in my case: checked by bootstrap.service (the first-login terminal)
mark_done() {
  mkdir -p "$(dirname "${marker}")"
  date -Is > "${marker}"
  log "Setup complete."
}

################################################################
# main()
################################################################
confirm_start_on_first_run
check_nix
enable_nix_flakes
apply_home_manager
setup_chezmoi
mark_done
