;; Set [local]leader before requiring lazy.
(set vim.g.mapleader "\\")
(set vim.g.maplocalleader " ")

(require :config.options)
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
          :nvim-telescope/telescope-live-grep-args.nvim ; pass grep args to live_grep
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
       ; :mfussenegger/nvim-jdtls
       :nvim-java/nvim-java
       ; Conjure, for REPL langs like clj and py
       :olical/conjure
       ; nREPL support to go with Conjure
       [:tpope/vim-dispatch
        :clojure-vim/vim-jack-in
        :radenling/vim-dispatch-neovim]]

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

(require :config.leap)
(require :config.treesitter)
(require :config.telescope)
(require :config.lsp)

