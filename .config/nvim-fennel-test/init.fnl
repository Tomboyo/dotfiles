;; Set [local]leader before requiring lazy.
(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

(local lazy (require :lazy))
(lazy.setup {
  :install {
    :colorscheme [ :habamax ]
  }
  :checker {
    :enabled true
  }
  :spec [
    ;; Fennel support
    :udayvir-singh/tangerine.nvim
    :udayvir-singh/hibiscus.nvim

    ;; VSCode theme
    :Mofiqul/vscode.nvim

    ;; Navigation
    :ggandor/leap.nvim

    ;; Language support
    :nvim-treesitter/nvim-treesitter
  ]
})

;; Apply color theme
(local vscode (require :vscode))
(vscode.load :dark)

(import-macros {: map! : augroup!} :hibiscus.vim)

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
(local treesitter (require :nvim-treesitter))
(treesitter.setup {
  :ensure_installed [ :fennel ]
  :auto_install true
  :highlight {
    :enable true
    :disable (fn [lang buf]
      (let [max-file-size (* 1000 1024) ; 1MiB
	    (ok? stats) (pcall vim.loop.fs_stat (vim.api.nvim_buf_get_name buf))]
	(if (or (not ok?) (> stats max-file-size))
	    (do (print "File is too large. Treesitter highlighting disabled.")
	        true)
	    false)))
  }
})

