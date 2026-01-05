default:
	echo -e "just rebuild -> nixos-rebuild switch --impure --flake\njust update -> nix flake update\njust history -> list generations\njust repl -> start nix repl with nixpkgs\njust clean -> clean older than 7days\njust gc -> clean old"
rebuild:
	nh os switch .
update:
	nix flake update
update-input input:
	nix flake lock --update-input {{input}}
check:
	nix flake check
history:
	nix profile history --profile /nix/var/nix/profiles/system
repl:
	nix repl -f flake:nixpkgs
clean:
	nh clean
gc:
  sudo nix-collect-garbage --delete-old
search pkg:
	nh search {{pkg}}
