#!/usr/bin/env bash
#
# Master Omarchy Setup Script
# Runs all setup scripts in dependency order

set -e

echo "========================================"
echo "  Omarchy Fresh Install - Starting..."
echo "========================================"

# 1. Add packages (must be first)
echo "[1/4] Installing packages..."
./omarchy_package_install.sh


# 2. Set up symbolic links
echo ""
echo "[2/4] Setting up symbolic links..."
./set_up_sym_links.sh

# 3. Mount NAS (required for restore scripts)
echo ""
echo "[3/4] Setting up NAS mount..."
./set_up_nas_mount.sh

# 4. Restore backups (requires NAS mount)
echo ""
echo "[4/4] Restoring SSH/GPG keys and Git data..."

echo "  - Restoring SSH and GPG keys..."
./restore_ssh_gpg.sh

echo "  - Restoring Git backups..."
./restore_git_backup.sh

echo "  - Restoring cron jobs..."
./restore_cron_jobs.sh

echo "  - Enabling services..."
sudo systemctl enable --now cronie.service

echo ""
echo "========================================"
echo "  Omarchy Setup Complete!"
echo "========================================"
