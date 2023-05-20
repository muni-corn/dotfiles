(let [cterm-fg (fn [hlgroup color]
                 (vim.cmd (string.format "hi %s ctermfg=%s" hlgroup color)))
      guisp (fn [hlgroup color]
              (vim.cmd (string.format "hi %s guisp=%s" hlgroup color)))
      name-cterm-map {:NONE :NONE
                      :black :0
                      :dark-gray :18
                      :gray :8
                      :light-gray :19
                      :silver :7
                      :light-silver :20
                      :white :15
                      :bright-white :21
                      :dark-red :1
                      :dark-green :2
                      :dark-yellow :3
                      :dark-cyan :6
                      :dark-blue :4
                      :dark-purple :5
                      :red :9
                      :orange :16
                      :yellow :11
                      :green :10
                      :cyan :14
                      :blue :12
                      :purple :13
                      :brown :17}
      name-to-cterm (fn [name]
                      (. name-cterm-map name))
      name-fg (fn [hlgroup name]
                (cterm-fg hlgroup (name-to-cterm name)))
      name-fg-all (fn [name hlgroups]
                    (each [i hlgroup (ipairs hlgroups)]
                      (name-fg hlgroup name)))
      name-bg (fn [hlgroup name]
                (vim.cmd (string.format "hi %s ctermbg=%s" hlgroup
                                        (name-to-cterm name))))
      name-bg-all (fn [name hlgroups]
                    (each [i hlgroup (ipairs hlgroups)]
                      (name-bg hlgroup name)))
      hl-style (fn [hlgroup style]
                 (vim.cmd (string.format "hi %s cterm=%s" hlgroup style)))
      hl-style-all (fn [style hlgroups]
                     (each [i hlgroup (ipairs hlgroups)]
                       (hl-style hlgroup style)))
      link (fn [src dest]
             (vim.cmd (string.format "hi! link %s %s" dest src)))
      link-all (fn [src dests]
                 (each [_ dest (ipairs dests)]
                   (link src dest))) ;;
      ;; foregrounds {{{
      fgs {:black [:Cursor :PmenuSbar]
           :dark-gray [:IncSearch
                       :PMenuSel
                       :Substitute
                       :CustomPillOutside
                       :IndentBlanklineChar
                       :IndentBlanklineSpaceChar
                       :IndentBlanklineSpaceCharBlankline
                       :IndentBlanklineSpaceCharBlankline]
           :gray [:Search :VertSplit :Whitespace]
           :light-gray [:Comment
                        :Conceal
                        :Folded
                        :LineNr
                        :NonText
                        :SpecialKey
                        :StatusLine
                        :StatusLineNC
                        :TabLine
                        :TabLineFill
                        :VirtualText]
           :silver [:CursorLineNr :CustomGrayPillInside]
           :light-silver [:Normal :Operator :PMenu :PMenuThumb]
           :bright-white [:MatchParen]
           :red [:Character
                 :Debug
                 :DiffDelete
                 :Error
                 :Exception
                 :Identifier
                 :Macro
                 :SpellBad
                 :Statement
                 :TooLong
                 :Underlined
                 :VisualNOS
                 :WarningMsg
                 :WildMenu
                 :CustomClosePillInside
                 :CustomGrayRedFgPillInside
                 :CustomRedPillInside
                 :CustomRedStatus]
           :orange [:Boolean :Constant :DiffChange :Float :Number]
           :yellow [:CustomYellowPillInside
                    :CustomYellowStatus
                    :DiffText
                    :Label
                    :PreProc
                    :Repeat
                    :SpellRare
                    :StorageClass
                    :Tag
                    :Todo
                    :Type
                    :Typedef
                    :Warning]
           :green [:ModeMsg
                   :DiffAdd
                   :MoreMsg
                   :String
                   :TabLineSel
                   :CustomLimePillInside
                   :CustomLimeStatus
                   :CustomGrayGreenFgPillInside]
           :cyan [:FoldColumn
                  :Info
                  :Special
                  :CustomCyanPillInside
                  :CustomCyanStatus]
           :blue [:Directory
                  :Function
                  :Include
                  :Question
                  :Title
                  :CustomBluePillInside
                  :CustomBlueStatus]
           :purple [:Define
                    :Keyword
                    :Structure
                    :CustomFuchsiaPillInside
                    :CustomFuchsiaStatus
                    :SpellCap]
           :brown [:Conditional :Delimiter :SpecialChar]} ;; }}}
      ;; backgrounds {{{
      bgs {:NONE [:DiffAdd
                  :DiffChange
                  :DiffDelete
                  :DiffText
                  :Error
                  :FoldColumn
                  :SignColumn
                  :SpellBad
                  :SpellCap
                  :SpellRare
                  :StatusLine
                  :StatusLineNC
                  :TabLineFill]
           :black [:Conceal :PmenuSbar]
           :dark-gray [:ColorColumn
                       :CursorColumn
                       :CursorLine
                       :CursorLineNr
                       :CustomClosePillInside
                       :CustomGrayGreenFgPillInside
                       :CustomGrayPillInside
                       :CustomGrayRedFgPillInside
                       :CustomCyanPillInside
                       :CustomBluePillInside
                       :CustomFuchsiaPillInside
                       :CustomLimePillInside
                       :CustomRedPillInside
                       :CustomYellowPillInside
                       :Folded
                       :MatchParen
                       :PMenu
                       :QuickFixLine
                       :TabLine
                       :TabLineSel
                       :Todo]
           :gray [:Visual]
           :light-silver [:Cursor :PMenuThumb :PMenuSel]
           :orange [:Substitute :Search]
           :yellow [:IncSearch]} ;; }}}
      ;; styles {{{
      styles {:NONE [:ColorColumn
                     :CursorColumn
                     :CursorLine
                     :Define
                     :Identifier
                     :IncSearch
                     :LineNr
                     :Operator
                     :PMenu
                     :PMenuThumb
                     :PmenuSbar
                     :QuickFixLine
                     :Substitute
                     :TabLine
                     :TabLineFill
                     :TabLineSel
                     :Title
                     :Type
                     :VertSplit]
              :bold [:Bold
                     :CursorLineNr
                     :CustomCyanPillInside
                     :CustomCyanStatus
                     :CustomBluePillInside
                     :CustomBlueStatus
                     :CustomClosePillInside
                     :CustomCloseStatus
                     :CustomFuchsiaPillInside
                     :CustomFuchsiaStatus
                     :CustomGrayGreenFgPillInside
                     :CustomGrayRedFgPillInside
                     :CustomLimePillInside
                     :CustomLimeStatus
                     :CustomRedPillInside
                     :CustomRedStatus
                     :CustomYellowPillInside
                     :CustomYellowStatus
                     :DiffAdd
                     :DiffChange
                     :DiffDelete
                     :DiffText
                     :Error
                     :Info
                     :MatchParen
                     :PMenuSel
                     :Warning]
              :italic [:CustomGrayPillInside
                       :Italic
                       :SpellBad
                       :SpellRare
                       :VirtualText]
              "bold,italic" [:Todo]
              "underline,italic" [:StatusLine :StatusLineNC]
              :underline [:DiagnosticUnderlineError
                          :DiagnosticUnderlineHint
                          :DiagnosticUnderlineInfo
                          :DiagnosticUnderlineWarn
                          :DiffText]
              :undercurl [:SpellBad :SpellRare]
              :strikethrough [:mkdStrike :pandocStrikeout]} ;; }}}
      ;; links {{{
      links {:Bold ["@text.strong"]
             :Comment [:javaScriptLineComment]
             :DiffAdd [:GitGutterAdd :diffAdded "@text.diff.add"]
             :DiffChange [:GitGutterChange]
             :DiffDelete [:GitGutterDelete :diffRemoved "@text.diff.delete"]
             :Error [:DiagnosticError
                     :DiagnosticSignError
                     :DiagnosticVirtualTextError
                     :ErrorMsg
                     :NvimInternalError]
             :Info [:DiagnosticHint
                    :DiagnosticInfo
                    :DiagnosticSignHint
                    :DiagnosticSignInfo
                    :DiagnosticVirtualTextHint
                    :DiagnosticVirtualTextInfo
                    :InfoMsg]
             :Italic ["@text.emphasis"]
             :SpellRare [:SpellLocal]
             :String [:pandocBlockQuote]
             :Warning [:DiagnosticSignWarn
                       :DiagnosticVirtualTextWarn
                       :DiagnosticWarn
                       :WarningMsg]}]
  ;; }}}
  (each [name groups (pairs fgs)]
    (name-fg-all name groups))
  (each [name groups (pairs bgs)]
    (name-bg-all name groups))
  (each [style groups (pairs styles)]
    (hl-style-all style groups))
  (each [src dests (pairs links)]
    (link-all src dests)))
