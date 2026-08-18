{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings.gaps = {
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
  };
}
