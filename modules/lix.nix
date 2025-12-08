let
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
in
import "${module}/module.nix" { lix = lixSrc; }

