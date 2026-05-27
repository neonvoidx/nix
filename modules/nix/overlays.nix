{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          (final: _prev: {
            monolisa = final.stdenv.mkDerivation {
              pname = "monolisa";
              version = "1.0.0";
              src = inputs.self + "/assets/fonts/MonoLisa";
              installPhase = ''
                mkdir -p $out/share/fonts/truetype
                cp -v MonoLisa.ttc $out/share/fonts/truetype/
              '';
            };
          })
        ];
      };
    };
}
