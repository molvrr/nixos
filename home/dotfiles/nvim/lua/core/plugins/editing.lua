return {
  {"echasnovski/mini.pairs", config = function() return (require("mini.pairs")).setup() end},
  {"echasnovski/mini.surround", config = function() return (require("mini.surround")).setup() end},
  {"julienvincent/nvim-paredit", opts = {use_default_keys = true}},
  {"julienvincent/nvim-paredit-fennel", opts = {}, ft = {"fennel"}, dependencies = {{"julienvincent/nvim-paredit"}}},
  {
    "ThePrimeAgen/harpoon", branch = "harpoon2", dependencies = {{"nvim-lua/plenary.nvim"}}, config = function()
      local harpoon = require("harpoon")
      return harpoon:setup({
        settings = {
          save_on_toggle = true
        }
      })
    end
  },
  {"numToStr/Comment.nvim", opts = {}},
  {"stevearc/dressing.nvim", opts = {}},
  {"cshuaimin/ssr.nvim"},
  {"nvim-neorg/neorg", build = ":Neorg sync-parsers", dependencies = {{"nvim-lua/plenary.nvim"}, {"laher/neorg-exec"}}, opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["external.exec"] = {}, ["core.dirman"] = {config = {workspaces = {notes = "~/notes-neorg"}, default_workspace = "notes"}}}}},
  {"gbprod/yanky.nvim", opts = {}},
  {"Olical/conjure", enabled = false},
  {"ctrlpvim/ctrlp.vim"},
  {"edgedb/edgedb-vim"},
  {"sourcegraph/sg.nvim"}
}
