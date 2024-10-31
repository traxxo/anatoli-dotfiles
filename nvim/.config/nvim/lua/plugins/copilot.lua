return {
	"zbirenbaum/copilot.lua",
	event = "VimEnter",
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-l>",
					next = "<C-]>",
					prev = "<C-[>",				}
			},
			filetypes = {

				yaml = true,
				markdown = true,
			},
		})
	end,
}
