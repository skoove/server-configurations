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

    job spawn {
      nixos-rebuild switch --flake .#($host.hostname) --target-host root@($host.ip) --build-host root@($host.ip) out+err> ./logs/($host.hostname)
    }
  }

  while (job list | is-empty) == false {
    # do nothing so the program does not exit killing all the jobs
  }
}

