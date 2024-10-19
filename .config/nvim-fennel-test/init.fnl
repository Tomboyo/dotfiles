;; Set [local]leader before requiring lazy.
(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

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
	  :BurntSushi/ripgrep ; suggested
        ]}

      ;; Language support
      {1 :nvim-treesitter/nvim-treesitter
       :build ":TSUpdate"}
    ]   
    :install {:colorscheme [:habamax]}
    :checker { :enabled true }})

;; Apply color theme
(local vscode (require :vscode))
(vscode.load :dark)

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

; "l" for "leap."
(map! [nxo] :l "<Plug>(leap)")
(map! [nxo] :L "<Plug>(leap-from-window)")

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

