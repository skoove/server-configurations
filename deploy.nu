#! /usr/bin/env -S nu -n --no-std-lib

def main [
  --tailscale (-t)
] {
  mkdir ./logs
  
  mut $hosts = null
  
  if $tailscale {
    $hosts = (open ./hosts.nuon).tailscale
  } else {
    $hosts = (open ./hosts.nuon).local
  }

  $hosts | par-each { |$host|
  
    print $"deploying to ($host.hostname) \(($host.ip)\)..."

    let $result = do { nixos-rebuild switch --flake .#($host.hostname) --target-host root@($host.ip) } | complete

    if $result.exit_code == 0 {
      print $"[✓](ansi reset) deployment to ($host.hostname) \(($host.ip)\) success "
      notify-send $"[✓] deployment to ($host.hostname) \(($host.ip)\) success "
    } else {
      print $"(ansi red_bold)[x](ansi reset) deploy to ($host.hostname) \(($host.ip)\) failed"
      notify-send $"[x] deploy to ($host.hostname) \(($host.ip)\) failed"
    }

    $result | to nuon --indent 2 | save -f $'./logs/($host.hostname).nuon'
  }

  notify-send "deployments done!"
}

