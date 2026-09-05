#!/usr/bin/env bash
# Layer 3 — chezmoi dotfiles
# sourced by bootstrap.sh, which provides log()/warn() and repo_dir.

################################################################
# implementation
################################################################
setup_chezmoi() {
  local state_dir="${HOME}/.local/state/machine-setup"
  mkdir -p "${state_dir}"

  ensure_age_key
  resolve_dotfiles_source "${state_dir}/dotfiles-source"
  apply_chezmoi "${dotfiles_source}"
}

# Needed to decrypt secrets tracked in the dotfiles repo (SSH config, Maven
# credentials, ...). Only asks if it isn't there yet — gives a chance to
# copy it in (USB stick, scp from another machine, ...) or type it in
# directly. Once present, later runs are non-interactive.
ensure_age_key() {
  local age_key="${HOME}/.config/chezmoi/key.txt"
  if [ -r "${age_key}" ]; then
    log "Using existing age key at ${age_key}"
    return 0
  fi

  mkdir -p "$(dirname "${age_key}")"
  cat <<EOF
No age key found at ${age_key}.
It's needed to decrypt secrets tracked in the dotfiles repo. Options:
  * Copy it in now (e.g. from a USB stick, in another terminal), then just press Enter below, or
  * Paste the "AGE-SECRET-KEY-1..." line below now, or
  * Leave empty to skip for now and generate a fresh one later with:
        age-keygen -o ${age_key}
    (anything already encrypted with a different key won't decrypt though)
EOF
  local pasted_key
  read -rp "Age key (or Enter if already copied or to skip): " pasted_key
  if [ -n "${pasted_key}" ]; then
    printf '%s\n' "${pasted_key}" > "${age_key}"
    chmod 600 "${age_key}"
  fi
  [ -r "${age_key}" ] || warn "still no age key at ${age_key} — continuing without secrets decryption"
}

# Asks only once which chezmoi source to use, then remembers it in
# "${1}" (a state file) so 2nd+ runs stay non-interactive. Prefers a
# dotfiles repo bundled alongside bootstrap.sh, otherwise falls back to the
# GitHub username convention chezmoi resolves to github.com/<user>/dotfiles.
resolve_dotfiles_source() {
  local source_file="${1}"
  local bundled_dotfiles="${repo_dir}/dotfiles"

  if [ -r "${source_file}" ]; then
    dotfiles_source="$(cat "${source_file}")"
    return 0
  fi

  if [ -d "${bundled_dotfiles}" ]; then
    local use_bundled
    read -rp "Use bundled dotfiles at ${bundled_dotfiles}? [Y/n] " use_bundled
    if [[ "${use_bundled}" =~ ^[Nn] ]]; then
      prompt_github_username
    else
      dotfiles_source="${bundled_dotfiles}"
    fi
  else
    prompt_github_username
  fi

  printf '%s\n' "${dotfiles_source}" > "${source_file}"
}

prompt_github_username() {
  read -rp "GitHub username to init chezmoi from (github.com/<user>/dotfiles) [LeonStoldt]: " dotfiles_source
  dotfiles_source="${dotfiles_source:-LeonStoldt}"
}

apply_chezmoi() {
  local source="${1}"
  local bootstrap_done="${HOME}/.local/state/machine-setup/bootstrap.done"

  if [ -f "${bootstrap_done}" ]; then
    log "Applying chezmoi non-interactively (source: ${source})"
    chezmoi apply
    return 0
  fi

  log "Initializing chezmoi (source: ${source})"
  if [ -d "${source}" ]; then
    chezmoi init --apply --source="${source}"
  else
    chezmoi init --apply "${source}"
  fi
}