#! /usr/bin/env nu

def main [
  --tailscale (-t)
] {
  mkdir ./logs
  
  mut $hosts = null
  
  if $tailscale {
    $hosts = (open ./hosts.yaml).tailscale
  } else {
    $hosts = (open ./hosts.yaml).local
  }

  for host in $hosts {
    print $"deploying to ($host.hostname) \(($host.ip)\)..."

    job spawn {
      nixos-rebuild switch --flake .#($host.hostname) --target-host root@$host.ip --build-host root@$ip o+e> ./logs/($host.hostname)
      print $"(ansi green)[✓](ansi reset) deployment to ($host.hostname) \(($host.ip)\)"
    }
  }

  while (job list | is-empty) == false {
    # do nothing so the program does not exit killing all the jobs
  }
}

