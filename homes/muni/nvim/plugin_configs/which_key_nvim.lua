local which_key = require("which-key")
which_key.setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  triggers_blacklist = {
      i = { "f", "j", "<c-j>", "<c-h", "{", "[", "(" },
  }
}

-- telescope functions
local telescope_fd = [[<cmd>lua require'telescope.builtin'.fd()<cr>]]
local telescope_builtin = [[<cmd>lua require'telescope.builtin'.builtin()<cr>]]
local telescope_buffers = [[<cmd>lua require'telescope.builtin'.buffers()<cr>]]
local telescope_spell_suggest = [[<cmd>lua require'telescope.builtin'.spell_suggest()<cr>]]
local telescope_git_switch_branch = [[<cmd>lua require'telescope.builtin'.git_branches()<cr>]]
local telescope_git_commits = [[<cmd>lua require'telescope.builtin'.git_commits()<cr>]]
local telescope_git_stash = [[<cmd>lua require'telescope.builtin'.git_stash()<cr>]]
local telescope_git_status = [[<cmd>lua require'telescope.builtin'.git_status()<cr>]]
local telescope_lsp_actions = [[<cmd>lua require'telescope.builtin'.lsp_code_actions()<cr>]]
local telescope_lsp_document_diagnostics = [[<cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<cr>]]
local telescope_lsp_workspace_diagnostics = [[<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>]]
local telescope_lsp_document_symbols = [[<cmd>lua require'telescope.builtin'.lsp_document_symbols()<cr>]]
local telescope_lsp_workspace_symbols = [[<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>]]
local telescope_lsp_definition = [[<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>]]
local telescope_lsp_references = [[<cmd>lua require'telescope.builtin'.lsp_references()<cr>]]
local telescope_lsp_implementations = [[<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>]]
local telescope_ripgrep = [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]]

