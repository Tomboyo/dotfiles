(import-macros {: map!} :hibiscus.vim)

(map! [n] :ff "<cmd>Telescope find_files<CR>")
(map! [n] :fg "<cmd>Telescope live_grep<CR>")
(map! [n] :fb "<cmd>Telescope buffers<CR>")
(map! [n] :fh "<cmd>Telescope help_tags<CR>")
