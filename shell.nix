{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    gnumake
    iverilog
    surfer
    nixfmt
    prettier
    verible
  ];
}