which_key.register({
    ["<c-p>"] = { telescope_fd, "find file" },

    -- leader bindings
    ["<leader>"] = {
        a = "Emmet",

        b = { telescope_buffers, "buffers" },

        -- quickfix list
        c = {
            name = "quickfix ...",
            N = { "<cmd>cnfile<cr>", "next file" },
            P = { "<cmd>cpfile<cr>", "previous file" },
            n = { "<cmd>cnext<cr>", "next" },
            p = { "<cmd>cprev<cr>", "previous" },
        },

        cd = { ":cd %:p:h<cr>:pwd<cr>", },

        -- diffs
        d = {
            name = "diff ...",
            g = { "<cmd>diffget<cr>", "get" },
            o = { "<cmd>diffoff<cr>:set noscrollbind<cr>:set nocursorbind<cr>", "off" },
            p = { "<cmd>diffput<cr>", "put" },
            t = { "<cmd>diffthis<cr>", "on" },
        },

        e = { "<cmd>Lex<cr>", "explore files" },

        -- telescope functions
        f = {
            name = "find ...",
            d = { telescope_fd, "files" },
            f = { telescope_builtin, "telescopes" },
            s = { telescope_git_switch_branch, "git branch" },
            g = { telescope_git_status, "git status" },
            t = { telescope_git_stash, "git stash" },
            c = { telescope_git_commits, "git commits" },
            a = { telescope_lsp_actions, "lsp actions" },
            e = { telescope_lsp_document_diagnostics, "diagnostics" },
            E = { telescope_lsp_workspace_diagnostics, "all diagnostics" },
            y = { telescope_lsp_document_symbols, "symbols" },
            Y = { telescope_lsp_workspace_symbols, "all symbols" },
            r = { telescope_ripgrep, "ripgrep" },
            z = { telescope_spell_suggest, "spellings" },
            i = { telescope_lsp_implementations, "implementations" },
        },

        gg = { telescope_ripgrep, "ripgrep" },

        H = { "<c-w>H", "move window left" },
        h = { "<c-w>h", "focus window left" },
        J = { "<c-w>J", "move window down" },
        j = { "<c-w>j", "focus window down" },
        K = { "<c-w>K", "move window up" },
        k = { "<c-w>k", "focus window up" },
        L = { "<c-w>L", "move window right" },
        l = { "<c-w>l", "focus window right" },

        -- location list
        m = {
            name = "location list ...",
            N = { "<cmd>lnfile<cr>", "next file" },
            P = { "<cmd>lpfile<cr>", "previous file" },
            n = { "<cmd>lnext<cr>", "next" },
            p = { "<cmd>lprev<cr>", "previous" },
        },

        p = {
            name = "pandoc ...",
            w = { "<cmd>pwd<cr>", "pwd" },
            p = { "<cmd>!pandoc --citeproc \"%\" -o \"%.pdf\"<cr>", "pdf" },
            d = { "<cmd>!pandoc --citeproc \"%\" -o \"%.docx\"<cr>", "docx" },
            m = { "<cmd>!pandoc --citeproc \"%\" -o \"%.md\"<cr>", "markdown" },
            h = { "<cmd>!pandoc --citeproc \"%\" -o \"%.html\"<cr>", "html" },
        },

        q = { "<cmd>q<cr>", "close window" },

        s = {
            name = "split ...",
            c = { "<cmd>sp<cr>", "copy" },
            g = { "<cmd>new<cr>"..telescope_ripgrep, "ripgrep" },
            n = { "<cmd>new<cr>", "new" },
            s = { "<cmd>new<cr>"..telescope_fd, "find file" },
            x = { ":sp<cr>:terminal<cr>i", "terminal" },
        },

        t = {
            name = "tab ...",
            g = { "<cmd>tabnew<cr>"..telescope_ripgrep, "ripgrep" },
            n = { "<cmd>tabnew<cr>", "new" },
            q = { "<cmd>tabc<cr>", "close" },
            t = { "<cmd>tabnew<cr>"..telescope_fd, "find file" },
            x = { ":tabnew<cr>:terminal<cr>i", "terminal" },
        },

        v = {
            name = "vertical ...",
            c = { "<cmd>vs<cr>", "copy" },
            g = { "<cmd>vnew<cr>"..telescope_ripgrep, "ripgrep" },
            n = { "<cmd>vnew<cr>", "new" },
            v = { "<cmd>vnew<cr>"..telescope_fd, "find file" },
            x = { "<cmd>vs<cr><cmd>terminal<cr>i", "terminal" },
        },

        w = { "<cmd>set wrap!<cr>", "toggle wrap" },

        -- lsp
        x = {
            name = "lsp ...",
            a = { telescope_lsp_actions, "actions" },
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename" },
            d = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "declarations" },
            f = { telescope_lsp_references, "references" },
            i = { telescope_lsp_implementations, "implementations" },
            n = { "<cmd>lua vim.lsp.diagnostic.goto_next({ enable_popup = false })<cr>", "next diagnostic" },
            p = { "<cmd>lua vim.lsp.diagnostic.goto_prev({ enable_popup = false })<cr>", "last diagnostic" },
            x = { "<cmd>terminal<cr>i", "open terminal" },
        },

        ["/"] = { telescope_lsp_definition, "lsp defintion" },
        ["?"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "lsp hover" },
    },

    -- hop
    ["<bslash>"] = {
        name = "hop ...",
        F = { "<cmd>HopChar1<cr>", "char", noremap = true },
        f = { "<cmd>HopChar1<cr>", "char", noremap = true },
        j = { "<cmd>HopLine<cr>", "line", noremap = true },
        k = { "<cmd>HopLine<cr>", "line", noremap = true },
        n = { "<cmd>HopPattern<cr>", "pattern", noremap = true },
        w = { "<cmd>HopWord<cr>", "word", noremap = true },
        ["1"] = { "<cmd>HopChar1<cr>", "char", noremap = true },
        ["2"] = { "<cmd>HopChar2<cr>", "2-char", noremap = true },
    },
})
