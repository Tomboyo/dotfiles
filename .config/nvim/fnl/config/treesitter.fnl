(fn disableForLargeFiles [lang buf]
  (let [maxFileSize (* 1024 1000) ; 1 MiB
        (ok? stats) (pcall vim.loop.fs_stat (vim.api.nvim_buf_get_name buf))]
    (if (and ok? (not (= nil stats)) (> stats.size maxFileSize))
        (do (print "Highlighting disabled (file too large or error statting file)")
          true)
        false)))

  (let [treesitter (require :nvim-treesitter.configs)]
    (treesitter.setup {
                      :highlight {
                                 :enable true
                                 ; Disable highlihgting on large files
                                 :disable disableForLargeFiles 
                                 }
                      :indent { :enable true }
                      :ensure_installed [:fennel]
                      :auto_install true}))
