# Poll Taildrop every 30s and notify when files arrive.
{ pkgs, ... }:

let
  poll = pkgs.writeShellScript "taildrop-poll" ''
    set -euo pipefail

    DEST="$HOME/Taildrop"
    mkdir -p "$DEST"

    before=$(ls -1 "$DEST" 2>/dev/null | wc -l)
    ${pkgs.tailscale}/bin/tailscale file get --wait=false "$DEST/" || true
    after=$(ls -1 "$DEST" 2>/dev/null | wc -l)

    if [ "$after" -gt "$before" ]; then
      new_files=$(ls -1t "$DEST" | head -n $((after - before)))
      ${pkgs.libnotify}/bin/notify-send "Taildrop" "Received: $new_files"
    fi
  '';
in
{
  systemd.user.services.taildrop-poll = {
    Unit.Description = "Poll Taildrop for incoming files";
    Service = {
      Type = "oneshot";
      ExecStart = "${poll}";
    };
  };

  systemd.user.timers.taildrop-poll = {
    Unit.Description = "Timer for Taildrop polling";
    Timer = {
      OnBootSec = "30s";
      OnUnitActiveSec = "30s";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
