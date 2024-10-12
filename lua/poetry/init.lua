local M = {}

local Job = require("plenary.job")
local config = {
	cmd = "poetry",
	user_cmd = "P",
}

M.execute_poetry_command = function(args)
	Job:new({
		command = config.cmd,
		args = args.fargs,
		on_exit = function(j, return_val)
			local result = table.concat(j:result(), "\n")
			if return_val == 0 then
				vim.notify(result)
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.notify("Poetry error: " .. data, vim.log.levels.ERROR)
			end
		end,
	}):start()
end

M.setup = function(opts)
	config = vim.tbl_deep_extend("force", config, opts)
end

M.setup_user_command = function()
	vim.api.nvim_create_user_command(config.user_cmd, M.execute_poetry_command, {
		nargs = "+",
		complete = function() end,
	})
end

return M
