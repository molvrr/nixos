local opts = {
  autoindent = true,
  backup = false,
  -- clipboard = "unnamedplus",
  completeopt = "menu,menuone,noselect",
  expandtab = true,
  fillchars = "eob: ",
  hlsearch = false,
  ignorecase = true,
  mouse = "",
  number = true,
  relativenumber = true,
  shell = "bash",
  shiftwidth = 2,
  smartcase = true,
  smartindent = true,
  spell = false,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  syntax = "off",
  tabstop = 2,
  undofile = true,
  updatetime = 700,
  wrap = false
}

local globals = {
  mapleader = " ",
  maplocalleader = "\\",
  omni_sql_no_default_maps = true,
  zig_fmt_autosave = false,
  neovide_cursor_vfx_mode = 'wireframe',
  ['conjure#filetypes'] = {'fennel', 'jannet', 'hy', 'julia', 'racket', 'scheme', 'lua', 'lisp', 'python', 'sql'},
  ['conjure#client#scheme#stdio#command'] = "petite",
  ['conjure#client#scheme#stdio#prompt_pattern'] = "> $?"
}

local extensions = {
  koka = '*.kk',
  roc = '*.roc',
  ocaml = '*.mlx'
}

vim.diagnostic.config { virtual_text = true }

for key, value in pairs(opts) do
  vim.opt[key] = value
end

for key, value in pairs(globals) do
  vim.g[key] = value
end

for filetype, extension in pairs(extensions) do
  vim.api.nvim_create_autocmd({'BufEnter'}, {
    pattern = extension,
    callback = function()
      vim.o.ft = filetype
    end
  })
end
