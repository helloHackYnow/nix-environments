{
  pkgs,
  extraPkgs ? [],
  ...
}:
pkgs.mkShell {
  name = "ladybird-env";

  inputsFrom = [
    pkgs.ladybird
  ];

  packages = with pkgs; [
    ccache
    clang-tools
    prettier
    icu78.dev
    mimalloc
    dejavu_fonts
    liberation_ttf
  ] ++ extraPkgs;

  wuffs = pkgs.stdenv.mkDerivation {
    pname = "wuffs-release-c";
    version = "0.3.4";

    src = pkgs.fetchFromGitHub {
      owner = "google";
      repo = "wuffs-mirror-release-c";
      rev = "v0.3.4";
      hash = "sha256-V7inWJqH7Q4Ac/ZB//7XHrpgfAYUPBxWBerBem6Q/Kk=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/include/wuffs
      cp release/c/wuffs-v0.3.c $out/include/wuffs/
    '';
  };

  ICU_ROOT = "${pkgs.icu78.dev}";

  FONTCONFIG_FILE = pkgs.makeFontsConf {
    fontDirectories = [ pkgs.dejavu_fonts pkgs.liberation_ttf ];
  };

  # https://github.com/NixOS/nixpkgs/blob/79a8a723b9/pkgs/by-name/la/ladybird/package.nix#L144-L147
  NIX_LDFLAGS = "-lGL -lfontconfig";
}
