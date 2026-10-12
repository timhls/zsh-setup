# zsh Setup Repository

Complete zsh setup guide and automation scripts for macOS and Ubuntu WSL2. Optimized for developers and DevSecOps engineers.

## 📁 Files in This Repository

### Documentation
- **`SETUPGUIDE.md`** - Comprehensive guide covering:
  - zsh vs bash differences
  - Installation for macOS and Ubuntu
  - Configuration fundamentals
  - Completion system overview
  - Productivity tools (z, fzf, etc.)
  - Plugin ecosystem
  - History management
  - Platform-specific notes
  - Troubleshooting

### Installation Scripts
- **`install-macos.sh`** - Automated setup for macOS
  - Installs zsh via Homebrew (latest version)
  - Installs essential plugins and tools
  - Optionally installs Powerline fonts
  - Creates basic `.zshrc` if needed
  
- **`install-ubuntu-wsl.sh`** - Automated setup for Ubuntu/WSL2
  - Installs zsh via apt
  - Installs essential plugins and tools
  - Handles plugin installation from both repos and GitHub
  - Creates basic `.zshrc` if needed

### Configuration
- **`zshrc-template`** - Production-ready `.zshrc` template
  - History management configuration
  - Completion system setup
  - Directory navigation
  - Plugin loading (cross-platform)
  - Useful aliases for development and DevOps
  - Function utilities
  - Platform-specific optimizations

## 🚀 Quick Start

### macOS (M-series or Intel)

```bash
# Clone or download this repo
cd zsh-setup

# Run the installation script
bash install-macos.sh

# Restart terminal or run:
source ~/.zshrc
```

### Ubuntu / Windows 11 WSL2

```bash
# Clone or download this repo
cd zsh-setup

# Run the installation script
bash install-ubuntu-wsl.sh

# Restart terminal or run:
source ~/.zshrc
```

## 📋 What Gets Installed

### Essential Plugins
- **zsh-syntax-highlighting** - Syntax coloring while typing (red for invalid, green for valid)
- **zsh-autosuggestions** - Smart command suggestions from history
- **zsh-history-substring-search** - Better history search (prefix matching with Up/Down)
- **zsh-completions** - Extended completion functions

### Productivity Tools
- **z** - Jump to frecent (frequent + recent) directories
- **fzf** - Fuzzy finder for files, commands, and history (Ctrl+R, Ctrl+T, Alt+C)

### Integration
- Git integration (if available)
- Docker completion (if installed)
- Kubernetes completion (if kubectl installed)

## 🔧 Configuration

### Using the Template
The `zshrc-template` is ready to use as `.zshrc`:

```bash
# Copy template to home directory
cp zshrc-template ~/.zshrc

# Reload
source ~/.zshrc
```

### Customization
Edit `~/.zshrc` to customize:
- Prompt style
- Aliases
- Plugin loading
- Environment variables

Key sections to modify:
```zsh
# Change prompt
PROMPT='...'

# Add aliases
alias myalias='command'

# Adjust history size
HISTSIZE=100000

# Enable/disable plugins
```

## 📚 Learning Resources

For detailed information, see `SETUPGUIDE.md` which covers:
- Completion system explained
- History management techniques
- Plugin management options
- Terminal customization
- Platform-specific considerations

## 🎯 DevSecOps Specific

### Installed by Default
- All standard Kubernetes (kubectl) completions
- Docker integration
- Git integration for DevOps workflows

### Easy to Add
```bash
# AWS CLI completion
echo 'eval "$(aws_completer)"' >> ~/.zshrc

# Terraform completion
terraform -install-autocomplete

# Helm completion
helm completion zsh > ~/.helm-completion
echo 'source ~/.helm-completion' >> ~/.zshrc
```

### History Benefits
```bash
# Search history by command prefix
docker<Up>  # Cycles through docker commands

# View all history
history

# Search for specific pattern
grep "terraform" ~/.zsh_history
```

## ⚡ Productivity Tips

### Navigation
```bash
# Jump to frequently used directory (z plugin)
z myproject

# Go to any directory in current tree
cd -             # Go back

# List directory history
d
```

