#!/bin/bash

# FIRST, MOUNT NAS AT /mnt/nas/

REMOTE="/mnt/nas/Jake"

echo "📥 Pulling SSH keys..."
if [ ! -f ~/.ssh/id_rsa ] || [ "$(stat -c %Y "$REMOTE/ssh/id_rsa")" -gt "$(stat -c %Y ~/.ssh/id_rsa 2>/dev/null || echo 0)" ]; then
    rsync "$REMOTE/ssh/id_rsa" ~/.ssh/ && chmod 600 ~/.ssh/id_rsa
fi

if [ ! -f ~/.ssh/id_rsa.pub ] || [ "$(stat -c %Y "$REMOTE/ssh/id_rsa.pub")" -gt "$(stat -c %Y ~/.ssh/id_rsa.pub 2>/dev/null || echo 0)" ]; then
    rsync "$REMOTE/ssh/id_rsa.pub" ~/.ssh/ && chmod 644 ~/.ssh/id_rsa.pub
fi

if [ ! -f ~/.ssh/config ] || [ "$(stat -c %Y "$REMOTE/ssh/config")" -gt "$(stat -c %Y ~/.ssh/config 2>/dev/null || echo 0)" ]; then
    rsync "$REMOTE/ssh/config" ~/.ssh/ && chmod 644 ~/.ssh/config
fi

echo "📥 Pulling GPG key..."
if [ ! -f ~/my-gpg-key.asc ]; then
    rsync "$REMOTE/ssh/my-gpg-key.asc" ~/
else
    echo "  GPG key already exists locally, skipping download"
fi

if [ ! -f ~/my-gpg-key.asc ]; then
    echo "✅ SSH and GPG setup complete!"
    exit 0
fi

echo "🔑 Importing GPG key..."
if ! gpg --list-secret-keys --with-colons "my-gpg-key.asc" 2>/dev/null | grep -q "^sec:"; then
    gpg --import ~/my-gpg-key.asc
else
    echo "  GPG key already imported, skipping import"
fi
rm -f ~/my-gpg-key.asc

echo "✅ SSH and GPG setup complete!"
