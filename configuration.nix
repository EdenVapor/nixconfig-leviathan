# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/lix.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/system.nix
    ./modules/media.nix
    ./modules/social.nix
    ./modules/backup.nix
    ./modules/web.nix
    ./modules/file-sharing.nix
    ./modules/ai.nix
    ./modules/swap.nix
    ./modules/secrets.nix
    #./modules/openclaw.nix
    "${
      fetchTarball {
        url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
        sha256 = "1bzpink1dn2fbdpyl99qwwbdzgfnwi6drfq210pcydi49y686a2l";
      }
    }/modules/sops"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc zlib ];

  # State version
  system.stateVersion = "23.11";
}
