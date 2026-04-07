{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      friendly-snippets

      # C/C++ support
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-vsnip
      vim-vsnip
      lspsaga-nvim

      # ナイス ui!
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons

      # Help tools
      trouble-nvim
      telescope-nvim
      which-key-nvim
      symbols-outline-nvim

      # Visuals
      indent-blankline-nvim
      gitsigns-nvim

      nvim-autopairs
      vim-nix

      vim-cmake
      cmake-tools-nvim
      plenary-nvim
      tokyonight-nvim

      vim-visual-multi
      comment-nvim
      minimap-vim
    ];

    extraConfig = ''
      lua << EOF

      vim.o.syntax       = "on"
      vim.o.number       = true
      vim.o.relativenumber = false
      vim.o.tabstop      = 4
      vim.o.shiftwidth   = 4
      vim.o.expandtab    = true
      vim.o.wrap         = false
      vim.o.scrolloff    = 8
      vim.o.signcolumn   = "yes"
      vim.o.cursorline   = true
      vim.o.termguicolors = true
      vim.o.splitright   = true
      vim.o.splitbelow   = true

      vim.o.guifont = "JetBrainsMono Nerd Font:h12"
      vim.cmd("colorscheme tokyonight-storm")

      vim.g.clipboard = {
        name = 'wl-clipboard',
        copy  = { ['+'] = 'wl-copy',  ['*'] = 'wl-copy'  },
        paste = { ['+'] = 'wl-paste', ['*'] = 'wl-paste' },
        cache_enabled = 1,
      }

      if vim.loop.os_uname().sysname == "Darwin" then
        vim.g.clipboard = {
          name  = 'unnamedplus',
          copy  = { ['+'] = 'pbcopy',  ['*'] = 'pbcopy'  },
          paste = { ['+'] = 'pbpaste', ['*'] = 'pbpaste' },
          cache_enabled = 1,
        }
      end

      if vim.g.vscode then
        vim.o.clipboard = 'unnamedplus'
      else
        local map  = vim.keymap.set
        local opts = { noremap = true, silent = true }

        -- File save
        map('n', '<C-s>', '<cmd>w<CR>',  opts)
        map('i', '<C-s>', '<Esc><cmd>w<CR>', opts)

        -- Close buffer (like Ctrl+W in VSCode)
        map('n', '<C-w>', '<cmd>bd<CR>', opts)

        -- Open file explorer (like Ctrl+B / Explorer sidebar in VSCode)
        map('n', '<C-b>', '<cmd>NvimTreeToggle<CR>', opts)

        -- Quick file open (like Ctrl+P in VSCode)
        map('n', '<C-p>', '<cmd>Telescope find_files<CR>', opts)

        -- Search in files (like Ctrl+Shift+F in VSCode)
        map('n', '<C-f>', '<cmd>Telescope live_grep<CR>', opts)

        -- Go to definition (like F12 in VSCode)
        map('n', '<F12>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

        -- Peek definition (like Alt+F12 in VSCode)
        map('n', '<A-F12>', '<cmd>Lspsaga peek_definition<CR>', opts)

        -- Rename symbol (like F2 in VSCode)
        map('n', '<F2>', '<cmd>Lspsaga rename<CR>', opts)

        -- Quick fix / code actions (like Ctrl+. in VSCode)
        map('n', '<C-.>', '<cmd>Lspsaga code_action<CR>', opts)
        map('v', '<C-.>', '<cmd>Lspsaga code_action<CR>', opts)

        -- Hover docs (like hovering in VSCode)
        map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)

        -- Show diagnostics (like Problems panel in VSCode)
        map('n', '<C-`>', '<cmd>TroubleToggle<CR>', opts)

        -- Navigate diagnostics (like F8 in VSCode)
        map('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
        map('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)

        -- Comment toggle (like Ctrl+/ in VSCode)
        map('n', '<C-/>', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts)
        map('v', '<C-/>', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)

        -- Split editor (like Ctrl+\ in VSCode)
        map('n', '<C-\\>', '<cmd>vsplit<CR>', opts)

        -- Switch between splits (like Ctrl+1/2/3)
        map('n', '<C-1>', '<C-w>h', opts)
        map('n', '<C-2>', '<C-w>l', opts)

        -- Telescope extras
        map('n', '<leader>fb', '<cmd>Telescope buffers<CR>',   opts)
        map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
        map('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', opts)

        local lspconfig = require('lspconfig')

        lspconfig.clangd.setup {
          on_attach = function(client, bufnr)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
              vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = { prefix = "●" },
                signs        = true,
                underline    = true,
                update_in_insert = true,
              }
            )
          end
        }

        lspconfig.cmake.setup { cmd = { "cmake-language-server" } }

        lspconfig.nil_ls.setup {
          settings = {
            ['nil'] = {
              formatting = { command = { "alejandra" } }
            }
          }
        }

        lspconfig.pyright.setup {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer   = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = true })
              end,
            })
          end
        }

        require('lspsaga').setup({
          ui = {
            border       = 'rounded',
            winblend     = 0,
            colors = { normal_bg = '#022731' },
          },
          lightbulb = {
            enable         = true,
            sign           = true,
            virtual_text   = true,
          },
          diagnostic = {
            show_code_action = true,
            show_source      = true,
            jump_num_shortcut = true,
          },
        })

        local cmp = require'cmp'
        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>']     = cmp.mapping.scroll_docs(-4),
            ['<C-f>']     = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>']     = cmp.mapping.abort(),
            ['<Tab>']     = cmp.mapping.select_next_item(),
            ['<S-Tab>']   = cmp.mapping.select_prev_item(),
            ['<CR>']      = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
          }, {
            { name = 'buffer' },
            { name = 'path' },
          }),
          -- VSCode-style bordered completion menu
          window = {
            completion    = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          formatting = {
            format = function(entry, vim_item)
              -- Show source name in menu
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                vsnip    = "[Snippet]",
                buffer   = "[Buffer]",
                path     = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          },
        })

        require('lualine').setup({
          options = {
            theme = 'tokyonight',
            globalstatus = true,
          },
        })

        require('nvim-tree').setup({
          view = {
            width  = 30,
            side   = 'left',
          },
          renderer = {
            icons = {
              show = {
                file         = true,
                folder       = true,
                folder_arrow = true,
                git          = true,
              },
            },
          },
          filters = { dotfiles = false },
          git     = { enable = true },
          actions = {
            open_file = { quit_on_open = false },
          },
        })

        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            require("nvim-tree.api").tree.open()
            vim.cmd("wincmd p") -- keep focus on editor, not tree
          end,
        })

        require("bufferline").setup({
          options = {
            mode           = "buffers",
            diagnostics    = "nvim_lsp",
            separator_style = "slant",
            show_buffer_close_icons = true,
            show_close_icon         = true,
            color_icons             = true,
          },
        })

        map('n', '<C-Tab>',   '<cmd>BufferLineCycleNext<CR>', opts)
        map('n', '<C-S-Tab>', '<cmd>BufferLineCyclePrev<CR>', opts)

        require("cmake-tools").setup({})
        require("trouble").setup()
        require("symbols-outline").setup()
        require("ibl").setup()
        require("gitsigns").setup({
          current_line_blame = true,
        })
        require("which-key").setup()
        require("telescope").setup{}
        require("nvim-autopairs").setup()
        require("Comment").setup()

      end
      EOF
    '';
  };
}
