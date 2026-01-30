return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "andymass/vim-matchup",
  },
  config = function()
    require("plugins.treesitter")
  end,
}