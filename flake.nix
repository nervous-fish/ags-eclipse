{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ags }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = ags.lib.bundle { 
      inherit pkgs;
      src = ./.;
      name = "my-shell";
      entry = "app.ts";
      gtk4 = false;

      extraPackages = (with pkgs; [
        wrapGAppsHook
        gobject-introspection
        typescript
      ]) ++ (with ags.packages.${system}; [
        tray
        hyprland
        apps
        battery
        bluetooth
        mpris
        cava
        network
        notifd
        powerprofiles
        wireplumber
      ]);
    };
  };
}