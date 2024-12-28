-- Ensure you have the Catppuccin theme plugin installed
-- Add the following to your lazy.nvim setup
return
{
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,  -- Load the plugin immediately
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",  -- Use "latte" as the base flavor
      -- color_overrides = {
        -- latte = {
          -- base = "#1E1E2E",  -- Mocha background (replace latte's background)
          -- mantle = "#1E1E2E", -- Mantle is usually close to the base color
          -- crust = "#181825",  -- Crust color
          -- text = "#D9E0EE",   -- Mocha's text color
          -- subtext1 = "#BAC2DE", -- Mocha's subtext1
          -- subtext0 = "#A6ADC8", -- Mocha's subtext0
          -- overlay2 = "#C3BAC6", -- Mocha's overlay2
          -- overlay1 = "#988BA2", -- Mocha's overlay1
          -- overlay0 = "#6E6C7E", -- Mocha's overlay0
        -- },
      --},
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}

-- This snippet assumes you're using lazy.nvim to manage your plugins.

