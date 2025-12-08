{ config, pkgs, ... }:

{
  # Boot configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.device = "nodev"; # EFI only
  boot.loader.grub.configurationLimit = 10;
  boot.kernelModules = [ "uvcvideo" "v4l2loopback" ];
  hardware.enableAllFirmware = true;
}

