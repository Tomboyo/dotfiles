; element selection
(vim.keymap.set [:v :o] "<LocalLeader>ee" "<Plug>(slurp-select-element)")
(vim.keymap.set [:v :o] "<LocalLeader>ie" "<Plug>(slurp-select-inside-element)")
(vim.keymap.set [:v :o] "<LocalLeader>ae" "<Plug>(slurp-select-outside-element)")
(vim.keymap.set [:v :o] "<LocalLeader>e)" "<Plug>(slurp-select-(element))")
(vim.keymap.set [:v :o] "<LocalLeader>e]" "<Plug>(slurp-select-[element])")
(vim.keymap.set [:v :o] "<LocalLeader>e}" "<Plug>(slurp-select-{element})")
(vim.keymap.set [:v :o] "<LocalLeader>i)" "<Plug>(slurp-select-inside-(element))")
(vim.keymap.set [:v :o] "<LocalLeader>i]" "<Plug>(slurp-select-inside-[element])")
(vim.keymap.set [:v :o] "<LocalLeader>i}" "<Plug>(slurp-select-inside-{element})")
(vim.keymap.set [:v :o] "<LocalLeader>a)" "<Plug>(slurp-select-outside-(element))")
(vim.keymap.set [:v :o] "<LocalLeader>a]" "<Plug>(slurp-select-outside-[element])")
(vim.keymap.set [:v :o] "<LocalLeader>a}" "<Plug>(slurp-select-outside-{element})")
(vim.keymap.set [:v :o] "<LocalLeader>il" "<Plug>(slurp-inner-list-to)")
(vim.keymap.set [:v :o] "<LocalLeader>al" "<Plug>(slurp-outer-list-to)")

;motion
(vim.keymap.set [:n :v :o] "w" "<Plug>(slurp-forward-into-element)")
(vim.keymap.set [:n :v :o] "W" "<Plug>(slurp-forward-over-element)")

;manipulation
(vim.keymap.set [:n]
                "<LocalLeader>)l"
                "<Plug>(slurp-slurp-close-paren-forward)")
(vim.keymap.set [:n]
                "<LocalLeader>(h"
                "<Plug>(slurp-slurp-open-paren-backward)")
(vim.keymap.set [:n]
                "<LocalLeader>(l"
                "<Plug>(slurp-barf-open-paren-forward)")
(vim.keymap.set [:n]
                "<LocalLeader>)h"
                "<Plug>(slurp-barf-close-paren-backward)")
(vim.keymap.set [:n]
                "<LocalLeader>o"
                "<Plug>(slurp-replace-parent)")
; TODO: prefer ds) and co. in imitation of the tpope plugin.
(vim.keymap.set [:n]
                "<LocalLeader>@)"
                "<Plug>(slurp-delete-surrounding-())")

; TODO: remove me (debugging keybinds)
(vim.keymap.set [:n]
                "<LocalLeader>bld"
                (fn []
                  (vim.cmd "!make build")
                  (set package.loaded.tree nil)
                  (set package.loaded.iter nil)
                  (set package.loaded.strings nil)
                  (set package.loaded.opfunc nil)
                  (set package.loaded.slurp nil)
                  (vim.cmd "ConjureEvalBuf"))
                {})
