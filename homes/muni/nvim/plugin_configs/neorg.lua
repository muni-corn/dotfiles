require('neorg').setup {
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = { -- Allows for use of icons
            config = {
                icons = {
                    todo = {
                        done = {
                            icon = "✔",
                        },
                        pending = {
                            icon = "◷",
                        },
                        undone = {
                            icon = " ",
                        }
                    },
                },
            }
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp"
            }
        },
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    notebook = "~/notebook",
                    work = "~/notebook/work",
                }
            }
        },
        ["core.norg.keybinds"] = {}, -- Load all the default modules
    }
}
