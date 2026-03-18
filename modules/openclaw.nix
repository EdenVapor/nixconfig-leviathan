{ config, pkgs, ... }:

{
  virtualisation.oci-containers.backend = "podman";
  # ── Sops secrets (individual keys from secrets.yaml) ──────────────────
  sops.secrets = {
    "openclaw_minimax_api_key" = { };
    "openclaw_telegram_bot_token" = { };
    "openclaw_discord_bot_token" = { };
    "openclaw_signal_credentials" = { }; # Signal linking secret, if needed
    "openclaw_gateway_token" = { }; # Dashboard auth token
  };

  # ── Rendered env file from sops secrets ───────────────────────────────
  # sops.templates renders a real file at /run/secrets-rendered/openclaw.env
  # with the decrypted values substituted in at activation time.
  sops.templates."openclaw.env" = {
    content = ''
      MINIMAX_API_KEY=${config.sops.placeholder."openclaw_minimax_api_key"}
      TELEGRAM_BOT_TOKEN=${
        config.sops.placeholder."openclaw_telegram_bot_token"
      }
      DISCORD_BOT_TOKEN=${config.sops.placeholder."openclaw_discord_bot_token"}
      SIGNAL_CREDENTIALS=${
        config.sops.placeholder."openclaw_signal_credentials"
      }
      OPENCLAW_GATEWAY_TOKEN=${config.sops.placeholder."openclaw_gateway_token"}
    '';
    owner = "root";
  };

  # ── OpenClaw container ────────────────────────────────────────────────
  virtualisation.oci-containers.containers.openclaw = {
    image = "alpine/openclaw:latest";
    autoStart = true;

    # Port mapping disabled due to network=host
    ports = [];

    volumes = [
      "/home/fidget/openclaw/.openclaw:/home/node/.openclaw"
      "/home/fidget/openclaw/workspace:/home/node/.openclaw/workspace"
    ];

    environment = {
      TZ = "America/New_York";
      HOME = "/home/node";
      TERM = "xterm-256color";
    };

    # Secrets injected from the sops-rendered env file — never touches the Nix store
    environmentFiles = [ config.sops.templates."openclaw.env".path ];

    cmd = [ "node" "dist/index.js" "gateway" "--bind" "loopback" "--port" "18789" ];

    extraOptions = [
      "--network=host"
      "--no-healthcheck"
      "--init"
      "--cap-drop=NET_RAW"
      "--cap-drop=NET_ADMIN"
      "--security-opt=no-new-privileges:true"
    ];
  };

  # ── Ensure data directories exist with correct ownership ──────────────
  systemd.tmpfiles.rules = [
    "d /home/fidget/openclaw             0750 fidget users -"
    "d /home/fidget/openclaw/.openclaw   0750 fidget users -"
    "d /home/fidget/openclaw/workspace   0750 fidget users -"
  ];
}
