-- deprecate 警告無効化
vim.deprecate = function() end
-- lazy.nvimをインストール
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- リーダーキー定義
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 時刻表記を日本語
-- vim.cmd [[
--   language time ja_JP
-- ]]

-- プラグイン定義
require('lazy').setup({

  -- Git 関連
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- タブ幅の自動検知
  'tpope/vim-sleuth',

  { -- LSP 設定
    'neovim/nvim-lspconfig',
    dependencies = {
      -- LSP自動インストール プラグイン
      { 'williamboman/mason.nvim', config = true },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'zapling/mason-conform.nvim' },
      -- 通知プラグイン
      -- { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      -- Lazyの開発用プラグイン
      { 'folke/lazydev.nvim' },
    },
  },
  -- アイコン表示
  { 'onsails/lspkind.nvim' },
  { -- 自動補完
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  { 'hrsh7th/cmp-omni' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'uga-rosa/cmp-dictionary' },
  { 'lukas-reineke/cmp-rg' },
  { -- 行番号にGitサインを表示
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- ステータスライン
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        -- theme = 'OceanicNext',
        component_separators = { left = '|', right = '|' },
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            colored = true, -- ファイルタイプアイコンをカラー表示
            icon_only = false, -- ファイルタイプのアイコンのみを表示
            icon = { align = 'right' }, -- ファイルタイプアイコンを右側で表示
          },
        },
        lualine_c = {
          {
            'filename',
            file_status = true,
            newfile_status = true,
            path = 4,
            shorting_target = 40,
            symbols = {
              modified = '[+]', -- ファイル変更時
              readonly = '[-]', -- 読み込み専用
              unnamed = '[No Name]', -- 名前なしバッファ
              newfile = '[New]', -- 新規ファイル
            },
          },
        },
      },
    },
  },

  { -- インデント可視化
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
    config = function()
      vim.g.indent_blankline_filetype_exclude = {
        'lspinfo',
        'checkhealth',
        'help',
        'man',
      }
    end,
  },

  -- ファジーファインダー
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  { -- telescope 向け fzf プラグイン make 必須
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- telescope 向けghq プラグイン
    'nvim-telescope/telescope-ghq.nvim',
  },

  { -- 構文解析 ハイライト
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- require 'kickstart.plugins.autoformat',
  { import = 'custom.plugins' },
}, {})

------------------------------------------------------------------------------------------------------------
-- ファイルロード
-- lua/options.lua をロード
require 'options'
-- lua/keymaps.lua をロード
require 'keymaps'
-- lua/functions.lua をロード
require 'functions'

------------------------------------------------------------------------------------------------------------
-- Setup neovim lua configuration
require('lazydev').setup()

------------------------------------------------------------------------------------------------------------
-- Yankハイライト
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

------------------------------------------------------------------------------------------------------------
-- Telescope設定
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    -- git リポジトリ検索
    git_files = {
      git_command = { 'git', 'ls-files', '--exclude-standard', '--cached', '--others' },
    },
    -- ripgrep でファイル検索
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '--glob', '!{**/.git/*,**/node_modules/*}' },
    },
  },
}

-- telescope-fzf 有効化
pcall(require('telescope').load_extension, 'fzf')
-- telescope-ghq 有効化
pcall(require('telescope').load_extension, 'ghq')

-- telescopeでプロジェクト検索
local telescope_project_find = function()
  local opts = {
    prompt_title = 'Search Project',
    preview = true,
    hidden = true,
    no_ignore = false,
  }

  -- git 検索をデフォルトで利用
  local ok = pcall(require('telescope.builtin').git_files, opts)

  -- git 検索が利用できなければ、ripgrepで検索
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

-- 履歴検索
vim.keymap.set('n', '<Leader>m', require('telescope.builtin').oldfiles, { desc = '[m] Find recently opened files' })

-- バッファ検索
vim.keymap.set('n', '<Leader>b', require('telescope.builtin').buffers, { desc = '[b] Find existing buffers' })

