local map = vim.api.nvim_set_keymap

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
map('n', "<c-p>", telescope_fd, { noremap = true, silent = true })
map('n', "<leader>fd", telescope_fd, { noremap = true, silent = true })
map('n', "<leader>ff", telescope_builtin, { noremap = true, silent = true })
map('n', "<leader>fs", telescope_git_switch_branch, { noremap = true, silent = true })
map('n', "<leader>fg", telescope_git_status, { noremap = true, silent = true })
map('n', "<leader>ft", telescope_git_stash, { noremap = true, silent = true })
map('n', "<leader>fc", telescope_git_commits, { noremap = true, silent = true })
map('n', "<leader>fa", telescope_lsp_actions, { noremap = true, silent = true })
map('n', "<leader>fe", telescope_lsp_document_diagnostics, { noremap = true, silent = true })
map('n', "<leader>fE", telescope_lsp_workspace_diagnostics, { noremap = true, silent = true })
map('n', "<leader>fy", telescope_lsp_document_symbols, { noremap = true, silent = true })
map('n', "<leader>fY", telescope_lsp_workspace_symbols, { noremap = true, silent = true })
map('n', "<leader>fr", telescope_ripgrep, { noremap = true, silent = true })
map('n', "<leader>fz", telescope_spell_suggest, { noremap = true, silent = true })
map('n', "<leader>fi", telescope_lsp_implementations, { noremap = true, silent = true })
map('n', "<leader>b", telescope_buffers, { noremap = true, silent = true })
map('n', "<leader>gg", telescope_ripgrep, { noremap = true, silent = true })

-- todo list
-- map('n', "<leader>to", ":Ag (note)|(xxx)|(fixme)|(todo)<cr>", { noremap = true })

-- smart up/down
map('n', "j", "v:count ? 'j' : 'gj'", { noremap = true, expr = true });
map('n', "k", "v:count ? 'k' : 'gk'", { noremap = true, expr = true });

-- easily edit config
map('', "<leader>rc", ":tabe ~/.config/nixpkgs/nvim<cr>", {})

-- easy window resizing in normal mode
map('n', "+", ":5wincmd ><cr>", { noremap = true, silent = true })
map('n', "-", ":5wincmd <<cr>", { noremap = true, silent = true })
map('n', "^", ":3wincmd +<cr>", { noremap = true, silent = true })
map('n', "_", ":3wincmd -<cr>", { noremap = true, silent = true })

-- toggle wrap
map('', "<leader>w", ":set wrap!<cr>", { noremap = true })

-- easy window moving and switching
map('', "<leader>H", "<c-w>H", { noremap = true, silent = true })
map('', "<leader>J", "<c-w>J", { noremap = true, silent = true })
map('', "<leader>K", "<c-w>K", { noremap = true, silent = true })
map('', "<leader>L", "<c-w>L", { noremap = true, silent = true })
map('', "<leader>h", "<c-w>h", { noremap = true, silent = true })
map('', "<leader>j", "<c-w>j", { noremap = true, silent = true })
map('', "<leader>k", "<c-w>k", { noremap = true, silent = true })
map('', "<leader>l", "<c-w>l", { noremap = true, silent = true })
map('', "<leader>=", "<c-w>=", { noremap = true, silent = true })
map('', "<leader>W", ":windo set nowinfixwidth nowinfixheight<cr>", { noremap = true, silent = true })

-- move tabs
map('', ",>", ":tabm +", { noremap = true, silent = true })
map('', ",<", ":tabm -", { noremap = true, silent = true })

-- trim whitespace
map('', "<leader>tw", ":%s/\\s\\+$//e<cr>:noh<cr>", { noremap = true, silent = true })

-- new (blank) split
map('n', "<leader>vn", ":vnew<cr>", { noremap = true })
map('n', "<leader>sn", ":new<cr>", { noremap = true })
map('n', "<leader>tn", ":tabnew<cr>", { noremap = true })

-- copy split
map('n', "<leader>vc", ":vs<cr>", { noremap = true })
map('n', "<leader>sc", ":sp<cr>", { noremap = true })

-- file-find split
map('n', "<leader>vv", ":vnew<cr>"..telescope_fd, { noremap = true })
map('n', "<leader>ss", ":new<cr>"..telescope_fd, { noremap = true })
map('n', "<leader>tt", ":tabnew<cr>"..telescope_fd, { noremap = true })

-- ripgrep split
map('n', "<leader>vg", ":vnew<cr>"..telescope_ripgrep, { noremap = true })
map('n', "<leader>sg", ":new<cr>"..telescope_ripgrep, { noremap = true })
map('n', "<leader>tg", ":tabnew<cr>"..telescope_ripgrep, { noremap = true })

-- Fugitive shortcuts
map('', "<leader>gs", ":Git<cr>", { noremap = true })

