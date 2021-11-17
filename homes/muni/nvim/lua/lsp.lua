local lspconfig = require'lspconfig'

local lsp_status = require('lsp-status')
lsp_status.config {
    indicator_errors = 'X',
    indicator_warnings = '!',
    indicator_info = 'i',
    indicator_hint = '?',
    indicator_ok = '^o^',
    indicator_separator = ' ',
    component_separator = '  ',
    status_symbol = '',
}
lsp_status.register_progress()

function on_lsp_attach(client)
    lsp_status.on_attach(client)
end

-- Enable completion
local cmp = require'cmp'
cmp.setup {
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    documentation = {
        border = { '', '' ,'', ' ', '', '', '', ' ' },
        maxwidth = 120,
        minwidth = 60,
        maxheight = math.floor(vim.o.lines * 0.3),
        minheight = 1,
    };
    mapping = {
        ['<c-u>'] = cmp.mapping.scroll_docs(-3),
        ['<c-d>'] = cmp.mapping.scroll_docs(3),
        ['<c-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<c-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<c-l>'] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
        ['<c-q>'] = cmp.mapping.close(),
        -- ['<c-y>'] = cmp.config.disable,
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    sources = {
        { name = 'path' },
        { name = 'vsnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'calc' },
        { name = 'nvim_lua' },
    },
}

-- Enable language servers

local capabilities = require('cmp_nvim_lsp').update_capabilities(lsp_status.capabilities)
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   }
-- }

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
    capabilities = capabilities
})

lspconfig.vuels.setup{}
lspconfig.tsserver.setup{}
lspconfig.intelephense.setup{}

lspconfig.html.setup {
  capabilities = capabilities,
}

vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

