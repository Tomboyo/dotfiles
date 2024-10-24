(local telescope (require :telescope))
(local actions_layout (require :telescope.actions.layout))
(import-macros {: map!} :hibiscus.vim)

(telescope.setup {
  :defaults {
    :path_display {:shorten {:exclude [0 -1 -2 -3]} :truncate {}}
    :mappings {
      :n {
        "<C-p>" actions_layout.toggle_preview
      }
    }
    :layout_strategy :horizontal
    :layout_config {
      :horizontal {
        :width .95
        :preview_width 0.5
        :preview_cutoff 80
      }
    }
  }
})

(map! [n] :ff "<cmd>Telescope find_files<CR>")
(map! [n] :fg "<cmd>Telescope live_grep<CR>")
(map! [n] :fb "<cmd>Telescope buffers<CR>")
(map! [n] :fh "<cmd>Telescope help_tags<CR>")
