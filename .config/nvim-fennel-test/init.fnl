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
      {1 :nvim-treesitter/nvim-treesitter
       :build ":TSUpdate"}

      ;; S-exp editing
      [:guns/vim-sexp
       :tpope/vim-sexp-mappings-for-regular-people]
    ]   
    :install {:colorscheme [:habamax]}
    :checker { :enabled true }})

;; Apply color theme
(local vscode (require :vscode))
(vscode.load :dark)

;;
;; Options
;;
(set vim.o.expandtab true) ; convert tabs to spaces
(set vim.o.tabstop 2)      ; spaces per tab
(set vim.o.shiftwidth 2)   ; spaces per indent level
(set vim.o.textwidth 80)   ; wrap column


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

