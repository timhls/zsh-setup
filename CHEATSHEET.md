# zsh + kitty Cheat Sheet

For: MacBook Air M4, kitty 0.48, zsh 5.9 (emacs keymap), Homebrew plugins.

> `kitty_mod` = **Ctrl+Shift** (kitty default). All defaults below apply unless
> you've rebound them in `~/.config/kitty/kitty.conf` (you only customized
> font-size keys).

---

## 1. Daily-driver zsh shortcuts (emacs mode)

Your `~/.zshrc` line 106 sets `bindkey -e` — these are the bindings that matter.

### Line editing

| Key            | Action                                    |
|----------------|-------------------------------------------|
| `Ctrl+A`       | Move to start of line                     |
| `Ctrl+E`       | Move to end of line                       |
| `Ctrl+B` / `F` | Move back / forward one char              |
| `Esc` then `B` / `F` | Move back / forward one word        |
| `Ctrl+D`       | Delete char under cursor (or list completion) |
| `Ctrl+H`       | Delete char before cursor (backspace)     |
| `Ctrl+W`       | Delete word before cursor                 |
| `Esc` then `D` | Delete word after cursor                  |
| `Ctrl+K`       | Kill to end of line                       |
| `Ctrl+U`       | Kill to start of line                     |
| `Ctrl+Y`       | Yank back last killed text                |
| `Ctrl+T`       | Transpose two chars                       |
| `Ctrl+_`       | Undo                                      |
| `Ctrl+X Ctrl+U`| Undo (alternate)                          |
| `Ctrl+X Ctrl+X`| Jump between cursor and mark (toggle)     |
| `Ctrl+Q`       | Push current line aside (pop with `Ctrl+Q` again after next command) |
| `Ctrl+V` `<key>` | Insert next key literally               |

### Delete key fix (already in your config, line 109–110)

- `Fn+Delete` (forward delete) works correctly
- `Ctrl+Fn+Delete` deletes a word forward

### History

| Key       | Action                                                    |
|-----------|-----------------------------------------------------------|
| `Ctrl+R`  | Incremental **reverse** history search (type to filter)   |
| `Ctrl+S`  | Incremental **forward** history search                    |
| `Ctrl+P` / `N` | Previous / next in history (or arrows)               |
| `↑` / `↓` | **History-substring search** (type prefix, then arrow)    |
| `Ctrl+O`  | Accept line and advance to next history line              |

> With `SHARE_HISTORY` (line 17), every running zsh shares history in
> real-time. `HIST_IGNORE_SPACE` (line 21) means a command starting with a
> space is **not** saved — prefix secrets with a space.

### Completion (TAB)

Your `compinit -i` (line 59–60) gives you a fast menu-driven completer.

| Key                | Action                                              |
|--------------------|-----------------------------------------------------|
| `TAB`              | Complete / cycle through matches (`MENU_COMPLETE`)  |
| `Ctrl+D`           | List all possible completions                       |
| `Ctrl+X g`         | List glob expansions                                |
| `Ctrl+X *`         | Expand glob in place                                |
| `Ctrl+X a`         | Expand alias                                        |
| `Ctrl+X m`         | Insert most-recent file matching what you typed     |
| `Ctrl+X r`         | History-incremental-search filenames                |

> Completion is **case-insensitive** (line 72: `m:{a-zA-Z}={A-Za-z}`).
> `cd`/`cp`/etc. complete paths; `git` completes subcommands; `kubectl`,
> `docker`, `brew` all have their own.

### Typed-cd and dir stack

Lines 47–56 enable these:

| Input        | Result                                  |
|--------------|-----------------------------------------|
| `Repos`      | `cd Repos` (no `cd` needed, `AUTO_CD`)  |
| `cd -` `TAB` | Pick from last 20 dirs (`AUTO_PUSHD`)   |
| `dirs -v`    | Show directory stack                    |
| `cd +2`      | Jump to 3rd entry in stack              |

### Command correction

`CORRECT` is on (line 96). For typos like `git satus`:

```
zsh: correct 'satus' to 'status' [nyae]?
```

Keys: `y` yes · `n` no · `a` abort · `e` edit.

---

## 2. Your plugins — what they do and how to drive them

### zsh-syntax-highlighting (loaded at line 182)

Live colors as you type — green command exists, red doesn't. Nothing to press;
just look. Must load **before** autosuggestions (your config does this).

### zsh-autosuggestions (loaded at line 130)

Gray ghost text appears to the right of your cursor.

| Key           | Action                                  |
|---------------|-----------------------------------------|
| `→` or `End`  | Accept entire suggestion                |
| `Ctrl+→`      | Accept one word of suggestion           |
| (any other)   | Dismiss — keep typing                   |

Set in `~/.zshrc` (optional, not yet set):
```zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
```

### zsh-history-substring-search (loaded at line 160, bound at 172–176)

