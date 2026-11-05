#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=../scripts/lib/install-helpers.sh
source "$REPO_ROOT/scripts/lib/install-helpers.sh"

NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
NVIM_INIT="${NVIM_INIT:-$NVIM_CONFIG_DIR/init.vim}"

main() {
  local nvim_content

  ensure_command nvim neovim "Would you like to install Neovim now?"
  ensure_npm

  nvim_content="lua dofile('$REPO_ROOT/nvim/init.lua')"

  write_file_if_changed "$NVIM_INIT" "$nvim_content"
  log "Neovim will load $NVIM_INIT."
}

main "$@"
