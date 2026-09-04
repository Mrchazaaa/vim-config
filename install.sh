#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${VIMCONFIG_REPO_URL:-https://github.com/Mrchazaaa/vim-config.git}"
INSTALL_DIR="${VIMCONFIG_INSTALL_DIR:-$HOME/.config/nvim/vim-config}"
HELPER_URL="${VIMCONFIG_HELPER_URL:-https://raw.githubusercontent.com/Mrchazaaa/vim-config/master/scripts/lib/install-helpers.sh}"
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
SCRIPT_DIR=""
HELPER_PATH=""

if [[ -n "$SCRIPT_PATH" && -f "$SCRIPT_PATH" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
  HELPER_PATH="$SCRIPT_DIR/scripts/lib/install-helpers.sh"
fi

# shellcheck source=scripts/lib/install-helpers.sh
if [[ -n "$HELPER_PATH" && -f "$HELPER_PATH" ]]; then
  source "$HELPER_PATH"
else
  command -v curl >/dev/null 2>&1 || {
    printf 'Error: curl is required to bootstrap the remote installer helper.\n' >&2
    exit 1
  }
  # shellcheck source=/dev/null
  source <(curl -fsSL "$HELPER_URL")
fi

usage() {
  cat <<USAGE
Usage: ./install.sh [--all] [--vim] [--nvim] [--ideavim] [--help]

With no target flags, installs Vim and Neovim shims.

Options:
  --all       Install Vim, Neovim, and IdeaVim shims
  --vim       Install only the Vim shim
  --nvim      Install only the Neovim shim
  --ideavim   Install only the IdeaVim shim
  --help      Show this help
USAGE
}

install_or_update_repo() {
  mkdir -p "$(dirname "$INSTALL_DIR")"

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    log "Existing vim-config Git checkout found at $INSTALL_DIR."
    if ask_yes_no "Pull the latest changes for the deployed vim config?"; then
      git -C "$INSTALL_DIR" pull --ff-only
    else
      log "Leaving existing checkout unchanged."
    fi
    return 0
  fi

  if [[ -e "$INSTALL_DIR" ]]; then
    die "$INSTALL_DIR already exists but is not a Git checkout. Move it aside or set VIMCONFIG_INSTALL_DIR to another path."
  fi

  log "Cloning vim-config into $INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
}

parse_targets() {
  INSTALL_VIM=0
  INSTALL_NVIM=0
  INSTALL_IDEAVIM=0

  if [[ "$#" -eq 0 ]]; then
    INSTALL_VIM=1
    INSTALL_NVIM=1
    return 0
  fi

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --all)
        INSTALL_VIM=1
        INSTALL_NVIM=1
        INSTALL_IDEAVIM=1
        ;;
      --vim)
        INSTALL_VIM=1
        ;;
      --nvim)
        INSTALL_NVIM=1
        ;;
      --ideavim|--idea-vim)
        INSTALL_IDEAVIM=1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        usage >&2
        die "Unknown option: $1"
        ;;
    esac
    shift
  done
}

run_installer() {
  local target="$1"
  local script="$INSTALL_DIR/$target/install.sh"

  [[ -x "$script" ]] || die "Installer not found or not executable: $script"
  "$script"
}

main() {
  parse_targets "$@"

  log "Installing vim-config from $REPO_URL"
  log "Target checkout: $INSTALL_DIR"

  ensure_command git git "Would you like to install git now?"
  if [[ "$INSTALL_NVIM" -eq 1 ]]; then
    ensure_npm
  fi

  install_or_update_repo

  if [[ "$INSTALL_VIM" -eq 1 ]]; then
    run_installer vim
  fi

  if [[ "$INSTALL_NVIM" -eq 1 ]]; then
    run_installer nvim
  fi

  if [[ "$INSTALL_IDEAVIM" -eq 1 ]]; then
    run_installer ideavim
  fi

  log "Installation complete."
}

main "$@"
