return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local codecompanion = require 'codecompanion'
        codecompanion.setup({
            display = {
                chat = {
                    show_settings = true,
                },
                action_palette = {
                    provider = 'snacks',
                },
            },
            -- Defines adapters for code completion,
            -- @field copilot_claude Adapter for Claude model via Copilot
            --   Extends the base Copilot adapter with custom configuration
            --   The default model Copilot using is GPT-4o.
            --   Changing the model to Claude-3.5-sonnet for inline assistant.
            adapters = {
                copilot_claude = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "claude-3.5-sonnet",
                            },
                        },
                    })
                end,
                copilot_gpt41 = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "gpt-4.1",
                            },
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = 'copilot_gpt41',
                    slash_commands = {
                        ["file"] = {
                            -- Location to the slash command in CodeCompanion
                            callback = "strategies.chat.slash_commands.file",
                            description = "Select a file using snacks",
                            opts = {
                                provider = "snacks", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
                                contains_code = true,
                            },
                        },
                        ['buffer'] = {
                            opts = {
                                provider = "snacks",
                            }
                        }
                    },
                },
                inline = {
                    adapter = 'copilot_claude',
                },
            },
        })
        vim.keymap.set({ "n", "v" }, "<leader><leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    end,
}