| Key   | Action                                                      |
|-------|-------------------------------------------------------------|
| Type, then `↑` | Find previous command containing the substring    |
| Type, then `↓` | Find next command containing the substring        |
| `Ctrl+U` | Abort search (returns to current line)                  |

Unlike `Ctrl+R`, this lets you walk forward/back through every match without
retyping. Case-insensitive by default.

### z — directory jumping (loaded at line 141)

Tracks a "frecency" (frequency + recency) of everywhere you `cd`.

```bash
z zsh-setup        # jumps to ~/Repos/zsh-setup after you've been there once
z repo zsh         # match by path-segment
z -l zsh-setup     # list matches with scores
```

### fzf — fuzzy finder (loaded at line 152)

Three shell-level bindings (active in your fzf install):

| Key       | Action                                                      |
|-----------|-------------------------------------------------------------|
| `Ctrl+R`  | Fuzzy history search (replaces zsh's `Ctrl+R`)              |
| `Ctrl+T`  | Fuzzy file finder — pastes selected path at cursor           |
| `Alt+C`   | Fuzzy directory finder — `cd` into selection                |
| `**` `TAB`| Fuzzy-complete any argument (e.g. `vim **<TAB>`)            |

Inside any fzf window:

| Key             | Action                                   |
|-----------------|------------------------------------------|
| `Ctrl+J` / `K`  | Move down / up (or arrows)               |
| `TAB`           | Multi-select (with `-m`)                 |
| `Enter`         | Accept                                   |
| `Ctrl+C` / `Esc`| Cancel                                   |
| `Ctrl+R`        | (in history) Toggle chronological sort   |
| `Alt+/`         | Toggle line wrap                         |

Search syntax (multiple terms separated by spaces):

| Token   | Meaning           |
|---------|-------------------|
| `foo`   | fuzzy match       |
| `'foo`  | exact match       |
| `^foo`  | prefix match      |
| `foo$`  | suffix match      |
| `!foo`  | inverse match     |
| `|`     | OR between terms  |

---

## 3. Aliases you actually have

From your `~/.zshrc` lines 210–272.

### General
`ll` `la` `l` · `...` (cd ../..) · `....` (cd ../../..)

### Git
`gs` status · `gcm` commit -m · `gp` push · `gpl` pull · `gco` checkout ·
`gb` branch · `gd` diff · `gl` log oneline · `gla` log all graph

### Docker (if installed)
`d` · `dc` compose · `dcu` up · `dcd` down

### Kubernetes (if installed)
`k` · `kg` get · `kd` describe · `kl` logs · `kex` exec -it

### Config
`zshconfig` (opens `~/.zshrc` in `$EDITOR` = `code --wait`) · `zshreload`

---

## 4. Functions

From `~/.zshrc` lines 320–349.

```bash
mcd mydir          # mkdir + cd into it
extract file.tar.gz  # auto-detects tar/zip/rar/7z/gz/bz2/Z
```

---

## 5. kitty keyboard shortcuts

Your `~/.config/kitty/kitty.conf` only customizes font sizes; everything else
below is kitty default. `kitty_mod` = **Ctrl+Shift**.

### Windows

| Key                       | Action                          |
|---------------------------|---------------------------------|
| `kitty_mod+Enter`         | New window (splits current)     |
| `kitty_mod+]` / `[`       | Next / previous window          |
| `kitty_mod+n`             | New OS window                   |
| `kitty_mod+w`             | Close window                    |
| `kitty_mod+r`             | Resize window (then arrows/Esc)|
| `kitty_mod+f` / `b`       | Move window forward / backward  |
| `kitty_mod+\``            | Move window to top              |
| `kitty_mod+l`             | Next layout (stacked/tall/grid/fat/horizontal/vertical/...) |
| `kitty_mod+1` … `9`       | Jump to window N                |

### Tabs

| Key                       | Action                          |
|---------------------------|---------------------------------|
| `kitty_mod+t`             | New tab                         |
| `kitty_mod+q`             | Close tab                       |
| `kitty_mod+right` / `left`| Next / previous tab             |
| `kitty_mod+shift+right` / `left` | Move tab right / left   |
| `kitty_mod+i` / `,`       | Set tab title                   |
| `Ctrl+Shift+1` … `9` (`kitty_mod+1` … `9`) | Go to tab N |

### Font (your customizations)

| Key            | Action             |
|----------------|--------------------|
| `Cmd+plus`     | Increase font size |
| `Cmd+minus`    | Decrease font size |
| `Cmd+0`        | Reset font size    |

### Scrollback / clipboard

| Key                       | Action                                     |
|---------------------------|--------------------------------------------|
| `kitty_mod+k` / `j`       | Scroll line up / down (smooth)             |
| `kitty_mod+page_up` / `page_down` | Scroll page up / down              |
| `kitty_mod+home` / `end`  | Scroll to top / bottom                     |
| `kitty_mod+z` / `x`       | Previous / next shell prompt in scrollback |
| `kitty_mod+h`             | Browse scrollback in pager                 |
| `kitty_mod+g`             | Show last command output in pager          |
| `kitty_mod+/`             | Search scrollback                          |
| `kitty_mod+c`             | Copy to clipboard                          |
| `kitty_mod+v`             | Paste from clipboard                       |
| `kitty_mod+s`             | Paste from primary selection               |
| `kitty_mod+o`             | Pass selection to external program         |

### Mouse (kitty default)

| Action                       | Result                       |
|------------------------------|------------------------------|
| `Cmd+click` on URL/path      | Open it                      |
| `Shift+drag`                 | Select in app that grabbed mouse |
| Double-click                 | Select word                  |
| Triple-click                 | Select line                  |
| `Cmd+C` / `Cmd+V`            | Standard macOS copy/paste    |

### Misc kitty

| Key                       | Action                          |
|---------------------------|---------------------------------|
| `kitty_mod+F11`           | Toggle fullscreen               |
| `kitty_mod+F10`           | Toggle kitty's own debug overlay|
| `kitty_mod+e`             | Edit `kitty.conf` (opens in EDITOR) |
| `kitty_mod+u`             | Enter Unicode input (kitten)    |
| `kitty_mod+F2`            | Run a kitten by name            |

Reload kitty config after edits: `Ctrl+Shift+F5` or `kill -SIGUSR1 $(pgrep kitty)`.

---

## 6. macOS shell integration extras

Your `~/.zshrc` loads iTerm2 shell integration (line 385) — with kitty, the
*mark-jump* and *last-command-output* features don't apply, but these kitty
built-ins fill the gap and are more reliable:

- `kitty_mod+z` / `x` — jump between shell prompts in the scrollback (works
  because kitty auto-detects shell prompts)
- `kitty_mod+g` — open last command's output in pager

If you want pure kitty shell integration (recommended over iTerm2's), it's
already enabled by default — see `kitty +kitten themes` and
https://sw.kovidgoyal.net/kitty/shell-integration/.

---

## 7. Workflow recipes

### "Find that one git command I ran last week"
`Ctrl+R`, type a fragment, hit `Ctrl+R` again to cycle; press `→` to keep, `Enter` to run.

### "Jump to the project I was in yesterday"
`z <fragment>` — if multiple match, `z -l <fragment>` shows scores first.

### "Open a file I saw in the last commit, in VS Code"
```
code $(git diff --name-only HEAD~1 | fzf --multi)
```

### "Grep across the repo and jump to a match"
```
rg --line-number . | fzf --delimiter : --nth 3.. \
    --bind 'enter:become(code -g {1}:{2}:{3})'
```

### "Split kitty into 4 panes for a dev session"
`kitty_mod+Enter` three times, then `kitty_mod+l` to cycle layouts until Grid.

### "Look at what just scrolled off"
`kitty_mod+g` to page through the last command's output, or
`kitty_mod+h` for the full scrollback in `less`.

---

## 8. Where things live

| What              | Path                                  |
|-------------------|---------------------------------------|
| zsh config        | `~/.zshrc`                            |
| Local secrets     | `~/.zshrc.local` (git-ignored)        |
| Template (repo)   | `~/Repos/zsh-setup/zshrc-template`    |
| kitty config      | `~/.config/kitty/kitty.conf`          |
| kitty themes dir  | `~/.config/kitty/themes/`             |
| fzf install       | `~/.fzf.zsh` + `~/.fzf/`              |
| z data            | `~/.z` (auto-created on first `cd`)   |
| zsh history       | `~/.zsh_history`                      |
| Completion cache  | `~/.zcompdump*`                       |

---

## 9. Troubleshooting cheat codes

| Symptom                              | Fix                                            |
|--------------------------------------|------------------------------------------------|
| Compinit warning recurs              | Ensure `~/.zshrc:114-115` uses `compinit -i`    |
| New completion not picked up         | `rm ~/.zcompdump* && exec zsh`                  |
| Ghost-suggestion color invisible     | `export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'` |
| `↑` searches but skips duplicates    | Expected: `HIST_FIND_NO_DUPS` is on (line 20)   |
| `Ctrl+R` shows fzf, not zsh          | Expected — fzf replaced it (line 152)           |
| `kitty_mod` shortcut doesn't fire    | Check if app grabbed input; try `Shift+` variant|
| Paste mangled                        | `paste_actions` (line ~731 of kitty.conf)       |

---

## 10. Sources (official docs)

- zsh manual — `man zsh` / `man zshzle` / `man zshcontrib`
- kitty docs — https://sw.kovidgoyal.net/kitty/
- kitty actions index — https://sw.kovidgoyal.net/kitty/actions/
- fzf — https://github.com/junegunn/fzf (run `fzf --man` for full options)
- zsh-autosuggestions — https://github.com/zsh-users/zsh-autosuggestions
- zsh-syntax-highlighting — https://github.com/zsh-users/zsh-syntax-highlighting
- zsh-history-substring-search — https://github.com/zsh-users/zsh-history-substring-search
- z (rupa/z) — https://github.com/rupa/z
