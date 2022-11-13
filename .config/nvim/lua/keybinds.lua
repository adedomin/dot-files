local M = {}

require 'nvim_utils'

local function map_toggle_settings(...)
    local parts = {}
    for _, setting in ipairs(vim.tbl_flatten{...}) do
        table.insert(parts, ("%s! %s?"):format(setting, setting))
    end
    return map_set(parts)
end

function M.setup()
    vim.cmd [[
        command! CNext try | cnext | catch | cfirst | endtry
        command! CPrev try | cprev | catch | clast  | endtry
        command! LNext try | lnext | catch | lfirst | endtry
        command! LPrev try | lprev | catch | llast  | endtry
    ]]
    local mapping = {
        ["n<Leader>\\"] = { [[:vsplit<Return>]], noremap = true, },
        ["n<Leader>-"] =  { [[:split<Return>]], noremap = true, },
        ["n<Leader>q"] =  { [[:NERDTreeToggle<Return>]], noremap = true, },
        ["n<Leader>a"] =  { [[:bprev<Return>]], noremap = true, },
        ["n<Leader>s"] =  { [[:bnext<Return>]], noremap = true, },
        ["n<Leader>d"] =  { [[:close<Return>]], noremap = true, },
        ["n<Leader>f"] =  { [[:only<Return>]], noremap = true, },
        ["n<Leader>x"] =  { [[:bdelete<Return>]], noremap = true, },
        -- Window management
        ["n<Leader>;"] = { [[<C-w>l]] },
        ["n<Leader>l"] = { [[<C-w>k]] },
        ["n<Leader>k"] = { [[<C-w>j]] },
        ["n<Leader>j"] = { [[<C-w>h]] },
        ["n<A-down>"] =  { [[<C-w>-]] },
        ["n<A-up>"] =    { [[<C-w>+]] },
        ["n<A-left>"] =  { [[<C-w><]] },
        ["n<A-left>"] =  { [[<C-w>>]] },
        -- Movement
        ["n\\"] = { [[$]], noremap = true, },
        ["n;"] = { [[l]], noremap = true, },
        ["nl"] = { [[k]], noremap = true, },
        ["nk"] = { [[j]], noremap = true, },
        ["nj"] = { [[h]], noremap = true, },
        ["nK"] = { [[<C-d>]], noremap = true, },
        ["nK"] = { [[<C-d>]], noremap = true, },
        ["nL"] = { [[<C-u>]], noremap = true, },
        ["nq"] = { [[<C-r>]], noremap = true, },
        ["n[q"] = { [[<cmd>CPrev<Return>]], noremap = true, },
        ["n]q"] = { [[<cmd>CNext<Return>]], noremap = true, },
        -- Emacsish
        ["n/"] = { [[/\v\c]], noremap = true, },
        ["i<S-Tab>"] = { [[<C-V><Tab>]], noremap = true },
    }
    nvim_apply_mappings(mapping, { silent = true })
end

function M.setup_lsp_mappings()
    local opts = { noremap=true, silent=true }
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
    buf_set_keymap('n', '<space>,', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<space>.', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<space>/', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>?', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

    buf_set_keymap('n', '<space><space>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

    buf_set_keymap('n', '[z', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']z', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>l', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<space>t', "<cmd>lua require('lsp_extensions').inlay_hints()<CR>", opts)
end

return M
