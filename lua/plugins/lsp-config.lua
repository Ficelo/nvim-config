return {
  -- Mason: install language servers
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },

  -- Mason ↔ LSP bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "pyright",
        "ts_ls", -- React / TypeScript (NEW)
        "eslint",
      },
    },
  },

  -- Native Neovim 0.11 LSP config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local function on_attach(_, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end

      -- Lua
      vim.lsp.config.lua_ls = {
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      }

      -- Rust
      vim.lsp.config.rust_analyzer = {
        on_attach = on_attach,
      }

      -- Python
      vim.lsp.config.pyright = {
        on_attach = on_attach,
        settings = {
          python = {
            defaultInterpreterPath = "C:/Users/user/AppData/Local/Python/pythoncore-3.14-64/python.exe",
          },
        },
      }

      -- React / TypeScript / JavaScript
      vim.lsp.config.ts_ls = {
        on_attach = on_attach,
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
      }

      -- ESLint (optional)
      vim.lsp.config.eslint = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      }
    end,
  },
}

