(let [neorg (require :neorg)]
  (neorg.setup {:load {:core.defaults {}
                       :core.concealer {:config {:icons {:todo {:done {:icon "󰄬"}
                                                                :pending {:icon "󰅐"}
                                                                :undone {:icon " "}}}}}
                       :core.export {}
                       :core.export.markdown {}
                       :core.completion {:config {:engine :nvim-cmp}}
                       :core.dirman {:config {:workspaces {:notebook "~/notebook"
                                                           :work "~/notebook/work"}}}
                       :core.esupports.metagen {:config {:type :auto}}
                       :core.keybinds {}}}))
