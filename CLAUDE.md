# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## System Overview

This is a NixOS system configuration for a home server named "leviathan" that serves multiple purposes:
- Media server with Plex, Sonarr, Radarr, and SABnzbd
- Backup server with BorgBackup repositories
- Social media server running Mastodon
- Web server with Nginx reverse proxy
- Personal file sync with Syncthing
- Feed reader with Miniflux (currently disabled)

## Key Configuration Files

- `configuration.nix`: Main system configuration defining all services, users, and packages
- `hardware-configuration.nix`: Auto-generated hardware configuration (do not modify)
- `minifluxadmin.env`: Contains admin credentials for Miniflux service

## Common Commands

### System Management
```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch

# Test configuration without switching
sudo nixos-rebuild test

# Build configuration only
sudo nixos-rebuild build

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Garbage collect old generations
sudo nix-collect-garbage -d
```

### Service Management
```bash
# Check service status
sudo systemctl status <service-name>

# Restart a service
sudo systemctl restart <service-name>

# View service logs
sudo journalctl -u <service-name> -f

# Key services: plex, mastodon, nginx, sonarr, radarr, sabnzbd, syncthing
```

### Configuration Testing
```bash
# Check configuration syntax
sudo nixos-rebuild dry-build

# Validate configuration without building
nix-instantiate --parse /etc/nixos/configuration.nix
```

## Architecture Notes

### Service Organization
- All services are configured declaratively in `configuration.nix`
- Services run under the `fidget` user where possible for unified permissions
- Docker is enabled for additional containerized services
- Automatic system updates are enabled

### Network Configuration
- Static IP: 192.168.1.42
- Firewall allows HTTP (80), HTTPS (443), and custom port 8080
- Tailscale configured as exit node and advertises exit node
- Multiple nginx virtual hosts for different domains

### Key Services Configuration
- **Plex**: Custom PlexPass version with specific version pinning
- **Mastodon**: Full social media instance at social.birdinter.net
- **BorgBackup**: Server for multiple client repositories with 4TB quota
- **Nginx**: Reverse proxy for multiple services and static sites
- **PostgreSQL**: Automatic backups for Mastodon database

### Security Considerations
- SSH keys configured for multiple users and machines
- ACME/Let's Encrypt for automatic SSL certificates
- Firewall configured with minimal required ports
- Separate borgbackup user with restricted permissions

### File Systems
- Root filesystem on ext4
- Additional archive mount at /mnt/archive
- EFI boot configuration with GRUB

## Development Workflow

When making changes:
1. Edit `configuration.nix` 
2. Test with `sudo nixos-rebuild test`
3. If successful, switch with `sudo nixos-rebuild switch`
4. Monitor services with `journalctl` if issues arise

## Important Notes

- This system uses Lix instead of standard Nix (configured in imports)
- Flakes are enabled for modern Nix features
- Some insecure packages are explicitly permitted for legacy .NET applications
- System configuration is automatically copied to /etc/nixos on rebuild
