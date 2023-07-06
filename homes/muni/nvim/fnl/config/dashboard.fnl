(let [dashboard (require :dashboard)]
  (dashboard.setup {:theme :doom
                    :hide {:statusline false}
                    :config {:header [""
                                      ""
                                      ""
                                      ""
                                      ""
                                      ""
                                      "                              __                "
                                      "  ___      __    ___   __  __/\\_\\    ___ __     "
                                      "/' _ `\\  /'__`\\ / __`\\/\\ \\/\\ \\/\\ \\ /' __` __`   "
                                      "/\\ \\/\\ \\/\\  __//\\ \\L\\ \\ \\ \\_/ \\ \\ \\/\\ \\/\\ \\/\\ \\ "
                                      "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/ \\ \\_\\ \\_\\ \\_\\ \\_\\"
                                      " \\/_/\\/_/\\/____/\\/___/  \\/__/   \\/_/\\/_/\\/_/\\/_/"
                                      ""
                                      ""]
                             :center [{:icon "󱕅   "
                                       :desc "New file"
                                       :key :n
                                       :action "ene | startinsert"}
                                      {:icon "󰱽   "
                                       :desc "Find file"
                                       :key :f
                                       :keymap ", f d"
                                       :action "Telescope find_files"}
                                      {:icon "󰋚   "
                                       :desc "Recent files"
                                       :key :r
                                       :keymap ", f o"
                                       :action "Telescope oldfiles"}
                                      {:icon "󰺅   "
                                       :desc "Find words"
                                       :key :g
                                       :keymap ", g g"
                                       :action "Telescope live_grep"}
                                      {:icon "󰊢   "
                                       :desc "Git status"
                                       :key :s
                                       :keymap ", f g"
                                       :action "Telescope git_status"}
                                      {:icon "󰈆   "
                                       :desc :Quit
                                       :key :q
                                       :action :qa}]
                             :footer ["" ".  ~  *  ~  ."]}}))
