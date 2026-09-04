{ lib, ... }:

{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 10;
    historyLimit = 5000;
    keyMode = "vi";
    mouse = false;
    resizeAmount = 5;

    prefix = lib.mkDefault "C-a";

    extraConfig = ''
      set -g renumber-windows on
      set -g set-clipboard on

      bind | split-window -h
      bind - split-window -v
      bind x kill-pane

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel

      set -g status-position bottom
      set -g status-style 'bg=#191d24 fg=colour255'
      set -g status-left ' (#S) '
      set -g status-left-length 20
      set -g status-right ""
      set -g status-right-length 50
      setw -g window-status-style 'bg=#191d24 fg=colour255'
      setw -g window-status-current-format '#I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#{?window_zoomed_flag,  ,  } '
      setw -g window-status-format '#I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#{?window_zoomed_flag,  ,  } '
    '';
  };
}
