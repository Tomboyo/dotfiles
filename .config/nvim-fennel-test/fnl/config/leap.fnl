(import-macros {: map! : augroup!} :hibiscus.vim)

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
    (map! [n] :fl "<Plug>(leap)")
    (map! [n] :fL "<Plug>(leap-from-window)"))])
