{ pkgs, ... }:

let
  configFile = (pkgs.formats.json { }).generate "karabiner.json" {
    profiles = [
      {
        name = "Default";
        selected = true;
        complex_modifications.rules = [
          {
            description = "Caps Lock: Control with other keys, Escape when tapped";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers.optional = [ "any" ];
                };
                to = [
                  {
                    key_code = "left_control";
                    lazy = true;
                  }
                ];
                to_if_alone = [ { key_code = "escape"; } ];
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  # Karabiner watches the directory; symlinking only the JSON breaks reloading.
  # Manage settings here rather than through the GUI.
  xdg.configFile."karabiner".source = pkgs.runCommand "karabiner-config" { } ''
    mkdir -p "$out"
    cp ${configFile} "$out/karabiner.json"
  '';
}