-- カレントバッファ検索
vim.keymap.set('n', '<Leader>/', function()
  -- レイアウト設定
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 0,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- プロジェクト検索
vim.keymap.set('n', '<Leader>p', telescope_project_find, { desc = 'Search [P]roject' })
-- Git Statusで差分があるファイルを検索
vim.keymap.set('n', '<Leader>f', require('telescope.builtin').git_status, { desc = 'Search Git [F]iles Status' })

-- リアルタイムGrep
vim.keymap.set('n', '<Leader>r', require('telescope.builtin').live_grep, { desc = 'Search by g[R]ep' })
vim.keymap.set('n', '<Leader>d', require('telescope.builtin').diagnostics, { desc = 'Search [D]iagnostics' })
-- ghq検索
vim.keymap.set('n', '<Leader>g', '<CMD>Telescope ghq list<CR>', { desc = 'Search [G]hq sources' })
-- yank検索
vim.keymap.set('n', '@', require('telescope.builtin').registers)
vim.keymap.set('i', '<C-r>', require('telescope.builtin').registers)

-- ripgrepでファイル検索
-- vim.keymap.set('n', '<Leader>o', require('telescope.builtin').find_files, { desc = 'Search [O]pen File List' })
-- ワード検索
-- vim.keymap.set('n', '<Leader>w', require('telescope.builtin').grep_string, { desc = 'Search current [W]ord' })
-- help検索
-- vim.keymap.set('n', ',h', require('telescope.builtin').help_tags, { desc = 'Search H[e]lp' })

------------------------------------------------------------------------------------------------------------
-- Treesitter設定
require('nvim-treesitter.configs').setup {
  -- treesitterでインストールしたい言語
  ensure_installed = { 'terraform', 'bash', 'make', 'json', 'css', 'go', 'lua', 'python', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- 未インストール言語を自動インストールするか
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- -- テキストオブジェクトへの自動前方ジャンプ機能（targets.vimプラグインと同様の動作）
      keymaps = {
        -- textobjects.scmで定義されたキャプチャグループを使用できる
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- C-o, C-i で利用できる、ジャンプリスト履歴にジャンプを追加するか
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

------------------------------------------------------------------------------------------------------------
-- 診断機能（エラー・警告など）のキーマップ設定
vim.keymap.set('n', '<S-F8>', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<F8>', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' }) -- VSCode like keybind
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

------------------------------------------------------------------------------------------------------------
-- LSP 設定
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<Leader>n', vim.lsp.buf.rename, 'Re[N]ame')
  nmap('<Leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  vim.diagnostic.config {
    virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
    signs = { severity = { min = vim.diagnostic.severity.ERROR } },
    underline = { severity = { min = vim.diagnostic.severity.ERROR } },
  }
  -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
  vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float)

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  -- nmap('<Leader>f', vim.lsp.buf.format, 'Format')
  -- nmap(',D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  -- nmap(',ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  -- nmap(',ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- 使用頻度の低いLSP機能
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap(',wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap(',wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap(',wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })
end

------------------------------------------------------------------------------------------------------------
-- Mason と LSP サーバーの自動インストール設定
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'
local servers = {
  gopls = {},
  pylsp = {
    plugins = {
      autopep8 = { enabled = false },
      pycodestyle = { enabled = false },
      flake8 = { -- linterのみ有効
        enabled = true,
        maxLineLength = 200,
      },
    },
  },
  -- rust_analyzer = {},
  terraformls = {},
  vtsls = {},
  -- denols = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

------------------------------------------------------------------------------------------------------------
-- lspconfig 設定
local lspconfig = require 'lspconfig'

-- vtsls の設定
lspconfig.vtsls.setup {
  root_dir = lspconfig.util.root_pattern 'package.json',
}

-- tflint, terraform-lsでエラーが出る対策
local disable_semantic = function(client)
  client.server_capabilities.semanticTokensProvider = nil
end

-- terraform-ls
require('lspconfig').terraformls.setup {
  on_init = disable_semantic,
}

-- denols の設定
-- lspconfig.denols.setup({
--   root_dir = lspconfig.util.root_pattern("deno.json"),
--   init_options = {
--     lint = true,
--     unstable = true,
--     suggest = {
--       imports = {
--         hosts = {
--           ["https://deno.land"] = true,
--           ["https://cdn.nest.land"] = true,
--           ["https://crux.land"] = true,
--         },
--       },
--     },
--   },
-- })
--

-- mason-lspconfigが管理するLSPサーバーそれぞれに対して、この関数が自動実行される
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup { -- 各サーバーに共通設定を自動適用
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}
-- mason-conform設定（conformで設定されたフォーマッターを自動インストール）
require('mason-conform').setup {
  -- 自動インストールを有効にする
  -- ignore_install = {} -- 特定のフォーマッターをスキップしたい場合
}
------------------------------------------------------------------------------------------------------------
-- lspkind設定 - アイコンと表示モードを設定して補完メニューに絵文字アイコンを追加
require('lspkind').init {
  mode = 'symbol_text',
  preset = 'codicons',
  symbol_map = {
    Text = '󰉿',
    Method = '󰆧',
    Function = '󰊕',
    Constructor = '',
    Field = '󰜢',
    Variable = '󰀫',
    Class = '󰠱',
    Interface = '',
    Module = '',
    Property = '󰜢',
    Unit = '󰑭',
    Value = '󰎠',
    Enum = '',
    Keyword = '󰌋',
    Snippet = '',
    Color = '󰏘',
    File = '󰈙',
    Reference = '󰈇',
    Folder = '󰉋',
    EnumMember = '',
    Constant = '󰏿',
    Struct = '󰙅',
    Event = '',
    Operator = '󰆕',
    TypeParameter = '',
  },
}

------------------------------------------------------------------------------------------------------------
-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

luasnip.config.setup {}

require('cmp_dictionary').setup {
  paths = { '/usr/share/dict/words' },
  exact_length = 2,
}
vim.api.nvim_set_hl(0, 'CmpItemMenu', { link = 'CmpItemAbbrDeprecatedDefault', default = true })

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
  },
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = lspkind.cmp_format {
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      show_labelDetails = true,
      before = function(entry, item)
        local menu_icon = {
          nvim_lsp = '[LSP]',
          luasnip = '[SNIP]',
          buffer = '[BUFF]',
          path = '[PATH]',
          rg = '[Rg]',
          dictionary = '[DICT]',
        }

        item.menu = menu_icon[entry.source.name]
        return item
      end,
    },
  },
  mapping = cmp.mapping.preset.insert {
    -- ['<S-Space>'] = cmp.mapping.complete {},
    ['<C-_>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        -- cmp.complete()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Down>', true, true, true), 'n', true)
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Up>', true, true, true), 'n', true)
      end
    end, { 'i', 's' }),
    ['<S-tab>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'rg', keyword_length = 2 },
    { name = 'dictionary', keyword_length = 2 },
    {
      name = 'omni',
      option = {
        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
      },
    },
  },
}

if vim.g.neovide then
  vim.fn.chdir(vim.fn.expand '~/docs/doc')

  -- Neovide-specific settings
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00

  -- Neovide-specific colorscheme (optional)
  vim.cmd 'colorscheme everforest'
end
