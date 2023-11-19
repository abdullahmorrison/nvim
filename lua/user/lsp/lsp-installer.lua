local status_ok, lsp-installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    vim.notify("LSP installer failed to load")
    return
end

-- Register handler that will be called on all installed servers
-- Alternatively you may also register handlers on specific servers
lsp-installer.on_server_ready(function(server)
    local opts = { }
end)
