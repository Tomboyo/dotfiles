(import-macros {: map! : augroup!} :hibiscus.vim)

; See https://github.com/mfussenegger/nvim-jdtls/tree/master?tab=readme-ov-file#usage

(fn mappings []
  (let [jdtls (require :jdtls)]
    (map! [n :buffer :noremap] "<LocalLeader>cao" '(jdtls.organize_imports))
    (map! [n :buffer :noremap] "<LocalLeader>caev" '(jdtls.extract_variable))
    (map! [v :buffer :noremap] "<LocalLeader>caev" '(jdtls.extract_variable true))
    (map! [n :buffer :noremap] "<LocalLeader>caec" '(jdtls.extract_constant))
    (map! [v :buffer :noremap] "<LocalLeader>caec" '(jdtls.extract_constant true))
    (map! [v :buffer :noremap] "<LocalLeader>caem" '(jdtls.extract_method true))))

(augroup! :jdtls-custom-mappings
  [[FileType] [:java] 'mappings])

; " If using nvim-dap
; " This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
; nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
; nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
