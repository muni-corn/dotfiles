local lspconfig = require'lspconfig'

local lsp_status = require('lsp-status')
lsp_status.config {
    indicator_errors = 'X',
    indicator_warnings = '!',
    indicator_info = 'i',
    indicator_hint = '?',
    indicator_ok = 'All good!',
    indicator_separator = ' ',
    component_separator = '  ',
    status_symbol = '',
}
lsp_status.register_progress()

function on_lsp_attach(client)
    lsp_status.on_attach(client)
end

-- Enable completion

require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
        border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    };

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
        ultisnips = true;
        luasnip = true;
    };
}

-- Enable language servers

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

lspconfig.rust_analyzer.setup({
    on_attach = on_lsp_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
            },
            updates = { channel = "stable" },
            notifications = { cargoTomlNotFound = false },
            checkOnSave = { 
                command = "clippy",
                extraArgs = "--tests",
            },
            callInfo = { full = true },
            inlayHints = { chainingHints = true },
            procMacro = { enable = true },
            diagnostics = { disabled = { "unresolved-proc-macro", "unresolved-macro-call", "macro-error" } },
        }
    },
    capabilities = lsp_status.capabilities
})

lspconfig.vuels.setup{}
lspconfig.tsserver.setup{}
lspconfig.intelephense.setup{}

lspconfig.html.setup {
  capabilities = capabilities,
}

vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

