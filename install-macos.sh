#!/bin/bash
# macOS zsh Setup Script
# For: MacBook Air M4 (and other Apple Silicon/Intel Macs)
# Usage: bash install-macos.sh

set -e

echo "🍎 macOS zsh Setup Script"
echo "========================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is for macOS only"
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Install from https://brew.sh"
    exit 1
fi

echo "✅ Homebrew found"
echo ""

# Step 1: Install zsh via Homebrew
echo "📦 Installing zsh via Homebrew..."
if brew list zsh &>/dev/null; then
    echo "   zsh already installed"
else
    brew install zsh
    echo "   ✅ zsh installed"
fi

# Step 2: Add zsh to allowed shells
HOMEBREW_ZSH=$(brew --prefix)/bin/zsh
echo ""
echo "🔐 Adding $HOMEBREW_ZSH to /etc/shells..."
if grep -q "$HOMEBREW_ZSH" /etc/shells; then
    echo "   Already in /etc/shells"
else
    echo "$HOMEBREW_ZSH" | sudo tee -a /etc/shells > /dev/null
    echo "   ✅ Added to /etc/shells"
fi

# Step 3: Change default shell (optional - ask user)
echo ""
echo "🐚 Current shell: $SHELL"
read -p "Change default shell to zsh? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s "$HOMEBREW_ZSH"
    echo "✅ Default shell changed to $HOMEBREW_ZSH"
    echo "   (Restart terminal to see effect)"
fi

# Step 4: Install plugins and tools
echo ""
echo "📦 Installing essential plugins and tools..."

# zsh-syntax-highlighting
if brew list zsh-syntax-highlighting &>/dev/null; then
    echo "   zsh-syntax-highlighting already installed"
else
    brew install zsh-syntax-highlighting
    echo "   ✅ zsh-syntax-highlighting installed"
fi

# zsh-autosuggestions
if brew list zsh-autosuggestions &>/dev/null; then
    echo "   zsh-autosuggestions already installed"
else
    brew install zsh-autosuggestions
    echo "   ✅ zsh-autosuggestions installed"
fi

# zsh-history-substring-search
if brew list zsh-history-substring-search &>/dev/null; then
    echo "   zsh-history-substring-search already installed"
else
    brew install zsh-history-substring-search
    echo "   ✅ zsh-history-substring-search installed"
fi

# zsh-completions
if brew list zsh-completions &>/dev/null; then
    echo "   zsh-completions already installed"
else
    brew install zsh-completions
    echo "   ✅ zsh-completions installed"
fi

# z (frecent navigation)
if brew list z &>/dev/null; then
    echo "   z already installed"
else
    brew install z
    echo "   ✅ z installed"
fi

# fzf (fuzzy finder)
if brew list fzf &>/dev/null; then
    echo "   fzf already installed"
else
    brew install fzf
    echo "   ✅ fzf installed"
    # Shell integration (key bindings + completion) is handled by
    # zshrc-template via `source <(fzf --zsh)` — no legacy installer needed.
fi

# Step 5: Install fonts (optional for themed prompts)
echo ""
read -p "Install Powerline fonts for enhanced prompts? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing fonts..."
    if brew list font-fira-code &>/dev/null; then
        echo "   font-fira-code already installed"
    else
        brew install --cask font-fira-code
        echo "   ✅ font-fira-code installed"
    fi
    
    if brew list font-inconsolata-for-powerline &>/dev/null; then
        echo "   font-inconsolata-for-powerline already installed"
    else
        brew install --cask font-inconsolata-for-powerline
        echo "   ✅ font-inconsolata-for-powerline installed"
    fi
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
echo "========================="
echo "✅ Setup Complete!"
echo "========================="
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Customize ~/.zshrc with your preferences"
echo "3. Install theme if desired (e.g., spaceship, agnoster)"
echo ""
echo "Optional enhancements:"
echo "- Theme: brew install spaceship"
echo "- Or use: ZSH_THEME='agnoster' in ~/.zshrc"
echo ""
echo "Verify fzf integration:"
echo "- Press Ctrl+R to test history search"
echo "- Press Ctrl+T to test file finder"
echo ""
