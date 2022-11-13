local M = {}

function M.setup_servers(servers)
    local util = require('lsp.utils')

    for _, server in pairs(servers) do
       util.setup_server(server, nil)
    end
end

return M
