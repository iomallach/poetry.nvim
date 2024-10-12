local M = {}

local Job = require("plenary.job")
local config = {
	cmd = "poetry",
}

M.execute_poetry_command = function(args)
	Job:new({
		command = "poetry",
		args = args.fargs,
		on_exit = function(j, return_val)
			if return_val == 0 then
				local result = table.concat(j:result(), "\n")
				vim.notify(result)
			else
				vim.notify("Error running poetry", vim.log.levels.ERROR)
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
	vim.api.nvim_create_user_command("P", M.execute_poetry_command, {
		nargs = "+",
		complete = function() end,
	})
end

return M
