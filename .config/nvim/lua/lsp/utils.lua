local M = {}

function M.lsp_diagnostics()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = false,
    signs = true,
    update_in_insert = false,
  })

  local on_references = vim.lsp.handlers["textDocument/references"]
  vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
  on_references, { loclist = true, virtual_text = true }
  )

  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = function(args)
      vim.diagnostic.setloclist({ open = false })
      vim.diagnostic.setqflist({ open = false })
    end
  })
end

function M.lsp_highlight(client, bufnr)
  if client.server_capabilities['documentHighlightProvider'] then
    vim.api.nvim_exec2(
      [[
      hi LspReferenceRead  cterm=bold gui=bold
      hi LspReferenceText  cterm=bold gui=bold
      hi LspReferenceWrite cterm=bold gui=bold
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]], {}
      )
  end
end

function M.lsp_config(client, bufnr)
  require("lsp_signature").on_attach {
    bind = true,
    handler_opts = { border = "single" },
  }

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(...)
  end
  buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Key mappings
  local lspkeymappings = require "keybinds"
  lspkeymappings.setup_lsp_mappings()

  -- LSP and DAP menu
  -- local whichkey = require "config.which-key"
  -- whichkey.register_lsp(client)

  if client.server_capabilities['documentFormattingProvider'] then
    vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format()"
  end
end

function M.lsp_init(client, bufnr)
  -- LSP init
end

function M.lsp_exit(client, bufnr)
  -- LSP exit
end

function M.lsp_attach(client, bufnr)
  M.lsp_config(client, bufnr)
  M.lsp_highlight(client, bufnr)
  M.lsp_diagnostics()
  require('lsp-inlayhints').on_attach(client, bufnr)
end

function M.setup_server(server, config)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig = require "lspconfig"
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
        on_attach = M.lsp_attach,
        on_exit = M.lsp_exit,
        on_init = M.lsp_init,
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities,
        init_options = config,
    }, {}))

  local cfg = lspconfig[server]
  if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
    print(server .. ": cmd not found: " .. vim.inspect(cfg.cmd))
  end
end

return M
