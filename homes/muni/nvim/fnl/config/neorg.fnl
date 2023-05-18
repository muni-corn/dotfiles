(let [neorg (require :neorg)]
  (neorg.setup {:load {:core.defaults {}
                       :core.completion {:config {:engine :nvim-cmp}}
                       :core.concealer {:config {:icons {:todo {:done {:icon "󰄬"}
                                                                :pending {:icon "󰅐"}
                                                                :undone {:icon " "}}}}}
                       :core.dirman {:config {:workspaces {:notebook "~/notebook"
                                                           :work "~/notebook/work"}}}
                       :core.export {}
                       :core.export.markdown {}
                       :core.esupports.metagen {:config {:type :auto
                                                         :tab "  "}}
                       :core.keybinds {}}}))
