local M = {}
local wk = require('which-key')

function M.setup()
  vim.cmd [[
    command! CNext try | cnext | catch | cfirst | endtry
    command! CPrev try | cprev | catch | clast  | endtry
    command! LNext try | lnext | catch | lfirst | endtry
    command! LPrev try | lprev | catch | llast  | endtry
  ]]
  wk.register({
      -- name = 'Buffer stuff',
      ['\\'] = { '<cmd>vsplit<cr>', 'Split vertical' },
      ['-'] = { '<cmd>split<cr>', 'Split horizontal' },
      q = { '<cmd>NERDTreeToggle<cr>', 'Spawn NERDTree' },
      a = { '<cmd>bprev<cr>', 'Previous tab' },
      s = { '<cmd>bnext<cr>', 'Next tab' },
      d = { '<cmd>close<cr>', "Close buffer" },
      f = { '<cmd>only<cr>', "Close everything but" },
      x = { '<cmd>bdelete<cr>', "Close tab" },
      -- buffer movement
      [';'] = { '<C-w>l', 'Move to ->' },
      l = { '<C-w>k',     'Move to ^-' },
      k = { '<C-w>j',     'Move to -v' },
      j = { '<C-w>h',     'Move to <-' },
    }, { prefix = "<leader>" })
  wk.register({
      -- name = 'Buffer resizing',
      ['<A-down>']  = { '<C-w>-', 'Shrink buffer vert' },
      ['<A-up>']    = { '<C-w>+', 'Grow buffer vert' },
      ['<A-left>']  = { '<C-w><', 'Grow buffer left' },
      ['<A-right>'] = { '<C-w>>', 'Grow buffer right' },
    }, {})

  wk.register({
      -- name = 'Movement',
      ["\\"] = { [[$]], 'End' },
      [";"] = { [[l]], '->' },
      l = { [[k]], '-v'  },
      k = { [[j]], '^-' },
      j = { [[h]], '<-' },
      K = { [[<C-d>]], 'half-page down' },
      L = { [[<C-u>]], 'half-page up' },
      q = { [[<C-r>]], 'Redo' },
      ['['] = {
        q = { [[<cmd>CPrev<Return>]], 'Prev error' },
      },
      [']'] = {
        q = { [[<cmd>CNext<Return>]], 'Next error' },
      },
      -- Emacsish
      ["/"] = { [[/\v\c]], 'Emacs-like forward search' },
      -- other
      ['<C-Tab>'] = { [[<C-V><Tab>]], 'Insert literal tab.', mode = 'i' },
      ['<C-d>'] = { [[<cmd>cd %:h<cr>]], 'cd to buffer path.' },

    }, {})
end

function M.setup_telescope_mappings()
  wk.register({
    f = { '<cmd>Telescope find_files<cr>', 'Find file' },
    g = { '<cmd>Telescope live_grep<cr>', 'Grep live' },
    b = { '<cmd>Telescope buffers<cr>', 'Find buffer' },
    h = { '<cmd>Telescope help_tags<cr>', 'help_tags' },
  }, { prefix = '<leader>t' })
end

function M.setup_lsp_mappings()
  wk.register({
      [','] = { '<cmd>lua vim.lsp.buf.declaration()<cr>',      'goto declaration' },
      ['.'] = { '<cmd>lua vim.lsp.buf.definition()<cr>',       'goto definition' },
      ['/'] = { '<cmd>lua vim.lsp.buf.references()<cr>',       'find references to' },
      ['?'] = { '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', 'workspace_symbol?' },

      ['<leader>'] = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'doc window' },
      ['s'] = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'get sig at point' },

      ['['] = {
        z = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Get prev diag' },
      },
      [']'] = {
        z = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Get next diag.' },
      },

      c = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code action' },
      r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename symbol' },
      D = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type def' },
      e = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Show diag' },
      l = { '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', 'Populate loclist' },
      F = { '<cmd>lua vim.lsp.buf.format()<CR>', 'Buffer format' },
      t = { "<cmd>lua require('lsp-inlayhints').toggle()<CR>", 'Toggle hint inlays'},

    }, { prefix = "<leader>e", buffer = vim.nvim_get_current_buf })
end

return M
