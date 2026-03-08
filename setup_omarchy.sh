#!/usr/bin/env bash
#
# Master Omarchy Setup Script
# Runs all setup scripts in dependency order

set -e

echo "========================================"
echo "  Omarchy Fresh Install - Starting..."
echo "========================================"

# 1. Add packages (must be first)
echo "Installing packages..."
./scripts/omarchy-specific/omarchy_package_install.sh

# 2. Set up symbolic links
echo ""
echo "Setting up symbolic links..."
./scripts/generic/set_up_sym_links.sh

# 3. Mount NAS (required for restore scripts)
echo ""
echo "Setting up NAS mount..."
./scripts/generic/set_up_nas_mount.sh

# 4. Restore backups (requires NAS mount)
echo ""
echo "Restoring SSH/GPG keys and Git data..."

echo "  - Restoring SSH and GPG keys..."
./scripts/generic/restore_ssh_gpg.sh

echo "  - Restoring Git backups..."
./scripts/generic/restore_git_backup.sh >/dev/null 2>&1 || echo "    (Git restore skipped)"

echo "  - Restoring cron jobs..."
./scripts/generic/restore_cron_jobs.sh

echo "  - Enabling services..."
sudo systemctl enable --now cronie.service

echo "  - Removing unwanted stuf..."
./scripts/omarchy-specific/remove_bloat.sh

echo ""
echo "========================================"
echo "  Omarchy Setup Complete!"
echo "========================================"
