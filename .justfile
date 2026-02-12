default: rebuild
rebuild:
	nh os switch .
boot:
  sudo nixos-rebuild boot --flake
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
	nh clean all
search pkg:
	nh search {{pkg}}
run pkg +args:
  nix-shell -p {{pkg}}.out --run '{{args}}'
shell pkg:
  nix-shell -p {{pkg}}
fetch-hash url:
    @raw_hash=`nix-prefetch-url --type sha256 "{{url}}" | tail -n1`
    @echo "Hex hash: $$raw_hash"
    @echo "Nix hash: $$(nix hash convert --hash-algo sha256 "$$raw_hash")"
