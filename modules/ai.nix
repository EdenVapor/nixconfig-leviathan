{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = false; # Use CPU inference
    loadModels = [ "frob/minimax-m2.5" ];
  };
}
