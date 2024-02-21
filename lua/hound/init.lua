local Source = require("hound.source")

local SourceList = {}

-- Define a function to say hello
local M = {}

-- find source in SourceList by name
local function findSourceByName(name)
	for _, src in ipairs(SourceList) do
		if src.name == name then
			return src
		end
	end

	return false
end

-- set query on current Source and open url
local function search(query)
	Source:setQuery(query)
	Source:open()
end

-- append yanked text to url & open in browser
local function searchYanked()
	local yanked_text = vim.fn.getreg("")
	search(yanked_text)
end

local function manualSearch(args)
	local entered_query = ""

	-- first elem is source name, so start with elem 2
	for i = 2, #args do
		entered_query = entered_query .. args[i] .. " "
	end

	-- trim whitespace
	entered_query = string.gsub(entered_query, "^%s*(.-)%s*$", "%1")

	search(entered_query)
end

-- Creates :Hound user command
-- expects first arg to be a source name (should match what user provided in config.sources)
-- args 2+ are optional
-- if additional args are not provided, yanked text is used for query
-- else additional args are provided, use those as the query
local function createUserCommand()
	-- create custom user command for :Hound
	vim.api.nvim_create_user_command("Hound", function(opts)
		local source_name = opts.fargs[1]
		local source_found = findSourceByName(source_name)

		-- show error msg if no source provided
		if source_found == false then
			print(
				"No source selected. Pls provide a source argument for your query. Ex - :Hound [source name] [query|omit if using yanked text]"
			)
		end

		-- set selected source
		Source:setSource(source_found)

		-- if only 1 arg provided, then get query from yank, else use rest of arg values as query
		if #opts.fargs == 1 then
			searchYanked()
		else
			manualSearch(opts.fargs)
		end
	end, { nargs = "+" })
end

-- Example setup:
-- hound.setup({
-- 	sources = { -- if using/needing more than 1 source
-- 		{
-- 			name = "go",
-- 			url = "https://google.com/search",
-- 			query_param = "q", -- use q by default
-- 			static_params = "a=b&c=d",
-- 		},
-- 		{
-- 			name = "so",
-- 			url = "https://stackoverflow.com/search",
-- 			query_param = "q",
-- 		},
-- 	},
-- })
M.setup = function(config)
	-- memo sources
	SourceList = config.sources
	-- init user command
	createUserCommand()
end

return M
