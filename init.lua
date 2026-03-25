vim.opt.number = true
vim.opt.relativenumber = false

-- ======================
-- Terminal shell selection
-- ======================

local is_windows = vim.fn.has("win32") == 1
local terminal_cmd = nil

if is_windows then
  if vim.fn.executable("pwsh") == 1 then
    terminal_cmd = { "pwsh", "-NoLogo" }
  elseif vim.fn.executable("powershell") == 1 then
    terminal_cmd = { "powershell", "-NoLogo" }
  else
    terminal_cmd = { "cmd" }
  end
else
  local shell = vim.env.SHELL

  if not shell or shell == "" then
    if vim.fn.executable("zsh") == 1 then
      shell = "zsh"
    elseif vim.fn.executable("bash") == 1 then
      shell = "bash"
    else
      shell = "sh"
    end
  end

  terminal_cmd = { shell, "-l" }
end

-- ======================
-- Helpers
-- ======================

local function normalize_mode()
  local mode = vim.api.nvim_get_mode().mode

  if mode == "t" then
    vim.cmd("stopinsert")
  elseif mode == "i" then
    vim.cmd("stopinsert")
  elseif mode:find("v") then
    vim.cmd("normal! <Esc>")
  end
end

local function focus_window(win)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end
end

local function cycle_windows()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins <= 1 then
    return
  end

  local current = vim.api.nvim_get_current_win()
  local current_index = 1

  for i, win in ipairs(wins) do
    if win == current then
      current_index = i
      break
    end
  end

  local next_index = current_index + 1
  if next_index > #wins then
    next_index = 1
  end

  focus_window(wins[next_index])
end

-- ======================
-- Keymaps
-- ======================

-- move line up/down
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { silent = true })

vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true })

-- cut line / selection
vim.keymap.set("n", "<A-k>", '"+dd', { silent = true })
vim.keymap.set("v", "<A-k>", '"+d', { silent = true })

-- select current line
vim.keymap.set("n", "<A-l>", "V", { silent = true })
vim.keymap.set("v", "<A-l>", "V", { silent = true })
vim.keymap.set("i", "<A-l>", "<Esc>V", { silent = true })

-- undo / redo
vim.keymap.set("n", "<A-z>", "u", { silent = true })
vim.keymap.set("i", "<A-z>", "<Esc>ui", { silent = true })
vim.keymap.set("v", "<A-z>", "<Esc>u", { silent = true })

vim.keymap.set("n", "<A-y>", "<C-r>", { silent = true })
vim.keymap.set("i", "<A-y>", "<Esc><C-r>i", { silent = true })
vim.keymap.set("v", "<A-y>", "<Esc><C-r>", { silent = true })

-- ======================
-- Terminal
-- ======================

local function open_bottom_terminal()
  vim.cmd("botright 15split")

  local term_win = vim.api.nvim_get_current_win()
  local term_buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_win_set_buf(term_win, term_buf)
  vim.bo[term_buf].bufhidden = "hide"

  vim.fn.termopen(terminal_cmd)
  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "i", "v", "t" }, "<A-t>", function()
  normalize_mode()
  open_bottom_terminal()
end, { silent = true, desc = "Open new terminal" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })

-- ======================
-- Editor panes
-- ======================

local function open_file_picker_right()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.loop.cwd()
  end

  local entries = vim.fn.readdir(dir)
  local files = {}

  for _, name in ipairs(entries) do
    local full = dir .. "/" .. name
    if vim.fn.isdirectory(full) == 0 then
      table.insert(files, name)
    end
  end

  table.sort(files)

  vim.cmd("rightbelow vsplit")
  vim.cmd("enew")

  vim.ui.select(files, {
    prompt = "Files: " .. dir,
  }, function(choice)
    if not choice then
      return
    end

    local target = dir .. "/" .. choice
    vim.cmd("edit " .. vim.fn.fnameescape(target))
  end)
end

vim.keymap.set({ "n", "i", "v", "t" }, "<A-n>", function()
  normalize_mode()
  open_file_picker_right()
end, { silent = true, desc = "Open editor to the right" })

