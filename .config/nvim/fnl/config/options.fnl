(set vim.o.expandtab true) ; convert tabs to spaces
(set vim.o.tabstop 2)      ; spaces per tab
(set vim.o.shiftwidth 2)   ; spaces per indent level
(set vim.o.textwidth 80)   ; wrap column
(set vim.opt.relativenumber true)
(set vim.opt.number true)

(if (= 1 (vim.fn.has :wsl))
    (if (or (= 0 (vim.fn.executable :clip.exe))
            (= 0 (vim.fn.executable :powershell.exe)))
        (print "Can't configure clipboard due to missing executables")
        (let [copy (.. (vim.fn.stdpath :config) "/script/copy")
              paste (.. (vim.fn.stdpath :config) "/script/paste")]
          (set vim.g.clipboard
               {
                :name "powershell (wsl)"
                :copy {
                  :+ copy 
                  :* copy 
                }
                :paste {
                  :+ #(vim.fn.systemlist paste
                                         [""]
                                         1) ; 1 keeps empty lines
                  :* #(vim.fn.systemlist paste
                                         [""]
                                         1) ; 1 keeps empty lines
                }
                :cache_enabled true
               })
          (set vim.g.loaded_clipboard_provider nil)
          (vim.cmd "runtime autoload/provider/clipboard.vim"))))

