require("okai.core.options")
require("okai.core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Fehler beim Klonen von lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nDrücke eine beliebige Taste zum Beenden...", "MoreMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			import = "okai.plugins",
		},
	},
	ui = {
		border = "rounded",
	},
	checker = { enabled = false },
	change_detection = { notify = false },
})
