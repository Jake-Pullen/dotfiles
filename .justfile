# Justfile for system updates

update: update-dnf update-flatpak update-uv update-rust update-tailscale cleanup
    @echo "All updates completed!"

update-dnf:
    @echo "Checking for dnf updates..."
    sudo dnf update -y

update-flatpak:
    @echo "Checking for flatpak updates..."
    sudo flatpak update -y

cleanup:
    @echo "Doing a quick clean up..."
    sudo dnf clean all

check-restart:
    @echo "Checking if we need a restart..."
    sudo dnf needs-restarting

update-uv:
    @echo "updating UV"
    uv self update
    uv tool install ruff@latest

update-rust:
    @echo "Updating Rust"
    rustup update

update-tailscale:
    @echo "Updating Tailscale"
    sudo tailscale update --yes