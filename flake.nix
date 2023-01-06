{
  description = "Hugo environment";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
        devShells = forAllSystems (system:
          let
            pkgs = nixpkgsFor.${system};
          in {
            default = pkgs.mkShell rec {
              buildInputs = with pkgs; [
                hugo
              ];
              shellHook = ''
                export PS1="$PS1 nix> "
              '';
            };
          });
    };
}
