return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "mason-org/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    "b0o/schemastore.nvim",
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")
    local util = require("lspconfig/util")
    local navbuddy = require("nvim-navbuddy")
    local nvim_navic = require("nvim-navic")

    -- import mason_lspconfig plugin
    local schemastore = require("schemastore")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    -- local attach = lspconfig.on_attach
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    }
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
        text_hl = {
          [vim.diagnostic.severity.ERROR] = "Error",
          [vim.diagnostic.severity.WARN] = "Warn",
          [vim.diagnostic.severity.HINT] = "Hint",
          [vim.diagnostic.severity.INFO] = "Info",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
      underline = true,
      virtual_text = true,
    })

    -- mason_lspconfig.setup_handlers({
    --   -- default handler for installed servers
    --   function(server_name)
    --     vim.lsp.enable(server_name)
    --   end,
    -- })
    local on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        nvim_navic.attach(client, bufnr)
        navbuddy.attach(client, bufnr)
      end
    end
    vim.lsp.config("terraformls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config("ansiblels", {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "yaml.ansible", "yaml" },
      root_dir = lspconfig.util.root_pattern("roles", "playbooks", "inventory", "ansible", "*ansible.cfg"),
      settings = {
        ansible = {
          ansible = {
            path = "ansible",
          },
          executionEnvironment = {
            enabled = false,
          },
          python = {
            interpreterPath = "python",
          },
          validation = {
            enabled = true,
            lint = {
              enabled = true,
              path = "ansible-lint",
            },
          },
        },
      },
    })

    vim.lsp.config("yamlls", {
      on_attach = on_attach,
      settings = {
        yaml = {
          schemastore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          -- schemas = schemastore.yaml.schemas(),
          schemas = vim.tbl_deep_extend("force", schemastore.yaml.schemas(), {
            [require("kubernetes").yamlls_schema()] = {
              "k8s-*.yaml",
              "k8s-*/**/*.yaml",
              "!kustomization.{yml,yaml}",
              "!*-values.{yml,yaml}",
            },
            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
            ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = {
              "k8s-*/**/application.{yml,yaml}",
              "k8s-*/**/app-of-apps.{yml,yaml}",
            },
            ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/applicationset_v1alpha1.json"] = {
              "k8s-*/**/*-appset.{yml,yaml}",
            },
            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
            ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
          }),
        },
      },
    })

    -- configure typescript language server
    vim.lsp.config("ts_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
      -- on_attach = function(client, bufnr) end,
    })

    -- configure svelte server
    vim.lsp.config("svelte", {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          nvim_navic.attach(client, bufnr)
          navbuddy.attach(client, bufnr)
        end
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- configure graphql language server
    vim.lsp.config("graphql", {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- configure emmet language server
    vim.lsp.config("emmet_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    -- configure lua server (with special settings)
    vim.lsp.config("lua_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    --- configure json language server for config and json files
    vim.lsp.config("jsonls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- configure gopls for go
    vim.lsp.config("gopls", {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })

    -- configure sqlls for sql
    vim.lsp.config("sqlls", {
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
