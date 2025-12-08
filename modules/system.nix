{ config, pkgs, ... }:

{
  # Time zone
  time.timeZone = "America/New_York";

  # Locale and console
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  
  # Services
  services = {
    # Cron and SSH
    cron.enable = true;
    openssh.enable = true;
    
    # Tailscale
    tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [ "--advertise-exit-node" "--exit-node" ];
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # Automatic updates
  system.autoUpgrade.enable = true;

  # Copy system configuration
  system.copySystemConfiguration = true;
}

