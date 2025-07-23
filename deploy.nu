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
      ssh-keygen -R $host.ip
      ssh-keyscan $host.ip | save --append ~/.ssh/known_hosts

      let $result = do { nixos-rebuild switch --flake .#($host.hostname) --target-host root@($host.ip) } | complete

      if $result.exit_code == 0 {
        print $"(ansi green_bold)[✓](ansi reset) deployment to ($host.hostname) \(($host.ip)\) success "
      } else {
        print $"(ansi red_bold)[x](ansi reset) deploy to ($host.hostname) \(($host.ip)\) failed"
      }

      $result | to nuon --indent 2 | save -f $'./logs/($host.hostname).nuon'
    }
  }

  while (job list | is-empty) == false {
    # do nothing so the program does not exit killing all the job
  }

  # sleep because sometimes the success message wont get printed
  sleep 1sec
}

