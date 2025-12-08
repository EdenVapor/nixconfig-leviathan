# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  particularisation_config = import ./particularisation_config.nix;
  matrix-synapse_config = (import ./matrix-synapse.nix) {particularisation_config = particularisation_config;};
  coturn_config = (import ./coturn.nix) {particularisation_config = particularisation_config;};
  nginx_config = (import ./nginx.nix) {particularisation_config = particularisation_config;};
in
{
  imports = [
    ./hardware-configuration.nix

      # This includes the Lix NixOS module in your configuration along with the
      # matching version of Lix itself.
      #
      # The sha256 hashes were obtained with the following command in Lix (n.b.
      # this relies on --unpack, which is only in Lix and CppNix > 2.18):
      # nix store prefetch-file --name source --unpack https://git.lix.systems/lix-project/lix/archive/2.91.1.tar.gz
      #
      # Note that the tag (e.g. 2.91.1) in the URL here is what determines
      # which version of Lix you'll wind up with.
      (let
        module = fetchTarball {
          name = "source";
          url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
          sha256 = "sha256-DN5/166jhiiAW0Uw6nueXaGTueVxhfZISAkoxasmz/g=";
        };
        lixSrc = fetchTarball {
          name = "source";
          url = "https://git.lix.systems/lix-project/lix/archive/2.91.1.tar.gz";
          sha256 = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U=";
        };
        # This is the core of the code you need; it is an exercise to the
        # reader to write the sources in a nicer way, or by using npins or
        # similar pinning tools.
        in import "${module}/module.nix" { lix = lixSrc; }
      )
  ];

  # Boot configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.device = "nodev"; # EFI only
  boot.loader.grub.configurationLimit = 10;
  boot.kernelModules = [ "uvcvideo" "v4l2loopback" ];
  hardware.enableAllFirmware = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Extra file systems
  fileSystems."/mnt/archive" = {
    device = "/dev/disk/by-uuid/be7a8f42-6b17-4ceb-9677-a05718b28397";
    fsType = "ext4";
  };

  # Networking
  networking = {
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.1.42";
      prefixLength = 24;
    }];

    hostName = "leviathan";
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Time zone
  time.timeZone = "America/New_York";

  # Locale and console
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Users
  users.users.fidget = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "nginx" "turnserver" ];
    shell = pkgs.fish;
    homeMode = "0755";  # Allow group and others to read and execute
    packages = with pkgs; [
      bat
      btop
      glances
      neofetch
      hyfetch
      ncdu
      git
      s3cmd
      awscli2
      nodejs
      gh
      starship
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYxapdT59ZrDWosETu1OA5d5Ca0vbcIR0TV4lYn6nNH fidget@white-whale"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFBUnJgz77B8YhFCh1Whsa0ziCRt+VPbtCCmmBLxXJD fidget@Eden"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmRvc/FaV8nNYpo9h8PHsdI7ODOXQf1g0m1BwTsUm5O fidget-borg@leviathan"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmtqac+hGeuQ9Zif/gfq11Yu/Xqfyq1z8O1Kt090lAR fidget@1password"
    ];
  };

  # Set up npm global directory for fidget user
  environment.variables = {
    NPM_CONFIG_PREFIX = "/home/fidget/.npm-global";
  };

  # Add npm global bin to PATH
  environment.extraInit = ''
    export PATH="/home/fidget/.npm-global/bin:$PATH"
  '';

  users.users.borgbackup = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/borgbackup";
    group = "borgbackup";
    description = "Borg Backup user";
    shell = pkgs.bash;
  };

  users.groups.borgbackup = {};
  users.groups.turnserver = {};
  
  # Add nginx user to turnserver group so it can read TURN certificates
  users.users.nginx.extraGroups = [ "turnserver" ];

  # Ensure Jellyfin service user is a member of the fidget group
  users.users.jellyfin.extraGroups = [ "fidget" ];

  # Samba users
  users.users.saramichas = {
    isNormalUser = false;
    isSystemUser = true;
    group = "users";
    description = "Mom's Samba user for family backup";
    shell = "/run/current-system/sw/bin/nologin";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    sudo
    screen
    pv
    docker-compose
    v4l-utils
    borgbackup
    zulu
    openssl
    samba
  ];

  # Docker
  virtualisation.docker.enable = true;

  # Unfree/unsafe packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];

  # Enable Fish shell
  programs.fish.enable = true;

  # Services
  services = {

    # BorgBackup server
    borgbackup = {
      repos.eden = {
        path = "/var/lib/borgbackup/eden";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJiQh4EIE2PiR6ab2d8lUgX24WH82d20um/CLT9yH2df fidget@lilith"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYxapdT59ZrDWosETu1OA5d5Ca0vbcIR0TV4lYn6nNH fidget@white-whale"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFBUnJgz77B8YhFCh1Whsa0ziCRt+VPbtCCmmBLxXJD fidget@Eden"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmRvc/FaV8nNYpo9h8PHsdI7ODOXQf1g0m1BwTsUm5O fidget-borg@leviathan"
        ];
        allowSubRepos = true;
        quota = "4T";
      };
    };

    # Cron and SSH
    cron.enable = true;
    openssh.enable = true;

    # Plex Media Server (using PlexPass)
    plex = let
      plexpass = pkgs.plex.override {
        plexRaw = pkgs.plexRaw.overrideAttrs (old: rec {
          version = "1.42.1.10060-4e8b05daf";
          src = pkgs.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha1 = "ef8111b7af03e8fbf0d9c57a6455ba687f0fe18b";
          };
        });
      };
    in {
      enable = true;
      user = "fidget";
      group = "users";
      package = plexpass;
    };

    # Jellyfin Media Server
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # SABnzbd
    sabnzbd = {
      enable = true;
      user = "fidget";
      configFile = "/home/fidget/conf/sabnzbd/sabnzbd.ini";
    };

    # Sonarr / Radarr
    sonarr = {
      enable = true;
      user = "fidget";
    };
    radarr = {
      enable = true;
      user = "fidget";
    };

    # Tailscale
    tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [ "--advertise-exit-node" "--exit-node" ];
    };

    # Mastodon
    mastodon = {
      enable = true;
      localDomain = "social.birdinter.net";
      configureNginx = true;
      smtp.fromAddress = "flock@birdinter.net";
      streamingProcesses = 19;
    };

    # Nginx
    nginx = nginx_config;

    # Syncthing
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      systemService = true;
      group = "users";
      user = "fidget";
      configDir = "/home/fidget/.config/syncthing";
      dataDir = "/home/fidget/syncthing";
    };

    # PostgreSQL backup
    postgresqlBackup = {
      enable = true;
      databases = [ "mastodon" ];
      location = "/var/backup/postgresql";
    };

    # Samba file sharing
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        family = {
          path = "/mnt/archive/family/mom";
          "read only" = "no";
          "guest ok" = "no";
          "valid users" = "fidget saramichas";
          "write list" = "fidget saramichas";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
    };

    # Matrix Synapse
    matrix-synapse = matrix-synapse_config;
    
    # Coturn TURN server
    coturn = coturn_config;
  };

  # ACME/Let's Encrypt
  security.acme = {
    acceptTerms = true;
    defaults.email = "fidgetbeeby@gmail.com";
    # certs."turn.${particularisation_config.domain_name}" = {
    #   postRun = "systemctl restart coturn";
    #   group = "turnserver";
    # };
  };

  # Adjust Plex systemd service
  systemd.services.plex.serviceConfig.ProtectHome = lib.mkForce false;

  # Firewall
  networking.firewall = {
    allowedTCPPorts = [ 80 443 8080 32400 139 445 ];
    # allowedUDPPortRanges = [ {from = particularisation_config.turn_minimal_listening_port; to = particularisation_config.turn_maximal_listening_port;} ];
    allowedUDPPorts = [ 137 138 ];
  };

  # Automatic updates
  system.autoUpgrade.enable = true;

  # Copy system configuration
  system.copySystemConfiguration = true;

  # State version
  system.stateVersion = "23.11";
}
