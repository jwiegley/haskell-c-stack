{ compiler    ? "ghc844"
, doBenchmark ? false
, doTracing   ? false
, doStrict    ? false
, rev         ? "e1ad1a0aa2ce6f9fd951d18181ba850ca8e74133"
, sha256      ? "0vk5sjmbq52xfrinrhvqry53asl6ppwbly1l7ymj8g0j4pkjf7p1"
, pkgs        ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
  }
, returnShellEnv ? pkgs.lib.inNixShell
, mkDerivation ? null
}:

let haskellPackages = pkgs.haskell.packages.${compiler};

in haskellPackages.developPackage {
  root = ./.;

  source-overrides = {
  };

  modifier = drv: pkgs.haskell.lib.overrideCabal drv (attrs: {
    inherit doBenchmark;
  });

  inherit returnShellEnv;
}
