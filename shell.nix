{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    iverilog
    surfer
    nixfmt
    prettier
    verible
  ];
}
