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

; https://github.com/nvim-telescope/telescope-live-grep-args.nvim
(telescope.load_extension :live_grep_args)

(map! [n] :ff "<cmd>Telescope find_files<CR>")
(map! [n] :fg ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
(map! [n] :fb "<cmd>Telescope buffers<CR>")
(map! [n] :fh "<cmd>Telescope help_tags<CR>")
