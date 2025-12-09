# NixOS Configuration for Leviathan Server

This directory (`/etc/nixos`) contains the NixOS configuration for the server named "Leviathan". It defines the entire system configuration, including hardware, software, services, and user environments, in a declarative and reproducible manner using Nix expressions.

## Key Files:

*   `configuration.nix`: The main system configuration file, importing various modules and defining global settings.
*   `hardware-configuration.nix`: Automatically generated hardware-specific configuration, typically including bootloader settings and file system mounts.
*   `minifluxadmin.env`: Environment variables for the Miniflux admin user, likely used for service configuration.

## Directory Structure:

*   `modules/`: This directory contains modularized NixOS configurations, promoting reusability and organization. Each `.nix` file typically defines a specific aspect or service of the system.
    *   `backup.nix`: Configuration related to system backups.
    *   `boot.nix`: Bootloader and kernel-related settings.
    *   `file-sharing.nix`: Configuration for file sharing services.
    *   `lix.nix`: Likely related to a specific Nix package or service named 'lix'.
    *   `media.nix`: Configuration for media-related services or applications.
    *   `networking.nix`: Network interface and firewall configurations.
    *   `nginx.nix`: Core Nginx web server configuration.
    *   `packages.nix`: Definitions for system-wide installed packages.
    *   `particularisation_config.nix`: Specific or custom configurations for this particular server instance.
    *   `social.nix`: Configuration for social media-related services or integrations.
    *   `system.nix`: General system-level configurations.
    *   `users.nix`: User and group definitions.
    *   `web.nix`: General web-related service configurations, possibly distinct from Nginx specifics.
*   `nginx/`: Contains Nginx virtual host or server block configurations, likely imported by `modules/nginx.nix`.
    *   `A.nix`, `matrix.A.nix`, `turn.A.nix`, `www.A.nix`: These likely define specific Nginx server blocks or proxy configurations for different services (e.g., a general 'A' site, Matrix, TURN server, and the main 'www' site).
*   `secrets/`: This directory is intended to hold sensitive information (e.g., API keys, passwords, private keys) that should be handled securely, often encrypted or managed by a secrets management system.
*   `.git/`: Git repository metadata.
*   `.gitignore`: Specifies intentionally untracked files to ignore.

## Usage:

To apply changes to this NixOS configuration, typically you would:
1.  Modify the relevant `.nix` files.
2.  Run `nixos-rebuild switch` (or `boot`) as root to activate the new configuration.

This declarative approach ensures that the system state is always consistent with the definitions in these files.