-- ======================
-- Window switching
-- ======================

vim.keymap.set({ "n", "i", "v", "t" }, "<A-,>", function()
  normalize_mode()
  cycle_windows()
end, { silent = true, desc = "Cycle windows" })

-- ======================
-- Comments (Alt + .)
-- ======================

local function comment_line()
  require("Comment.api").toggle.linewise.current()
end

local function comment_visual()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
  vim.schedule(function()
    vim.cmd("normal! gv")
  end)
end

local function comment_insert()
  vim.cmd("stopinsert")
  require("Comment.api").toggle.linewise.current()
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<A-.>", comment_line, { silent = true })
vim.keymap.set("v", "<A-.>", comment_visual, { silent = true })
vim.keymap.set("i", "<A-.>", comment_insert, { silent = true })

-- ======================
-- Indentation
-- ======================

vim.keymap.set("v", "<Tab>", ">gv", { silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })

vim.keymap.set("n", "<Tab>", ">>", { silent = true })
vim.keymap.set("n", "<S-Tab>", "<<", { silent = true })

-- ======================
-- Shift selection (VSCode style)
-- ======================

vim.keymap.set("n", "<S-Up>", "v<Up>")
vim.keymap.set("n", "<S-Down>", "v<Down>")
vim.keymap.set("n", "<S-Left>", "v<Left>")
vim.keymap.set("n", "<S-Right>", "v<Right>")

vim.keymap.set("i", "<S-Up>", "<Esc>v<Up>")
vim.keymap.set("i", "<S-Down>", "<Esc>v<Down>")
vim.keymap.set("i", "<S-Left>", "<Esc>v<Left>")
vim.keymap.set("i", "<S-Right>", "<Esc>v<Right>")

vim.keymap.set("v", "<S-Up>", "<Up>")
vim.keymap.set("v", "<S-Down>", "<Down>")
vim.keymap.set("v", "<S-Left>", "<Left>")
vim.keymap.set("v", "<S-Right>", "<Right>")

-- cancel selection on movement
vim.keymap.set("v", "<Up>", "<Esc><Up>")
vim.keymap.set("v", "<Down>", "<Esc><Down>")
vim.keymap.set("v", "<Left>", "<Esc><Left>")
vim.keymap.set("v", "<Right>", "<Esc><Right>")

-- ======================
-- Page scrolling
-- ======================

vim.keymap.set("n", "<PageUp>", "<C-u>")
vim.keymap.set("n", "<PageDown>", "<C-d>")

vim.keymap.set("i", "<PageUp>", "<Esc><C-u>")
vim.keymap.set("i", "<PageDown>", "<Esc><C-d>")

vim.keymap.set("v", "<PageUp>", "<C-u>")
vim.keymap.set("v", "<PageDown>", "<C-d>")

-- ======================
-- Go to line
-- ======================

local function goto_line()
  local line = vim.fn.input("Go to line: ")

  if line == nil or line == "" then
    return
  end

  local num = tonumber(line)
  if not num then
    return
  end

  local last_line = vim.api.nvim_buf_line_count(0)
  num = math.max(1, math.min(num, last_line))

  vim.api.nvim_win_set_cursor(0, { num, 0 })
  vim.cmd("normal! zz")
end

vim.keymap.set("n", "<A-g>", goto_line, { silent = true, desc = "Go to line" })
vim.keymap.set("i", "<A-g>", function()
  vim.cmd("stopinsert")
  goto_line()
end, { silent = true, desc = "Go to line" })
vim.keymap.set("v", "<A-g>", function()
  vim.cmd("normal! <Esc>")
  goto_line()
end, { silent = true, desc = "Go to line" })
vim.keymap.set("t", "<A-g>", function()
  vim.cmd("stopinsert")
  goto_line()
end, { silent = true, desc = "Go to line" })

-- ======================
-- lazy.nvim bootstrap
-- ======================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--branch=stable",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ======================
-- Plugins
-- ======================

require("lazy").setup({

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    version = "v1.8.0",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },

    config = function()
      local cmp = require("cmp")
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),

        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },

})
