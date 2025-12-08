{ config, pkgs, ... }:

{
  services = {
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
  };

  # Extra file systems
  fileSystems."/mnt/archive" = {
    device = "/dev/disk/by-uuid/be7a8f42-6b17-4ceb-9677-a05718b28397";
    fsType = "ext4";
  };
}