### Command Search
```bash
Ctrl+R  # Fuzzy search through history (fzf)
Ctrl+T  # Fuzzy find files in current directory
Alt+C   # Fuzzy find and cd into directory
```

### Git Operations
```bash
gs      # git status
gc      # git commit
gp      # git push
gl      # git log (nicely formatted)
gla     # git log with all branches
```

## 🛠️ Troubleshooting

### Scripts Won't Run
```bash
# Make scripts executable
chmod +x install-*.sh

# Run with bash explicitly
bash install-macos.sh
```

### Delete Key Doesn't Work
Already configured in template. If issues persist, add to `.zshrc`:
```zsh
bindkey "^[[3~" delete-char
```

### Plugins Not Loading
Check that files exist in expected locations (see template for paths).

### Slow Startup
```bash
# Profile startup time
time zsh -i -c exit

# Check what's loading
zsh -x -i -c exit 2>&1 | head -30
```

## 📖 Documentation Structure

1. **SETUPGUIDE.md** - Start here for comprehensive reference
2. **install-*.sh** - Automated setup for your platform
3. **zshrc-template** - Copy to `~/.zshrc` and customize
4. **This README** - Quick reference and troubleshooting

## 🔍 Validation Checklist

After installation, verify:
- [ ] `zsh --version` shows version 5.8+
- [ ] `echo $SHELL` shows zsh path
- [ ] `Ctrl+R` opens fuzzy history search
- [ ] `Ctrl+T` opens fuzzy file finder
- [ ] Type directory name without `cd` and it navigates there
- [ ] `z projectname` jumps to frequently used directory
- [ ] `git<Tab>` shows git command completions
- [ ] Syntax highlighting shows commands in green
- [ ] Up arrow history search works with prefix typing

## 🚧 Future Enhancements

The setup is designed to be extended with:
- Custom themes (spaceship, agnoster, powerlevel10k)
- Additional plugin managers
- Organization-specific aliases and functions
- Integration with other DevOps tools

## 📝 Notes

- All scripts are idempotent - safe to run multiple times
- Existing `.zshrc` is never overwritten automatically
- Plugins are installed from official sources (apt, Homebrew, or GitHub)
- Cross-platform compatible template configuration
- Performance optimized for fast startup times

## 🤝 Customization Guide

After initial setup, personalize your shell:

1. **Theme**: Add to `.zshrc`:
   ```zsh
   # Download theme
   git clone https://github.com/spaceship-prompt/spaceship-prompt.git ~/.zsh-custom/themes/spaceship
   
   # Enable
   ZSH_THEME='spaceship'
   ```

2. **Add DevOps Tools**:
   ```zsh
   # Terraform completion
   terraform -install-autocomplete
   
   # AWS CLI
   complete -C /usr/local/bin/aws_completer aws
   ```

3. **Custom Functions**: Add to `.zshrc`:
   ```zsh
   # SSH with fuzzy selection
   sssh() {
       ssh $(grep '^Host' ~/.ssh/config | sed 's/^Host //' | fzf)
   }
   ```

---

**Created from research and best practices** for optimal developer and DevSecOps workflows.

For detailed configuration options and advanced usage, see `SETUPGUIDE.md`.

## 🤖 agentctl (AI coding-agent MCP manager)

`bin/agentctl` manages global MCP-server enablement across the four first-class
AI coding agents (claude, codex, opencode, omp) from the `~/apm.yml` manifest.

```bash
agentctl status                        # enablement matrix across all agents
agentctl profile lean                  # default: zai trio + zai-vision
agentctl profile azure|security|data|docs|github|comms|gateway|all
agentctl mcp on|off <name> [--agent a,b]
agentctl skills                        # resync ~/.agents/skills -> opencode
agentctl fixhooks                      # repair apm gh-cli hook paths in claude configs
```

Symlinked onto PATH via `~/.local/bin/agentctl`. The global agent-instructions
file `~/AGENTS.md` documents the full SSOT architecture (skills, MCP, secrets,
model routing); deep-dive docs live in
`~/Repos/wtr-pro-homelab/docs/setup/workstation-agent-config.md`.
