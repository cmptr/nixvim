{ pkgs, ... }:

let
  pi-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "pi-nvim";
    version = "2026-04-08";
    src = pkgs.fetchFromGitHub {
      owner = "alex35mil";
      repo = "pi.nvim";
      rev = "f2219f0ce79e512b81175d3940e306a49555bca3";
      hash = "sha256-X+aW4G+jYKX1T/XPNlDMgRj0fxRQtoTzo/PuZ+z9zLI=";
    };
  };
in
{
  extraPlugins = [ pi-nvim ];

  extraConfigLua = ''
    require("pi").setup({
      layout = {
        default = "side",
        side = {
          position = "right",
          width = 80,
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>ai", function()
      vim.cmd("Pi layout=side")
    end, { desc = "Pi side" })
    vim.keymap.set({ "n", "v" }, "<leader>aI", function()
      vim.cmd("Pi layout=float")
    end, { desc = "Pi float" })
    vim.keymap.set({ "n", "v" }, "<leader>al", "<Cmd>PiToggleLayout<CR>", { desc = "Pi toggle layout" })
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<Cmd>PiContinue<CR>", { desc = "Pi continue last session" })
    vim.keymap.set({ "n", "v" }, "<leader>ar", "<Cmd>PiResume<CR>", { desc = "Pi resume session" })
    vim.keymap.set({ "n", "v" }, "<leader>am", "<Cmd>PiSendMention<CR>", { desc = "Pi mention file/selection" })
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<Cmd>PiAttention<CR>", { desc = "Pi attention" })
  '';
}
