{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, HUnit, parsec, process, QuickCheck
      , stdenv
      }:
      mkDerivation {
        pname = "git-prompt";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [ base parsec process QuickCheck ];
        executableHaskellDepends = [ base parsec process QuickCheck ];
        testHaskellDepends = [ base HUnit parsec process QuickCheck ];
        homepage = "http://github.com/olivierverdier/zsh-git-prompt#readme";
        description = "Informative git prompt for zsh";
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
