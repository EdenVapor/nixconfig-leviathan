{ config, pkgs, lib, ... }:

{
  services = {
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
  };

  # Adjust Plex systemd service
  systemd.services.plex.serviceConfig.ProtectHome = lib.mkForce false;
}

