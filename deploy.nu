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

  for host in $hosts {
  
    print $"deploying to ($host.hostname) \(($host.ip)\)..."
    notify-send $"deploying to ($host.hostname) \(($host.ip)\)..."

    # ssh-keygen -R $host.ip
    # ssh-keyscan $host.ip | save --append ~/.ssh/known_hosts

    let $result = do { nixos-rebuild switch --flake .#($host.hostname) --target-host root@($host.ip) } | complete

    if $result.exit_code == 0 {
      print $"(ansi green_bold)[✓](ansi reset) deployment to ($host.hostname) \(($host.ip)\) success "
      notify-send $"(ansi green_bold)[✓](ansi reset) deployment to ($host.hostname) \(($host.ip)\) success "
    } else {
      print $"(ansi red_bold)[x](ansi reset) deploy to ($host.hostname) \(($host.ip)\) failed"
      notify-send $"(ansi red_bold)[x](ansi reset) deploy to ($host.hostname) \(($host.ip)\) failed"
    }

    $result | to nuon --indent 2 | save -f $'./logs/($host.hostname).nuon'
  }

  notify-send "deployments done!"
}

