{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  git,
  hyprlang,
  hyprutils,
  hyprtoolkit,
  hyprgraphics,
  aquamarine,
  sdbus-cpp,
  pixman,
  libdrm,
  glaze,
  openssl,
  cairo,
  pango,
}:

gcc15Stdenv.mkDerivation rec {
  pname = "hyprshutdown";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprshutdown";
    rev = "813bd56e2c2644ae55759f09f65669abf7be03ce";
    hash = "sha256-8WmQF/Ra5/Vj19f7XYPxBRcD7+22thcCIq5EjdnxcyE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];

  buildInputs = [
    hyprlang
    hyprutils
    hyprtoolkit
    hyprgraphics
    aquamarine
    sdbus-cpp
    pixman
    libdrm
    glaze
    openssl
    cairo
    pango
  ];

  meta = with lib; {
    description = "A graceful shutdown utility for Hyprland";
    homepage = "https://github.com/hyprwm/hyprshutdown";
    license = licenses.bsd3;
    platforms = platforms.linux;
    mainProgram = "hyprshutdown";
  };
}
