return {
  {"nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_b = {{"branch", icon = "\239\144\152"}, "diff", "diagnostics"},
      lualine_c = {{"filename", path = 1}}, lualine_x = {"filetype"}}}}
}
