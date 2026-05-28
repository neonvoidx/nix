{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          (final: _prev: {
            neonmono = final.stdenv.mkDerivation {
              pname = "neonmono";
              version = "1.0.0";
              src = inputs.self + "/assets/fonts/";
              installPhase = ''
                mkdir -p $out/share/fonts/truetype
                cp -v NeonMono.ttc $out/share/fonts/truetype/
              '';
            };
          })
        ];
      };
    };
}
