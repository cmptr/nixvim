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
    local pi = require("pi")

    pi.setup({
      layout = {
        default = "side",
        side = {
          position = "right",
          width = 80,
          panels = {
            history = { winbar = true },
            prompt = { winbar = true },
            attachments = { winbar = true },
          },
        },
        float = {
          width = 0.6,
          height = 0.8,
          border = "rounded",
        },
      },
      show_thinking = false,
      expand_startup_details = true,
      attention = {
        auto_open_on_prompt_focus = true,
        notify_on_completion = true,
      },
      dialog = {
        border = "rounded",
        max_width = 0.8,
        max_height = 0.8,
        indicator = "▸",
      },
      diff = {
        context = {
          base = nil,
          step = 5,
        },
        keys = {
          accept = "<leader>da",
          reject = "<leader>dr",
          expand_context = "<leader>de",
          shrink_context = "<leader>ds",
        },
      },
      zen = {
        width = 100,
        keys = {
          toggle = { "<M-z>", modes = { "n", "i" } },
          exit = {
            { "<Esc>", modes = "n" },
          },
        },
      },
      statusline = {
        layout = {
          left = { "context", "  ", "attention" },
          right = { "model", "   ", "thinking" },
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
    vim.keymap.set("n", "<leader>an", "<Cmd>PiNewSession<CR>", { desc = "Pi new session" })
    vim.keymap.set("n", "<leader>aN", "<Cmd>PiSessionName<CR>", { desc = "Pi session name" })
    vim.keymap.set("n", "<leader>ax", "<Cmd>PiAbort<CR>", { desc = "Pi abort" })
    vim.keymap.set("n", "<leader>aX", "<Cmd>PiStop<CR>", { desc = "Pi stop" })
    vim.keymap.set("n", "<leader>at", "<Cmd>PiToggleThinking<CR>", { desc = "Pi toggle thinking" })
    vim.keymap.set("n", "<leader>aT", "<Cmd>PiSelectThinking<CR>", { desc = "Pi select thinking" })
    vim.keymap.set("n", "<leader>ao", "<Cmd>PiCycleModel<CR>", { desc = "Pi cycle model" })
    vim.keymap.set("n", "<leader>aO", "<Cmd>PiSelectModel<CR>", { desc = "Pi select model" })
    vim.keymap.set("n", "<leader>az", "<Cmd>PiCompact<CR>", { desc = "Pi compact" })
    vim.keymap.set("n", "<leader>as", "<Cmd>PiToggleStartupDetails<CR>", { desc = "Pi startup details" })
    vim.keymap.set("n", "<leader>ad", "<Cmd>PiToggleDebug<CR>", { desc = "Pi toggle debug" })

    local group = vim.api.nvim_create_augroup("pi-local-keymaps", { clear = true })

    local function map(buf, lhs, rhs, modes)
      vim.keymap.set(modes or { "n", "i", "v" }, lhs, rhs, { buffer = buf })
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "pi-chat-history", "pi-chat-prompt", "pi-chat-attachments" },
      callback = function(event)
        map(event.buf, "<C-q>", "<Cmd>PiToggleChat<CR>")
        map(event.buf, "<M-c>", "<Cmd>PiAbort<CR>")
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "pi-chat-history",
      callback = function(event)
        map(event.buf, "<S-Down>", pi.focus_chat_prompt)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "pi-chat-prompt",
      callback = function(event)
        map(event.buf, "<S-Up>", pi.focus_chat_history)
        map(event.buf, "<S-Down>", pi.focus_chat_attachments)
        map(event.buf, "<C-Up>", function()
          pi.scroll_chat_history("up", 2)
        end)
        map(event.buf, "<C-Down>", function()
          pi.scroll_chat_history("down", 2)
        end)
        map(event.buf, "<M-m>", pi.cycle_model)
        map(event.buf, "<M-M>", pi.select_model)
        map(event.buf, "<M-t>", pi.cycle_thinking_level)
        map(event.buf, "<M-T>", pi.select_thinking_level)
        map(event.buf, "<M-n>", pi.new_session)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "pi-chat-attachments",
      callback = function(event)
        map(event.buf, "<S-Up>", pi.focus_chat_prompt)
      end,
    })
  '';
}
