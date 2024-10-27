;; Set [local]leader before requiring lazy.
(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

;; Confiure vim-sexp before it loads, otherwise it doesn't work.
(require :config.sexp)

(local lazy (require :lazy))
(lazy.setup {
    :spec [
      ;; Fennel support
      :udayvir-singh/tangerine.nvim
      :udayvir-singh/hibiscus.nvim

      ;; VSCode theme
      :Mofiqul/vscode.nvim

      ;; Navigation
      :ggandor/leap.nvim
      { 1 :nvim-telescope/telescope.nvim :branch :0.1.x
        :dependencies [
          :nvim-lua/plenary.nvim ; required
          :BurntSushi/ripgrep    ; suggested (perf)
        ]}

      ;; Language support
      [{1 :nvim-treesitter/nvim-treesitter
       :build ":TSUpdate"}
       ; installs language servers
       :williamboman/mason.nvim
       :williamboman/mason-lspconfig.nvim
       ; default configurations for language servers
       :neovim/nvim-lspconfig
       ; Specifically for java (using eclipse jdtls)
       ; See also https://github.com/eclipse-jdtls/eclipse.jdt.ls#installation
       ; See also https://download.eclipse.org/jdtls/milestones/1.40.0/
       :mfussenegger/nvim-jdtls
       ; Conjure, for REPL langs like clj and py
       :olical/conjure]

      ;; S-exp editing
      [:guns/vim-sexp
       :tpope/vim-sexp-mappings-for-regular-people]

      ;; Add, change, and remove surrounding (), {}, etc.
      :tpope/vim-surround
    ]   
    :install {:colorscheme [:habamax]}
    :checker { :enabled true }})

;; Apply color theme
(let [vscode (require :vscode)]
  (vscode.load :dark))

(require :config.options)
(require :config.leap)

(import-macros {: map! : augroup!} :hibiscus.vim)

;;
;; lazyvim
;;
(vim.api.nvim_create_user_command
  :LZGit
  "tabnew term://lazygit"
  {})

;;
;; per-profile session management
;;
(let [sfile (.. (vim.fn.stdpath :data) "/last.session")] 
  (augroup! :sessions
    [[VimLeave] * (.. "mksession! " sfile)])
  (vim.api.nvim_create_user_command
    :RestoreLastSession
    (.. "source" sfile)
    {}))

;;
;; Treesitter
;;
(let [treesitter (require :nvim-treesitter.configs)]
  (treesitter.setup {
    :highlight {
      :enable true
      ; Disable highlihgting on large files (> 1MiB)
      :disable (fn [lang buf]
        (let [max-file-size (* 1024 1000) ; 1 MiB
              (ok? stats) (pcall vim.loop.fs_stat (vim.api.nvim_buf_get_name buf))]
          (if (and ok? (not (= nil stats)) (> stats.size max-file-size))
              (do (print "Highlighting disabled (file too large or error statting file)")
                  true)
              false)))
    }
    :indent { :enable true }
    :ensure_installed [:fennel]
    :auto_install true}))

(require :config.telescope)

; Not using mason-lspconfig because it seems to have integration issues on my
; machine.
; Note: java lsp support through jdtls. Do not configure here.
(let [mason (require :mason)
      lspconfig (require :lspconfig)]
  (mason.setup {})
  (lspconfig.bashls.setup {})
  (lspconfig.clojure_lsp.setup {})
  (lspconfig.fennel_language_server.setup {})
  (lspconfig.pylsp.setup {}))

(require :config.jdtls)

; Language support keybinds
; Depends on: Treesitter, LSP, JDTLS
(vim.api.nvim_create_autocmd
  :LspAttach
  {:callback (fn [args]
               (let [client (vim.lsp.get_client_by_id args.data.client_id)
                     capable client.server_capabilities]
                 (when capable.hoverProvider
                   (vim.keymap.set :n :K vim.lsp.buf.hover {:buffer args.buf}))
                 ; Not bothering with declaration because it doesn't usually
                 ; work, and because definiton achieves the same result.
                 (when capable.definitionProvider
                   (vim.keymap.set :n :gd vim.lsp.buf.definition {:buffer args.buf :noremap true}))
                 (when capable.callHierarchyProvider
                   (vim.keymap.set :n :fi "<cmd>Telescope lsp_incoming_calls<cr>" {:buffer args.buf :noremap true})
                   (vim.keymap.set :n :fo "<cmd>Telescope lsp_outgoing_calls<cr>" {:buffer args.buf :noremap true}))
                 (when capable.implementationProvider
                   (vim.keymap.set :n :fim "<cmd>Telescope lsp_implementations<cr>" {:buffer args.buf :noremap true}))
                 ))})
