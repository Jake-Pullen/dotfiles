# 📁 dotfiles

My Hyprland-based Linux configuration managed as a Git repository.

## 🎯 What's Included

| Component | Description |
|-----------|-------------|
| **Hyprland** | Window manager config (monitors, bindings, input, look & feel) |
| **Git** | Config with GPG signing, aliases, and templates |
| **Starship** | Customizable prompt with Catppuccin Mocha theme |
| **Fastfetch** | ASCII hardware/software system info display |
| **Bash** | Shell config with Omarchy defaults |

## 🛠️ Setup

Run the master setup script (requires Omarchy):

```bash
./setup_omarchy.sh
```

This script will:
1. Install packages
2. Create symbolic links to `~/.config/`
3. Mount NAS for backups
4. Restore SSH/GPG keys and Git data
5. Set up cron jobs

## 📁 Repository Structure

```
├── hypr/              # Window manager configs
├── git/               # Git configuration & templates
├── fastfetch/         # System info display config
├── scripts/
│   ├── generic/       # Generic setup/restore scripts
│   └── omarchy-specific/  # Omarchy package/bloat scripts
├── starship.toml      # Prompt theme
├── .bashrc            # Shell configuration
├── git_backup.sh      # Backup all Git repos to NAS
└── setup_omarchy.sh   # Master setup script
```

## 📝 Notes

- Hyprland sources Omarchy defaults in `~/.local/share/omarchy/default/hypr/`
- Personal overrides go in `~/.config/hypr/`
- Git backups stored at `/mnt/nas/Jake/git_backups/`
