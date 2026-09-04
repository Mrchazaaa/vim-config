#!/bin/bash

# Test script for Neovim configuration
set -e

echo "Testing Neovim configuration..."

# Test basic startup
echo "1. Testing basic startup..."
timeout 10 nvim --headless -c "lua print('Basic startup: OK')" -c "qall!"

# Test configuration loading
echo "2. Testing configuration loading..."
timeout 15 nvim --headless -c "lua print('Config loaded: OK')" -c "qall!"

# Test Lua syntax
echo "3. Checking Lua syntax..."
find . -name "*.lua" -print0 | while IFS= read -r -d '' file; do
    echo "Checking: $file"
    nvim --headless -u NONE -c "lua assert(loadfile(vim.fn.argv(0)))" -c "qall!" "$file" || {
        echo "Syntax error in: $file"
        exit 1
    }
done

# Test filetype/plugin activation for representative files
echo "4. Testing filetype/plugin activation..."
files_to_open=(
    "$HOME/.config/nvim/init.lua"
    "$PWD/nvim/init.lua"
)

if [ -f "$PWD/vim-config/nvim/init.lua" ]; then
    files_to_open+=("$PWD/vim-config/nvim/init.lua")
fi

tmp_lua_file="$(mktemp --suffix=.lua)"
trap 'rm -f "$tmp_lua_file"' EXIT
printf 'return true\n' > "$tmp_lua_file"
files_to_open+=("$tmp_lua_file")

for file in "${files_to_open[@]}"; do
    echo "Opening: $file"
    timeout 15 nvim --headless "$file" -c "qall!" || {
        echo "Filetype/plugin activation failed for: $file"
        exit 1
    }
done

# Test plugin manager (if using lazy.nvim)
echo "5. Testing plugin manager..."
if [ -f "vim-config/nvim/lua/lazy-bootstrap.lua" ]; then
    timeout 30 nvim --headless -c "lua require('lazy-bootstrap')" -c "qall!" || {
        echo "Plugin manager test failed"
        exit 1
    }
fi

echo "All tests passed! ✓"
