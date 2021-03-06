{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:
let

  haskellPackages =
    if compiler == "default"
    then nixpkgs.haskell.packages.ghc821
    else nixpkgs.haskell.packages.${compiler};

  parsers =
    haskellPackages.callPackage
      (import ./nix/parsers.nix)
      {};

  trifecta =
    haskellPackages.callPackage
      (import ./nix/trifecta.nix)
      { inherit parsers; };

  indentation-core =
    haskellPackages.callPackage
      (import ./nix/indentation-core.nix)
      {};

  indentation-trifecta =
    haskellPackages.callPackage
      (import ./nix/indentation-trifecta.nix)
      { inherit trifecta;
        inherit parsers;
        inherit indentation-core;
      };

in
nixpkgs.haskell.lib.dontHaddock (haskellPackages.callPackage
  ./phil.nix
  { inherit trifecta;
    inherit parsers;
    inherit indentation-trifecta;
  })
