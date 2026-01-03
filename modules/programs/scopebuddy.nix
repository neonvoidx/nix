{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gamescope,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "scopebuddy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "HikariKnight";
    repo = "ScopeBuddy";
    rev = "570f4db8355d37095b394f3c465b4f4720111a0c";
    hash = "sha256-tJkIt1io4M9X4Lzs/mm4K5xd7ZUCMnXVCeWv4huccx4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    gamescope
    jq
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/scopebuddy $out/bin/scopebuddy
    cp bin/scb $out/bin/scb

    chmod +x $out/bin/scopebuddy
    chmod +x $out/bin/scb

    wrapProgram $out/bin/scopebuddy \
      --prefix PATH : ${
        lib.makeBinPath [
          gamescope
          jq
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Helper script for launching games with gamescope";
    homepage = "https://github.com/HikariKnight/ScopeBuddy";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
