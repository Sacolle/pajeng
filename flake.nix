{
    description = "Derivation for the pajeng library";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = import nixpkgs { inherit system; };
            pajeng = pkgs.callPackage ./pajeng.nix {};
        in
        {
            packages = {
                default = pajeng;
                inherit pajeng;
            };
        }
    );
}
