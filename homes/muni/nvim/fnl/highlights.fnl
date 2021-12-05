(let [base-cterm-map {:NONE :NONE
                      ; dark 0
                      :0 :0
                      ; dark 1
                      :1 :8
                      ; dark 2
                      :2 :18
                      ; dark 3
                      :3 :19
                      ; light 0
                      :4 :7
                      ; light 1
                      :5 :15
                      ; light 2
                      :6 :20
                      ; light 3
                      :7 :21
                      ; red
                      :8 :1
                      ; orange
                      :9 :16
                      ; yellow
                      :A :3
                      ; green
                      :B :2
                      ; cyan
                      :C :6
                      ; blue
                      :D :4
                      ; purple
                      :E :5
                      ; brown
                      :F :17}
      base-to-cterm (fn [base]
                      (. base-cterm-map base))
      base-fg (fn [hlgroup base]
                (vim.cmd (string.format "hi %s ctermfg=%s" hlgroup
                                        (base-to-cterm base))))
      base-fg-all (fn [base hlgroups]
                    (each [i hlgroup (ipairs hlgroups)]
                      (base-fg hlgroup base)))
      base-bg (fn [hlgroup base]
                (vim.cmd (string.format "hi %s ctermbg=%s" hlgroup
                                        (base-to-cterm base))))
      base-bg-all (fn [base hlgroups]
                    (each [i hlgroup (ipairs hlgroups)]
                      (base-bg hlgroup base)))
      hl-style (fn [hlgroup style]
                 (vim.cmd (string.format "hi %s cterm=%s" hlgroup style)))
      hl-style-all (fn [style hlgroups]
                     (each [i hlgroup (ipairs hlgroups)]
                       (hl-style hlgroup style)))
      ;; foregrounds {{{
      fgs {:0 [:Cursor
               :PmenuSbar
               :CustomAquaPillInside
               :CustomBluePillInside
               :CustomFuchsiaPillInside
               :CustomLimePillInside
               :CustomRedPillInside
               :CustomYellowPillInside]
           :1 [:IncSearch :PMenuSel :Substitute :CustomGrayPillOutside]
           :2 [:Search :StatusLine :StatusLineNC :VertSplit :Whitespace]
           :3 [:Comment
               :Conceal
               :Folded
               :LineNr
               :NonText
               :SpecialKey
               :TabLine
               :TabLineFill
               :VirtualText]
           :4 [:CursorLineNr :CustomGrayPillInside]
           :5 [:Normal :Operator :PMenu :PMenuThumb]
           :7 [:MatchParen]
           :8 [:Character
               :Debug
               :DiffDelete
               :Error
               :Exception
               :Identifier
               :Macro
               :Statement
               :TooLong
               :Underlined
               :VisualNOS
               :WarningMsg
               :WildMenu
               :CustomClosePillInside
               :CustomGrayRedFgPillInside
               :CustomRedPillOutside]
           :9 [:Boolean :Constant :DiffChange :Float :Number]
           :A [:CustomYellowPillOutside
               :DiffText
               :Label
               :PreProc
               :Repeat
               :StorageClass
               :Tag
               :Todo
               :Type
               :Typedef
               :Warning]
           :B [:ModeMsg
               :DiffAdd
               :MoreMsg
               :String
               :TabLineSel
               :CustomLimePillOutside
               :CustomGrayGreenFgPillInside]
           :C [:FoldColumn :Info :Special :CustomAquaPillOutside]
           :D [:Directory
               :Function
               :Include
               :Question
               :Title
               :CustomBluePillOutside]
           :E [:Define :Keyword :Structure :CustomFuchsiaPillOutside]
           :F [:Conditional :Delimiter :SpecialChar]} ;; }}}
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
           :0 [:Conceal :PmenuSbar]
           :1 [:ColorColumn
               :CursorColumn
               :CursorLine
               :CursorLineNr
               :CustomClosePillInside
               :CustomGrayGreenFgPillInside
               :CustomGrayPillInside
               :CustomGrayRedFgPillInside
               :Folded
               :MatchParen
               :PMenu
               :QuickFixLine
               :TabLine
               :TabLineSel
               :Todo]
           :2 [:IncSearch :Visual]
           :5 [:Cursor :PMenuThumb :PMenuSel]
           :8 [:CustomRedPillInside]
           :A [:CustomYellowPillInside :Substitute :Search]
           :B [:CustomLimePillInside]
           :C [:CustomAquaPillInside]
           :D [:CustomBluePillInside]
           :E [:CustomFuchsiaPillInside]} ;; }}}
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
              :bold [:CustomRedPillInside
                     :Bold
                     :CursorLineNr
                     :CustomAquaPillInside
                     :CustomBluePillInside
                     :CustomClosePillInside
                     :CustomFuchsiaPillInside
                     :CustomGrayGreenFgPillInside
                     :CustomGrayRedFgPillInside
                     :CustomLimePillInside
                     :CustomRedPillInside
                     :CustomYellowPillInside
                     :Error
                     :Info
                     :MatchParen
                     :PMenuSel
                     :Warning]
              :italic [:VirtualText
                       :CustomGrayPillInside
                       :VirtualText
                       :CustomGrayPillInside
                       :Italic]
              "bold,italic" [:Todo]
              :underline [:StatusLine :StatusLineNC]
              :undercurl [:DiagnosticUnderlineError
                          :DiagnosticUnderlineHint
                          :DiagnosticUnderlineInfo
                          :DiagnosticUnderlineWarning
                          :DiffText]
              :strikethrough [:mkdStrike :pandocStrikeout]}]
                   ;; }}}
  (each [base groups (pairs fgs)]
    (base-fg-all base groups))
  (each [base groups (pairs bgs)]
    (base-bg-all base groups))
  (each [style groups (pairs styles)]
    (hl-style-all style groups)))
