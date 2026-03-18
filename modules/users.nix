{ config, pkgs, ... }:

{
  # Users
  users.users.fidget = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" "nginx" "turnserver" ];
    shell = pkgs.fish;
    homeMode = "0755"; # Allow group and others to read and execute
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
      nixfmt
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYxapdT59ZrDWosETu1OA5d5Ca0vbcIR0TV4lYn6nNH fidget@white-whale"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmtqac+hGeuQ9Zif/gfq11Yu/Xqfyq1z8O1Kt090lAR fidget@1password"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1lEzJi8LNEr2C/6LB2MksF1uWuVxOV2nX7l4CC544T fidget@eden"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrF0X0VyS7qULOxTTUqWaTZCjS5ZMr5IkYJhV7Ad/UZ fidgetbeeby@gmail.com@seraph"
    ];
  };

  users.users.borgbackup = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/borgbackup";
    group = "borgbackup";
    description = "Borg Backup user";
    shell = pkgs.bash;
  };

  users.groups.borgbackup = { };
  users.groups.turnserver = { };

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
}
