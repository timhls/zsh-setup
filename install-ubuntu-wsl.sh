#!/bin/bash
# Ubuntu/WSL2 zsh Setup Script
# For: Ubuntu 20.04+ on Windows 11 WSL2
# Usage: bash install-ubuntu-wsl.sh

set -e

echo "🐧 Ubuntu/WSL2 zsh Setup Script"
echo "================================"
echo ""

# Check if running on Linux (not checking specifically for WSL, works on any Linux)
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ This script is for Ubuntu/Linux only"
    exit 1
fi

# Check if we have apt
if ! command -v apt &> /dev/null; then
    echo "❌ apt not found. This script requires apt (Ubuntu/Debian-based)"
    exit 1
fi

echo "✅ Running on Ubuntu/Linux"
echo ""

# Step 1: Update package lists
echo "📦 Updating package lists..."
sudo apt update
echo "   ✅ Package lists updated"

# Step 2: Install zsh
echo ""
echo "📦 Installing zsh..."
if command -v zsh &> /dev/null; then
    echo "   zsh already installed: $(zsh --version)"
else
    sudo apt install -y zsh
    echo "   ✅ zsh installed"
fi

# Step 3: Change default shell
echo ""
echo "🐚 Current shell: $SHELL"
read -p "Change default shell to zsh? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s $(which zsh)
    echo "✅ Default shell changed to $(which zsh)"
    echo "   (Restart terminal to see effect)"
fi

# Step 4: Install essential packages and plugins
echo ""
echo "📦 Installing essential packages..."

# git-core (if not already installed)
if command -v git &> /dev/null; then
    echo "   git already installed"
else
    sudo apt install -y git
    echo "   ✅ git installed"
fi

# zsh-syntax-highlighting
if [ -d /usr/share/zsh-syntax-highlighting ]; then
    echo "   zsh-syntax-highlighting already installed"
else
    sudo apt install -y zsh-syntax-highlighting
    echo "   ✅ zsh-syntax-highlighting installed"
fi

# zsh-autosuggestions
if [ -d /usr/share/zsh-autosuggestions ]; then
    echo "   zsh-autosuggestions already installed"
else
    sudo apt install -y zsh-autosuggestions
    echo "   ✅ zsh-autosuggestions installed"
fi

# zsh-history-substring-search
if apt list --installed 2>/dev/null | grep -q zsh-history-substring-search; then
    echo "   zsh-history-substring-search already installed"
else
    sudo apt install -y zsh-history-substring-search 2>/dev/null || echo "   (Not in standard repos - will use manual)"
fi

# z (frecent navigation)
if command -v z &> /dev/null; then
    echo "   z already installed"
else
    echo "   Installing z..."
    git clone https://github.com/rupa/z.git ~/.z-repo
    echo "   ✅ z installed"
fi

# fzf (fuzzy finder)
if command -v fzf &> /dev/null; then
    echo "   fzf already installed"
else
    echo "   Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish 2>/dev/null || true
    echo "   ✅ fzf installed"
fi

# curl (often needed)
if command -v curl &> /dev/null; then
    echo "   curl already installed"
else
    sudo apt install -y curl
    echo "   ✅ curl installed"
fi

# Step 5: Manual install of zsh-history-substring-search if not in repos
echo ""
if ! apt list --installed 2>/dev/null | grep -q zsh-history-substring-search; then
    echo "📦 Installing zsh-history-substring-search from GitHub..."
    mkdir -p ~/.zsh-plugins
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh-plugins/zsh-history-substring-search
    echo "   ✅ zsh-history-substring-search installed"
fi

# Step 6: Create .zshrc if it doesn't exist
echo ""
TEMPLATE="$(dirname "$0")/zshrc-template"
if [ ! -f ~/.zshrc ]; then
    echo "📝 Creating ~/.zshrc..."
    if [ -f "$TEMPLATE" ]; then
        cp "$TEMPLATE" ~/.zshrc
        echo "   ✅ Created from template"
    else
        echo "   ⚠️  Template not found at $TEMPLATE"
        echo "   Please copy zshrc-template to ~/.zshrc manually"
    fi
else
    echo "   ~/.zshrc already exists (not overwriting)"
fi

# Step 7: Summary
echo ""
echo "================================"
echo "✅ Setup Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Customize ~/.zshrc with your preferences"
echo ""
echo "Optional enhancements:"
echo "- Install theme: git clone https://github.com/spaceship-prompt/spaceship-prompt.git ~/.zsh-custom/themes/spaceship"
echo "- Then add to .zshrc: ZSH_THEME='spaceship'"
echo ""
echo "Verify fzf integration:"
echo "- Press Ctrl+R to test history search"
echo "- Press Ctrl+T to test file finder"
echo ""
echo "For DevSecOps tools completion:"
echo "- kubectl: kubectl completion zsh > ~/.kubectl-completion && echo 'source ~/.kubectl-completion' >> ~/.zshrc"
echo "- aws: pip install awscli-local && echo 'eval \"\$(aws_completer)\"' >> ~/.zshrc"
echo ""
