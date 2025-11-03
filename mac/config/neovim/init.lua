if vim.g.neovide then
	for _, setting in pairs({
		-- Copy and cut.
		{ 'v', '<D-c>', '"+y' },
		{ 'v', '<D-x>', '"+d' },

		-- Paste.
		{ 'i', '<D-v>', '<ESC>l"+Pli' },
		{ 'n', '<D-v>', '"+P' },
		{ 'v', '<D-v>', '"+P' },
		{ 'c', '<D-v>', '<C-R>+' },
		{ 't', '<D-v>', '<C-\\><C-n>"+pa<Right>' },
	}) do
		vim.keymap.set(unpack(setting))
	end

	vim.g.neovide_input_macos_option_key_is_meta = 'both'	
end
