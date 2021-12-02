(let [g vim.g]
  (tset g :startify_custom_header
        ((. vim.fn "startify#fortune#cowsay") "" "═" "║" "╔" "╗" "╝"
                                              "╚"))
  (tset g :startify_lists
        [{:type :sessions :header ["   Sessions"]}
         {:type :dir :header [(.. "   Recent in " (vim.loop.cwd))]}
         {:type :files :header ["   Recent"]}
         {:type :bookmarks :header ["   Bookmarks"]}
         {:type :commands :header ["   Commands"]}])
  (tset g :startify_session_persistence 1))
