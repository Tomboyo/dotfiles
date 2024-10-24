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
       ]

      ;; S-exp editing
      [:guns/vim-sexp
       :tpope/vim-sexp-mappings-for-regular-people]

      :tpope/vim-surround
    ]   
    :install {:colorscheme [:habamax]}
    :checker { :enabled true }})

;; Apply color theme
(let [vscode (require :vscode)]
  (vscode.load :dark))

(require :config.options)

(import-macros {: map! : augroup!} :hibiscus.vim)
;; per-profile session management
(let [sfile (.. (vim.fn.stdpath :data) "/last.session")] 
  (augroup! :sessions
    [[VimLeave] * (.. "mksession! " sfile)])
  (vim.api.nvim_create_user_command
    :RestoreLastSession
    (.. "source" sfile)
    {}))
;;
;; Configure Leap
;; TODO: separate files

; [f]ind [l]eap. Builds on telescope's occupation of [f]ind for commands that
; locate or go to distant things.
(map! [nxo] :fl "<Plug>(leap)")
(map! [nxo] :fL "<Plug>(leap-from-window)")

; (Highlights)
(vim.api.nvim_set_hl 0 :LeapBackdrop {:link "Comment"})
(vim.api.nvim_set_hl 0 :LeapLabel {:link "Search"})

; Netrw mappings. TODO: I have heard Netrw is trash for bad people.
(augroup! :netrw
  [[:filetype :desc "Use Leap in netrw"]
  :netrw
  (fn []
    (map! [n] :l "<Plug>(leap)")
    (map! [n] :L "<Plug>(leap-from-window)"))])

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

