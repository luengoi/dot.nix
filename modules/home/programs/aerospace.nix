{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      config-version = 2;

      gaps = {
        inner = {
          horizontal = 5;
          vertical = 5;
        };
        outer = {
          bottom = 5;
          left = 5;
          right = 5;
          top = 5;
        };
      };

      mode.main.binding = {
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-comma = "layout accordion horizontal vertical";
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-minus = "resize smart -50";
        alt-slash = "layout tiles horizontal vertical";
        alt-equal = "resize smart +50";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
        esc = [
          "reload-config"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
      };
    };
  };
}
