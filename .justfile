default:
	echo -e "just rebuild -> nixos-rebuild switch --impure --flake\njust update -> nix flake update\njust history -> list generations\njust repl -> start nix repl with nixpkgs\njust clean -> clean older than 7days\njust gc -> clean old"
rebuild:
	sudo nixos-rebuild switch --flake . --impure
update:
	nix flake update
history:
	nix profile history --profile /nix/var/nix/profiles/system
repl:
	nix repl -f flake:nixpkgs
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
gc:
  sudo nix-collect-garbage --delete-old
