{ config, pkgs, ... }:

{
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
    kitty
  ];

  # Unfree/unsafe packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set up npm global directory for fidget user
  environment.variables = {
    NPM_CONFIG_PREFIX = "/home/fidget/.npm-global";
  };

  # Add npm global bin to PATH
  environment.extraInit = ''
    export PATH="/home/fidget/.npm-global/bin:$PATH"
  '';
  
  # Enable Fish shell
  programs.fish.enable = true;
}

