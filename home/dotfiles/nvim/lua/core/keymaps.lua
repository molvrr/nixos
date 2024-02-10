local config_path = vim.fn.stdpath('config')
local builtin = require('telescope.builtin')
local find_files = builtin.find_files
local live_grep = builtin.live_grep
local help_tags = builtin.help_tags
local themes = require('telescope.themes')

local normal_map = function(lhs, rhs, fun, opts)
  local opts = opts or {silent = true}

  vim.keymap.set('n', lhs, rhs, fun, opts)
end

vim.keymap.set("n", "<Leader>f", function() find_files(themes.get_dropdown {previewer = false}) end)
vim.keymap.set("n", "<Leader>/", function() live_grep(themes.get_dropdown {previewer = false}) end)
vim.keymap.set("n", "<Leader>h", function() help_tags(themes.get_dropdown {previewer = false}) end)
vim.keymap.set("n", "<Leader>e", function() require('oil').open_float() end)

vim.keymap.set("n", "<C-e>", function()
  local harpoon = require('harpoon')
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<Leader>a", function()
  local harpoon = require('harpoon')
  harpoon:list():append()
end)

for _, i in ipairs({1, 2, 3, 4, 5}) do
  vim.keymap.set("n", "<Leader>" .. tostring(i), function()
    local harpoon = require('harpoon')
    harpoon:list():select(i)
  end)
end

vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
