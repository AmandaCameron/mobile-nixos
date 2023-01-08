{
  mobile-nixos
, fetchFromGitHub
, fetchpatch
, ...
}:

mobile-nixos.kernel-builder {
  version = "6.1.0-rc8";
  configfile = ./config.aarch64;
  src = fetchFromGitHub {
    # https://github.com/megous/linux
    owner = "megous";
    repo = "linux";
    # orange-pi-6.1
    rev = "4e165abf03a3c38ec7c13e6e07e544fb6ab13166";
    sha256 = "sha256-TgFXH8bHWHs26rlf7a/zNO9zubFazC8Ie6J1gj4gLgw=";
  };
  patches = [
    ./0001-dts-pinephone-Setup-default-on-and-panic-LEDs.patch
    (fetchpatch {
      url = "https://github.com/mobile-nixos/linux/commit/372597b5449b7e21ad59dba0842091f4f1ed34b2.patch";
      sha256 = "1lca3fdmx2wglplp47z2d1030bgcidaf1fhbnfvkfwk3fj3grixc";
    })
  ];

  # Install *only* the desired FDTs
  postInstall = ''
    echo ":: Installing FDTs"
    mkdir -p "$out/dtbs/allwinner"
    cp -v $buildRoot/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-*.dtb $out/dtbs/allwinner/
  '';

  isCompressed = false;
}
