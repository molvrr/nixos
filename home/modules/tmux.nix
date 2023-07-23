{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    # prefix = "C-a";
    shortcut = "a";
    keyMode = "vi";
    mouse = true;
    escapeTime = 0;
    historyLimit = 100000;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    extraConfig = ''
      set -g default-terminal 'screen-256color'
      bind r source-file ~/.tmux.conf
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind 0 select-window -t ^
      bind ^ last-window
      bind k select-pane -U
      bind j select-pane -D
      bind h select-pane -L
      bind l select-pane -R
      bind s split-window -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind r source-file ~/.tmux.conf
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
