{ configs, pkgs, ... }: {
  programs.nixvim = {
    enable = false;
    enableMan = false;
    options.mouse = "";
    options.relativenumber = true;
    options.number = true;
    options.expandtab = true;
    options.shiftwidth = 2;
    options.shell = "bash";
    options.fillchars = "eob: ";

    plugins.lualine.enable = true;
    plugins.harpoon = {
      enable = true;
      keymaps = {
        addFile = "<leader>a";
        toggleQuickMenu = "<C-e>";
        navFile = {
          "1" = "<Leader>1";
          "2" = "<Leader>2";
          "3" = "<Leader>3";
          "4" = "<Leader>4";
          "5" = "<Leader>5";
        };
      };
    };
    plugins.oil.enable = true;
    plugins.treesitter.enable = true;
    plugins.project-nvim.enable = true;
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<Leader>f" = "find_files";
        "<Leader>pf" = {
          action = "projects";
        };
        "<Leader>/" = "live_grep";
      };

      extensions.project-nvim.enable = true;
    };
    plugins.treesitter-textobjects.enable = true;
    plugins.mini = {
      enable = true;
      modules = {
        surround = { };
        pairs = { };
      };
    };
    plugins.nix-develop.enable = true;

    colorschemes.gruvbox.enable = true;
    globals.mapleader = " ";
  };
}
