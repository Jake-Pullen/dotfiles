#!/bin/bash
# FIRST, MOUNT NAS AT /mnt/nas/ 

REMOTE="/mnt/nas/Jake

echo "📥 Pulling SSH keys..."
rsync "$REMOTE/ssh/id_rsa" ~/.ssh/ && chmod 600 ~/.ssh/id_rsa
rsync "$REMOTE/ssh/id_rsa.pub" ~/.ssh/ && chmod 644 ~/.ssh/id_rsa.pub
rsync "$REMOTE/ssh/config" ~/.ssh/ && chmod 644 ~/.ssh/config

echo "📥 Pulling GPG key..."
rsync "$REMOTE/ssh/my-gpg-key.asc" ~/

echo "🔑 Importing GPG key..."
gpg --import ~/my-gpg-key.asc
rm ~/my-gpg-key.asc  # Clean up after import

echo "✅ SSH and GPG setup complete!"
