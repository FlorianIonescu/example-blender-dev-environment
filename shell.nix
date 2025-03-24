{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.setuptools
  ];

  shellHook = ''
    echo "Python development environment activated"
    python --version
  '';
}