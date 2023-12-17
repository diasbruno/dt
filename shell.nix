{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [gambit];
}
