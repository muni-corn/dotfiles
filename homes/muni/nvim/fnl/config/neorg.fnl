(let [neorg (require :neorg)]
  (neorg.setup {:load {:core.defaults {}
                       :core.norg.concealer {:config {:icons {:todo {:done {:icon ""}
                                                                     :pending {:icon ""}
                                                                     :undone {:icon " "}}}}}
                       :core.export {}
                       :core.export.markdown {}
                       :core.norg.completion {:config {:engine :nvim-cmp}}
                       :core.norg.dirman {:config {:workspaces {:notebook "~/notebook"
                                                                :work "~/notebook/work"}}}
                       :core.norg.esupports.metagen {:config {:type :auto}}
                       :core.keybinds {}}}))
