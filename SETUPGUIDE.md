# Comprehensive zsh Setup Guide for Developers & DevSecOps Engineers

**Target Systems**: macOS (M-series) & Ubuntu (WSL2 on Windows 11)  
**Use Case**: Development & DevSecOps workflows

---

## Table of Contents

1. [Why zsh? (vs Bash)](#why-zsh)
2. [Installation](#installation)
3. [Configuration Fundamentals](#configuration-fundamentals)
4. [Completion System](#completion-system)
5. [Productivity Tools](#productivity-tools)
6. [Terminal Customization](#terminal-customization)
7. [Plugins & Extensions](#plugins--extensions)
8. [History Management](#history-management)
9. [Platform-Specific Notes](#platform-specific-notes)
10. [Quick Reference](#quick-reference)

---

## Why zsh?

### Key Advantages Over Bash

**1. Interactive Features**
- **Advanced completion system** - Context-aware, precise, user-configurable
- **Better autocompletion** - Zsh is often more accurate than bash
- **Automatic directory navigation** - Type directory name, no `cd` needed
- **Spell correction** - Automatically corrects typos in commands

**2. Developer-Friendly**
- **Powerful glob patterns** - File matching with qualifiers (size, date, type)
- **Glob qualifiers** - Match files by metadata: `foo*(.)` (regular files), `foo*(*.)` (executables), `foo*(om)` (sorted by modification time)
- **Modern shell features** - Designed with more recent thinking than bash
- **Plugin ecosystem** - Hundreds of community-created tools and themes

**3. Real-World Benefits for DevSecOps**
- Faster command-line navigation through projects
- Better history search and filtering
- Integrated git information in prompt
- Syntax highlighting while typing (catches errors before execution)
- Environment customization without bloat (unlike older setups)

### Syntax Compatibility
- Most bash scripts still work in zsh (scripts use shebangs `#!/bin/bash`, not affected)
- Interactive configuration differs, but basics are similar
- Excellent for developers familiar with bash, lower learning curve

---

## Installation

### macOS (Preferred: Use Homebrew for Latest Version)

```bash
# Install via Homebrew (latest version with all features)
brew install zsh

# Add to allowed shells (required for chsh)
echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells

# Change default shell
chsh -s /opt/homebrew/bin/zsh

# Or change just the current user
chsh -s /usr/local/bin/zsh $USER
```

**Note:** macOS ships with zsh, but it's often outdated. Homebrew provides latest features and bug fixes.

### Ubuntu / WSL2

```bash
# Update package lists
sudo apt update

# Install zsh
sudo apt install -y zsh

# Change default shell
chsh -s $(which zsh)

# Verify installation
zsh --version
```

After installation on either platform, **restart your terminal** to use the new shell.

---

## Configuration Fundamentals

All zsh configuration lives in `~/.zshrc` (interactive shells) and `~/.zprofile` (login shells).

### Basic Setup

```bash
# View/edit your zshrc
open ~/.zshrc  # macOS
# or
nano ~/.zshrc  # macOS/Linux

# After making changes, reload immediately:
source ~/.zshrc
```

### Key Configuration Areas

#### 1. History Management

```zsh
# Save command history to file
HISTFILE=~/.zsh_history
HISTSIZE=50000              # In-memory history size
SAVEHIST=50000              # Saved history size

# Advanced history options
setopt EXTENDED_HISTORY     # Save timestamps
setopt SHARE_HISTORY        # Share history between sessions
setopt APPEND_HISTORY       # Append, don't replace
setopt HIST_IGNORE_DUPS     # Don't save duplicate commands
setopt HIST_FIND_NO_DUPS    # Skip duplicates when searching
setopt HIST_IGNORE_SPACE    # Don't save commands starting with space
```

#### 2. Autocompletion

```zsh
# Initialize completion system
# -i: silently skip insecure directories (Homebrew's /opt/homebrew/share is
# group-writable mode 775; without -i, compinit prompts on every session)
autoload -Uz compinit
compinit -i

# Load list completion module (enables selection menu)
zmodload zsh/complist

# Completion options
setopt MENU_COMPLETE              # Auto-complete on first TAB
setopt AUTO_LIST                  # Show list on ambiguous completion
setopt COMPLETE_IN_WORD           # Complete inside words
setopt ALWAYS_TO_END              # Move cursor to end when completing

# Completion styling
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|=**'  # Case-insensitive + partial word matching
```

#### 3. Directory Navigation

```zsh
# Auto-cd: type directory name to enter it (no 'cd' needed)
setopt AUTO_CD

# Automatically pushd when changing directories
setopt AUTO_PUSHD

# Don't push duplicates
setopt PUSHD_IGNORE_DUPS

# Track directory stack
DIRSTACKSIZE=20
```

#### 4. Typo Correction

```zsh
# Enable command correction
setopt CORRECT

# Enable argument correction (be careful - can be aggressive)
# setopt CORRECT_ALL
```

#### 5. Key Bindings & Delete Key

```zsh
# Fix Delete key issue (sends tilde instead of deleting)
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" delete-word
bindkey "^[[3;2~" delete-word

# History search (bind up/down keys to search by prefix)
bindkey "$terminfo[kcuu1]" history-beginning-search-backward
bindkey "$terminfo[kcud1]" history-beginning-search-forward

# Emacs mode (default for most users)
bindkey -e

# Or Vi mode (if you prefer)
# bindkey -v
```

#### 6. Interactive Comments

```zsh
# Enable # to start comments on command line (disabled by default in zsh)
setopt interactive_comments
```

---

## Completion System

### Architecture

Zsh completion is **context-aware** and **highly configurable**:

- **compinit**: Initializes the completion system
- **complist**: Provides the completion menu interface
- **compadd**: Adds completions programmatically
- **completion functions**: Underscore-prefixed functions (_git, _docker, etc.)

### How It Works

1. **Context detection** - Where are you completing? (command arg, option, value?)
2. **Matcher selection** - What pattern matching to use?
3. **Tag generation** - What type of completions? (files, directories, commands)
4. **Completion retrieval** - Get matching items
5. **Display** - Show results with optional menu

### Key Completion Features

**Partial word matching**
```zsh
# Type "lst" and press TAB → gets "listen" 
# Works from start or middle of word
```

**Option completion**
```zsh
# git commit -<TAB>
# Shows all git commit options with descriptions
```

**Argument completion**
```zsh
# docker run --<TAB>
# Shows context-aware Docker options
```

**File completion with glob qualifiers**
```zsh
# *.txt<TAB> - completes with special behaviors
```

### Enabling Bash Completions

If you need bash-style completions:
```zsh
autoload -Uz bashcompinit && bashcompinit
```

### Caching for Performance

Zsh creates `.zcompdump` file to cache completion data. Regenerate if issues occur:
```zsh
rm ~/.zcompdump && compinit
```

---

## Productivity Tools

### 1. **z** (frecent folder navigation)

**What it does**: Navigate to frequently-used directories by partial name, sorted by "frecency" (frequency + recency).

**macOS Installation**
```bash
brew install z
```

**Ubuntu/WSL Installation**
```bash
# Method 1: Via git
git clone https://github.com/rupa/z.git ~/z-folder
echo '. ~/z-folder/z.sh' >> ~/.zshrc

# Method 2: Via package (if available)
sudo apt install z
```

**Usage**
```bash
# After using directories, they're tracked:
cd ~/Projects/my-app
cd ~/Documents/work

# Later, jump back quickly:
z my-app          # Go to ~/Projects/my-app
z work            # Go to ~/Documents/work
z doc              # Partial match

# View history of tracked directories:
z -l               # List with scores
z -r               # Order by recency instead of frecency
```

**For DevSecOps**: Game-changer for jumping between infrastructure repos, log directories, and deployment folders.

### 2. **fzf** (fuzzy finder)

**What it does**: Interactive fuzzy search for files, commands, history - with real-time filtering.

**Installation**
```bash
# macOS
brew install fzf
$(brew --prefix)/opt/fzf/install

# Ubuntu/WSL
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**Key Features**
- **Ctrl+R** - Fuzzy search through command history (much better than bash)
- **Ctrl+T** - Fuzzy find files in current directory
- **Alt+C** - Fuzzy find directory and cd into it

**Usage Examples**
```bash
# Search history with live preview
Ctrl+R  # Type "docker" → see all docker commands

# Find files
Ctrl+T  # Type ".md" → see all markdown files

# Grep + fzf integration
cat ~/.zsh_history | fzf
```

### 3. **Oh My Zsh** vs Lightweight Alternative

#### Oh My Zsh (Traditional)
✅ Pros: Hundreds of plugins, themes, easy setup  
❌ Cons: Bloated (~2-5 sec startup), includes things you don't use

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### Lightweight Alternative: Manual Plugin Management
✅ Pros: Fast startup, control what loads  
❌ Cons: More manual configuration

**Recommended approach for DevSecOps**: Use minimal configuration + selective plugins.

---

## Terminal Customization

### Terminal Application Recommendations

**macOS**
- **iTerm2** (recommended) - Better than Terminal.app
  - Pane splitting, color schemes, paste history, hotkeys
  - Download: https://www.iterm2.com/

**Windows WSL2**
- **Windows Terminal** (built-in) - Modern, good WSL integration
- **iTerm2 equivalent**: Not available, use Windows Terminal
- Alternatively: VSCode integrated terminal works well

### Themes & Prompts

#### Quick Theme Setup (Oh My Zsh)

```zsh
# In ~/.zshrc, find ZSH_THEME line:
ZSH_THEME="agnoster"  # Modern theme with git info

# Popular themes:
# - agnoster         - Powerline-style, git branch + status
# - powerlevel10k    - Fast, highly customizable
# - spaceship        - Shows node/ruby/python versions
# - pure             - Minimal, clean
```

**Set random theme to explore**
```zsh
ZSH_THEME="random"
# Each new terminal gets different theme
```

#### Lightweight Prompt (Without Oh My Zsh)

```zsh
# Simple prompt showing git branch if in repo
git_branch() {
  git branch 2>/dev/null | sed -n '/^\*/s/^\* //p'
}

# Minimal prompt
PROMPT='%F{cyan}%~%f %F{green}$(git_branch)%f %F{blue}›%f '
```

#### Powerline Fonts (Required for Some Themes)

Some themes use special Unicode characters. Install patched fonts:

```bash
# macOS (fonts are now in the main homebrew/cask repo, no tap needed)
brew install --cask font-fira-code
brew install --cask font-inconsolata-for-powerline

# Ubuntu
sudo apt install fonts-inconsolata fonts-font-awesome

# Then set font in iTerm2: Preferences → Profiles → Text → Font
```

### Color Schemes

**iTerm2 Colors**
1. Open: Preferences → Profiles → Colors
2. Download color scheme from [iTerm2-Color-Schemes](https://iterm2colorschemes.com/)
3. Import and apply

**Popular schemes**: Dracula, Solarized, One Dark, Nord, Gruvbox

---

## Plugins & Extensions

### Essential Plugins

#### 1. **zsh-syntax-highlighting**
Colorizes commands as you type - red for invalid, green for valid.

```bash
# macOS
brew install zsh-syntax-highlighting
echo 'source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

# Ubuntu
sudo apt install zsh-syntax-highlighting
echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
```

#### 2. **zsh-autosuggestions**
Suggests previous commands as you type - press right arrow to accept.

```bash
# macOS
brew install zsh-autosuggestions
echo 'source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc

# Ubuntu
sudo apt install zsh-autosuggestions
echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
```

**Note:** zsh-syntax-highlighting must load BEFORE zsh-autosuggestions

#### 3. **zsh-history-substring-search**
Type command prefix, press Up/Down to cycle through matching history.

```bash
# macOS
brew install zsh-history-substring-search

# Add to ~/.zshrc AFTER syntax highlighting:
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Bind keys:
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
```

#### 4. **zsh-completions**
Extra completion functions beyond zsh defaults.

```bash
# macOS
brew install zsh-completions

# Ubuntu - manual install
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/completions
```

Then add to ~/.zshrc:
```zsh
fpath=(~/.zsh/completions $fpath)
```

### DevSecOps-Specific Plugins

**kubectl completion**
```bash
kubectl completion zsh > ~/.kubectl-completion
echo 'source ~/.kubectl-completion' >> ~/.zshrc
```

**Docker completion**
```bash
# Usually included in docker package, ensure it's loaded
```

**aws-cli completion**
```bash
echo 'autoload -Uz bashcompinit && bashcompinit' >> ~/.zshrc
echo 'complete -C aws_completer aws' >> ~/.zshrc
```

### Plugin Managers (Optional)

**Lightweight: Antibody**
```bash
brew install antibody

# Create ~/.zsh_plugins
# Add to ~/.zshrc:
source <(antibody init)
antibody load ~/.zsh_plugins
```

---

## History Management

### Configuration

```zsh
# ~/.zshrc
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Advanced options
setopt EXTENDED_HISTORY         # Timestamps
setopt SHARE_HISTORY            # Immediate sharing between sessions
setopt APPEND_HISTORY           # Append mode
setopt HIST_IGNORE_DUPS         # No duplicates
setopt HIST_FIND_NO_DUPS        # Skip dups in search
setopt HIST_IGNORE_SPACE        # Don't save lines starting with space
setopt HIST_REDUCE_BLANKS       # Remove extra blanks
```

### History Search Methods

**1. Ctrl+R - Reverse Incremental Search**
```bash
Ctrl+R  # Type "docker" → finds first match
Ctrl+R  # Press again → next match
Ctrl+S  # Search forward (less common)
```

**2. History Substring Search (with plugin)**
```bash
# Type start of command, then press Up/Down:
docker<Up>      # Cycles through docker commands
```

**3. History Expansion**
```bash
!!              # Last command
!docker         # Last command starting with "docker"
!?status        # Last command containing "status"
$_              # Last argument from previous command
!^              # First argument from previous command
```

**4. Interactive fzf Search** (recommended)
```bash
Ctrl+R  # With fzf installed
# Shows all commands with live filtering
```

### Filtering History

View specific history:
```bash
# Show all commands with timestamps
history

# Search for specific pattern
grep "docker" ~/.zsh_history

# Show last 20 commands
history -20

# Show commands from specific date (with EXTENDED_HISTORY)
fc -l -m "*" 0
```

---

## Platform-Specific Notes

### macOS (M-Series)

**Considerations**
- Homebrew default paths: `/opt/homebrew/bin` (Apple Silicon) vs `/usr/local/bin` (Intel)
- Some tools require Rosetta 2 translation
- Default zsh is outdated (~5.7 vs current ~5.9)

**Recommended Setup**
```bash
# Install via Homebrew
brew install zsh

# Verify correct path
which zsh  # Should be /opt/homebrew/bin/zsh

# Add to shells
echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells

# Change default shell
chsh -s /opt/homebrew/bin/zsh
```

**PATH Configuration**
```zsh
# ~/.zshrc - Ensure Homebrew paths come first
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
```

### Ubuntu / WSL2

**Considerations**
- WSL2 uses genuine Linux kernel (much faster than WSL1)
- File system performance varies (Windows drive slower than Linux `/home`)
- Interop with Windows `.exe` tools available

**WSL2 Optimization**
```bash
# Use Linux filesystem for best performance
# Keep projects in /home/user, not /mnt/c/Users/...

# .zshrc optimization for WSL2
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    # WSL2-specific settings
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi
```

**Windows Terminal Integration**
```json
// Add to Windows Terminal settings.json (Profiles)
{
  "name": "Ubuntu (zsh)",
  "commandline": "wsl.exe -d Ubuntu -u username -- zsh",
  "startingDirectory": "/home/username"
}
```

---

## Quick Reference

### Most-Used Commands

| Command | Purpose |
|---------|---------|
| `z <dir>` | Jump to frecent directory |
| `cd ..` | Up one directory |
| `projects` | Auto-cd to projects folder |
| `Ctrl+R` | Search command history (fuzzy with fzf) |
| `Ctrl+T` | Fuzzy find files |
| `Alt+C` | Fuzzy find directories |
| `!!` | Repeat last command |
| `!docker` | Last command starting with "docker" |
| `$_` | Last argument of previous command |

### Essential Key Bindings

```zsh
# In ~/.zshrc (most already set by defaults)
bindkey -e                              # Emacs mode
bindkey "$terminfo[kcuu1]" up-line-or-search   # Up arrow
bindkey "$terminfo[kcud1]" down-line-or-search # Down arrow
bindkey "^[[3~" delete-char            # Delete key
```

### Common Aliases (Examples)

```zsh
# Add to ~/.zshrc
alias ll='ls -lah'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias k='kubectl'
alias d='docker'
```

### Checking Startup Time

```bash
time zsh -i -c exit

# Or with profiling:
zsh -x -i -c exit 2>&1 | head -20
```

---

## Common Issues & Solutions

### Slow Startup
- **Cause**: Too many plugins or unoptimized Oh My Zsh
- **Solution**: Use lightweight setup, check with `time zsh -i -c exit`

### Delete Key Sends ~
- **Solution**: Already covered in config - ensure delete key binding is set

### Completion Not Working
```bash
# Regenerate completion dump
rm ~/.zcompdump
compinit -i
```

### Git Completion Missing
```bash
# Ensure git completion is loaded
fpath=(~/.git/completion $fpath)
```

### zsh-syntax-highlighting Not Loading
```bash
# Must load BEFORE zsh-autosuggestions
# Check ~/.zshrc ordering
```

---

## Resources

- **Official Docs**: https://zsh.sourceforge.io/
- **Completion System**: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- **Oh My Zsh**: https://ohmyz.sh/
- **zsh-users plugins**: https://github.com/zsh-users
- **fzf**: https://github.com/junegunn/fzf
- **z**: https://github.com/rupa/z
- **Spaceship Prompt**: https://spaceship-prompt.sh/
- **Powerline Fonts**: https://github.com/powerline/fonts

---

## Next Steps

1. **Installation**: Install zsh on macOS and WSL2
2. **Basic Config**: Copy core settings from "Configuration Fundamentals"
3. **Plugins**: Install essential plugins (syntax-highlighting, autosuggestions, history-search)
4. **Productivity Tools**: Install z and fzf
5. **Customization**: Choose theme and colors that match your workflow
6. **Optimization**: Profile startup time and remove unnecessary load

This guide will serve as reference for creating setup scripts and deployment configurations.
