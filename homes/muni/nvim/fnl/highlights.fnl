(let [name-gui-map (require :name-gui-map)
      name-cterm-map {:black 0
                      :dark-red 1
                      :dark-green 2
                      :dark-yellow 3
                      :dark-blue 4
                      :dark-purple 5
                      :dark-cyan 6
                      :silver 7
                      :gray 8
                      :red 9
                      :green 10
                      :yellow 11
                      :blue 12
                      :purple 13
                      :cyan 14
                      :white 15

                      :orange 9
                      :brown 11
                      :dark-orange 1
                      :dark-brown 3
                      :dark-gray 8
                      :light-gray 8
                      :light-silver 7
                      :bright-white 15}
      ;; main highlight function
      hi (fn [name fg-name bg-name vals]
           (when fg-name (tset vals :ctermfg (. name-cterm-map fg-name))
                         (tset vals :fg (. name-gui-map fg-name)))
           (when bg-name (tset vals :ctermbg (. name-cterm-map bg-name))
                         (tset vals :bg (. name-gui-map bg-name)))
           (vim.api.nvim_set_hl 0 name vals))
      link (fn [src dest]
             (vim.api.nvim_set_hl 0 dest {:link src}))
      link-all (fn [src dests]
                 (each [_ dest (ipairs dests)]
                   (link src dest))) ;;
      ;; links {{{
      links {:Bold ["@text.strong"]
             :DiagnosticHint [:DiagnosticSignHint
                              :DiagnosticVirtualTextHint]
             :DiffAdd ["@text.diff.add"]
             :DiffDelete ["@text.diff.delete"]
             :Error [:DiagnosticError
                     :DiagnosticSignError
                     :DiagnosticVirtualTextError
                     :ErrorMsg
                     :NvimInternalError]
             :Info [:DiagnosticInfo
                    :DiagnosticSignInfo
                    :DiagnosticVirtualTextInfo
                    :InfoMsg]
             :Italic ["@text.emphasis"]
             :SpellRare [:SpellLocal]
             :Warning [:DiagnosticSignWarn
                       :DiagnosticVirtualTextWarn
                       :DiagnosticWarn
                       :WarningMsg]}]
  ;; }}}
  (hi "@neorg.markup.verbatim" :orange nil {})
  (hi "@neorg.headings.1.prefix" :brown nil {})
  (hi "@neorg.headings.1.title" :brown nil {})
  (hi "@text.literal" :green nil {})
  (hi :Bold nil nil {:bold true})
  (hi :Boolean :orange nil {})
  (hi :Character :red nil {})
  (hi :ColorColumn nil :dark-gray {})
  (hi :Comment :light-gray nil {})
  (hi :Conceal :light-gray :black {})
  (hi :Conditional :brown nil {})
  (hi :Constant :orange nil {})
  (hi :Cursor :black :light-silver {})
  (hi :CursorColumn nil :dark-gray {})
  (hi :CursorLine nil :dark-gray {})
  (hi :CursorLineNr :silver :dark-gray {:bold true})
  (hi :CustomBluePillInside :blue :dark-gray {:bold true})
  (hi :CustomBlueStatus :blue nil {:bold true})
  (hi :CustomClosePillInside :red :dark-gray {:bold true})
  (hi :CustomCloseStatus nil nil {:bold true})
  (hi :CustomCyanPillInside :cyan :dark-gray {:bold true})
  (hi :CustomCyanStatus :cyan nil {:bold true})
  (hi :CustomFuchsiaPillInside :purple :dark-gray {:bold true})
  (hi :CustomFuchsiaStatus :purple nil {:bold true})
  (hi :CustomGrayGreenFgPillInside :green :dark-gray {:bold true})
  (hi :CustomGrayPillInside :silver :dark-gray {:italic true})
  (hi :CustomGrayRedFgPillInside :red :dark-gray {:bold true})
  (hi :CustomLimePillInside :green :dark-gray {:bold true})
  (hi :CustomLimeStatus :green nil {:bold true})
  (hi :CustomPillOutside :dark-gray nil {})
  (hi :CustomRedPillInside :red :dark-gray {:bold true})
  (hi :CustomRedStatus :red nil {:bold true})
  (hi :CustomYellowPillInside :yellow :dark-gray {:bold true})
  (hi :CustomYellowStatus :yellow nil {:bold true})
  (hi :Debug :red nil {})
  (hi :Define :purple nil {})
  (hi :Delimiter :purple nil {})
  (hi :DiagnosticHint :green nil {})
  (hi :DiagnosticUnderlineError nil nil {:undercurl true :sp (. name-gui-map :red)})
  (hi :DiagnosticUnderlineHint nil nil {:undercurl true :sp (. name-gui-map :green)})
  (hi :DiagnosticUnderlineInfo nil nil {:undercurl true :sp (. name-gui-map :cyan)})
  (hi :DiagnosticUnderlineWarn nil nil {:undercurl true :sp (. name-gui-map :yellow)})
  (hi :DiffAdd :green :dark-green {:bold true})
  (hi :DiffChange nil nil {})
  (hi :DiffDelete :red :dark-red {:bold true})
  (hi :DiffText :yellow :dark-yellow {:bold true})
  (hi :Directory :blue nil {})
  (hi :Error :red nil {:bold true})
  (hi :Exception :red nil {})
  (hi :Float :orange nil {})
  (hi :FoldColumn :cyan nil {})
  (hi :Folded :light-gray :dark-gray {})
  (hi :Function :blue nil {})
  (hi :GitGutterAdd :green nil {:bold true})
  (hi :GitGutterChange :orange nil {:bold true})
  (hi :GitGutterDelete :red nil {:bold true})
  (hi :Identifier :red nil {})
  (hi :IncSearch :dark-gray :yellow {})
  (hi :Include :blue nil {})
  (hi :IndentBlanklineChar :dark-gray nil {})
  (hi :IndentBlanklineSpaceChar :dark-gray nil {})
  (hi :IndentBlanklineSpaceCharBlankline :dark-gray nil {})
  (hi :Info :cyan nil {:bold true})
  (hi :Italic nil nil {:italic true})
  (hi :Keyword :orange nil {})
  (hi :Label :yellow nil {})
  (hi :LineNr :light-gray nil {})
  (hi :Macro :red nil {})
  (hi :MatchParen :bright-white :dark-gray {:bold true})
  (hi :ModeMsg :green nil {})
  (hi :MoreMsg :green nil {})
  (hi :NonText :light-gray nil {})
  (hi :Normal :light-silver nil {})
  (hi :Number :orange nil {})
  (hi :Operator :light-silver nil {})
  (hi :Pmenu :light-silver :dark-gray {})
  (hi :PmenuSbar :black :black {})
  (hi :PmenuSel :dark-gray :light-silver {:bold true})
  (hi :PmenuThumb :light-silver :light-silver {})
  (hi :PreProc :yellow nil {})
  (hi :Question :blue nil {})
  (hi :QuickFixLine nil :dark-gray {})
  (hi :Repeat :yellow nil {})
  (hi :Search :gray :orange {})
  (hi :SignColumn nil nil {})
  (hi :Special :cyan nil {})
  (hi :SpecialChar :brown nil {})
  (hi :SpecialKey :light-gray nil {})
  (hi :SpellBad :red nil {:undercurl true})
  (hi :SpellCap :purple nil {})
  (hi :SpellRare :yellow nil {:undercurl true})
  (hi :Statement :red nil {})
  (hi :StatusLine :light-gray nil {:italic true :underline true})
  (hi :StatusLineNC :gray nil {:italic true :underline true})
  (hi :StorageClass :yellow nil {})
  (hi :String :green nil {})
  (hi :Structure :purple nil {})
  (hi :Substitute :dark-gray :orange {})
  (hi :TabLine :light-gray :dark-gray {})
  (hi :TabLineFill :light-gray nil {})
  (hi :TabLineSel :green :dark-gray {})
  (hi :Tag :yellow nil {})
  (hi :Title :blue nil {})
  (hi :Todo :yellow :dark-gray {:bold true :italic true})
  (hi :TooLong :red nil {})
  (hi :Type :yellow nil {})
  (hi :Typedef :yellow nil {})
  (hi :Underlined :red nil {})
  (hi :VertSplit :gray nil {})
  (hi :VirtualText :light-gray nil {:italic true})
  (hi :Visual nil :gray {})
  (hi :VisualNOS :red nil {})
  (hi :Warning :yellow nil {:bold true})
  (hi :Whitespace :gray nil {})
  (hi :WildMenu :red nil {})
  (each [src dests (pairs links)] ; link all the links
    (link-all src dests)))
