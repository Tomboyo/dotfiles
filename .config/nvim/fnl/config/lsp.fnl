; From nvim-java. Must come before lspconfig.
(let [java (require :java)]
  (java.setup
    {:spring_boot_tools {:enable false}}))

; Not using mason-lspconfig because it seems to have integration issues on my
; machine.
(let [mason (require :mason)
      lspconfig (require :lspconfig)]
  (mason.setup {})
  (lspconfig.bashls.setup {})
  (lspconfig.clojure_lsp.setup {})
  (lspconfig.fennel_language_server.setup {})
  (lspconfig.pylsp.setup {})
  (lspconfig.jdtls.setup {}))

; Language support keybinds
; Depends on: Treesitter, LSP, JDTLS
(vim.api.nvim_create_autocmd
  :LspAttach
  {:callback (fn [args]
               (let [client (vim.lsp.get_client_by_id args.data.client_id)
                            capable client.server_capabilities]
                 ;TODO: when
                 (vim.keymap.set :n "<LocalLeader>ca" (fn [] (vim.lsp.buf.code_action {:apply false})))

                 (when capable.hoverProvider
                   (vim.keymap.set :n :K vim.lsp.buf.hover {:buffer args.buf}))
                 (when capable.declarationProvider
                   (vim.keymap.set :n :gd vim.lsp.buf.definition {:buffer args.buf :noremap true}))
                 (when capable.definitionProvider
                   (vim.keymap.set :n :gD vim.lsp.buf.definition {:buffer args.buf :noremap true}))
                 (when capable.callHierarchyProvider
                   (vim.keymap.set :n :fi "<cmd>Telescope lsp_incoming_calls<cr>" {:buffer args.buf :noremap true})
                   (vim.keymap.set :n :fo "<cmd>Telescope lsp_outgoing_calls<cr>" {:buffer args.buf :noremap true}))
                 (when capable.implementationProvider
                   (vim.keymap.set :n :fim "<cmd>Telescope lsp_implementations<cr>" {:buffer args.buf :noremap true}))
                 ; TODO: when
                 (vim.keymap.set :n "<LocalLeader>e" "<cmd>lua vim.diagnostic.open_float(nil, {focus=false, scope=\"cursor\"})<CR>" {:buffer args.bug :noremap true})
                 ))})
