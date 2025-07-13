#!/usr/bin/env fish

set hosts \
    "jellyfin 192.168.0.253" \
    "transmission 192.168.0.36"

for pair in $hosts
    set name (echo $pair | awk '{print $1}')
    set ip (echo $pair | awk '{print $2}')

    echo "deploying to $name at $ip..."
    nixos-rebuild switch --flake .#$name --target-host root@$ip --use-remote-sudo

    if test $status -ne 0
        printf "\e[31m[!]\e[0m Deployment failed on $name ($ip)\n"
    else
        printf "\e[32m[✓]\e[0m Deployment succeeded on $name ($ip)\n"
    end
end