-- Lanuage Server shortcuts
map('n', "<leader>xa", telescope_lsp_actions, { noremap = true, silent = true})
map('n', "<leader>xr", "<cmd>lua vim.lsp.buf.rename()<cr>", { noremap = true, silent = true })
map('n', "<leader>xe", "<cmd>lua require'telescope.builtin'.lsp_references{}<cr>", { noremap = true, silent = true })
map('n', "<leader>xd", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true })
map('n', "<leader>xf", telescope_lsp_references, { noremap = true, silent = true })
map('n', "<leader>xi", telescope_lsp_implementations, { noremap = true, silent = true })
map('n', "<leader>xn", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", { noremap = true, silent = true })
map('n', "<leader>xp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", { noremap = true, silent = true })
map('n', "<leader>/", telescope_lsp_definition, {  noremap = true, silent = true })
map('n', "<leader>?", "<cmd>lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })
map('n', "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })

-- Completion/snippets
map('i', "<c-l>", "compe#confirm('<c-l>')", { silent = true, expr = true })
map('i', "<c-q>", "compe#close('<c-q>')", { silent = true, expr = true })
map('i', "<c-n>", "pumvisible() ? '<c-n>' : compe#complete()", { silent = true, expr = true })
map('i', "<c-j>", "vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' : '<c-j>'", { expr = true })
map('i', "<c-h>", "vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' : '<c-h>'", { expr = true, noremap = true })

-- Terminal shortcuts
map('n', "<leader>tx", ":tabnew<cr>:terminal<cr>i", { noremap = true, silent = true})
map('n', "<leader>vx", ":vs<cr>:terminal<cr>i", { noremap = true, silent = true})
map('n', "<leader>sx", ":sp<cr>:terminal<cr>i", { noremap = true, silent = true})
map('n', "<leader>xx", ":terminal<cr>i", { noremap = true, silent = true})

-- diff shortcuts
map('n', "<leader>dp", ":diffput<cr>", { noremap = true })
map('n', "<leader>dg", ":diffget<cr>", { noremap = true })
map('n', "<leader>dt", ":diffthis<cr>", { noremap = true })
map('n', "<leader>do", ":diffoff<cr>:set noscrollbind<cr>:set nocursorbind<cr>", { noremap = true })

-- easy lnext, cnext, etc
map('n', "<leader>mn", ":lnext<cr>", { noremap = true })
map('n', "<leader>mp", ":lprev<cr>", { noremap = true })
map('n', "<leader>mN", ":lnfile<cr>", { noremap = true })
map('n', "<leader>mP", ":lpfile<cr>", { noremap = true })
map('n', "<leader>cn", ":cnext<cr>", { noremap = true })
map('n', "<leader>cp", ":cprev<cr>", { noremap = true })
map('n', "<leader>cN", ":cnfile<cr>", { noremap = true })
map('n', "<leader>cP", ":cpfile<cr>", { noremap = true })

-- esc
map('i', "jj", "<esc>", { noremap = true })
map('i', "fj", "<esc>", { noremap = true })
map('i', "jf", "<esc>", { noremap = true })

-- auto-pairs when using <cr>
map('i', "{<cr>", "{<cr>}<esc>ko", { noremap = true })
map('i', "[<cr>", "[<cr>]<esc>ko", { noremap = true })
map('i', "(<cr>", "(<cr>)<esc>ko", { noremap = true })

-- hop
map('n', "<bslash>w", ":HopWord<cr>", { noremap = true })
map('n', "<bslash>n", ":HopPattern<cr>", { noremap = true })
map('n', "<bslash>1", ":HopChar1<cr>", { noremap = true })
map('n', "<bslash>f", ":HopChar1<cr>", { noremap = true })
map('n', "<bslash>F", ":HopChar1<cr>", { noremap = true })
map('n', "<bslash>2", ":HopChar2<cr>", { noremap = true })
map('n', "<bslash>j", ":HopLine<cr>", { noremap = true })
map('n', "<bslash>k", ":HopLine<cr>", { noremap = true })

-- Misc shortcuts
map('n', "Y", "y$", { noremap = true })
map('', "<leader>e", ":Lex<cr>", { noremap = true, silent = true})
map('', "<leader>q", ":q<cr>", { noremap = true, silent = true})
map('', "<leader>tq", ":tabc<cr>", { noremap = true })
map('', "<leader>pw", ":pwd<cr>", { noremap = true, silent = true})
map('', "<leader>pp", ":!pandoc --filter pandoc-citeproc \"%\" -o \"%.pdf\"<cr>", { noremap = true, silent = true})
map('', "<leader>pd", ":!pandoc --filter pandoc-citeproc \"%\" -o \"%.docx\"<cr>", { noremap = true, silent = true})
map('', "<leader>pm", ":!pandoc --filter pandoc-citeproc \"%\" -o \"%.md\"<cr>", { noremap = true, silent = true})
map('', "<leader>ph", ":!pandoc --filter pandoc-citeproc \"%\" -o \"%.html\"<cr>", { noremap = true, silent = true})
map('', "<leader>cd", ":cd %:p:h<cr>:pwd<cr>", { noremap = true, silent = true})
map('n', "!", ":!", { noremap = true })
