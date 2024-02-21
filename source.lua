-- Define the Source class
local function openBuffer(contents)
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Set the buffer options
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "scratch")

	-- Set some initial contents if desired

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)

	-- Open the buffer in a new window
	vim.api.nvim_command("split")
	vim.api.nvim_command("buffer " .. buf)
end

local Source = {}

Source.__index = Source

-- Constructor function to create a new instance of Source
function Source:new()
	return setmetatable({
		name = "test",
		base_url = "",
		query_param = "",
		query = "",
		full_url = "",
	}, self)
end

function Source:setSource(src)
	self.name = src.name
	self.base_url = src.url
	self.query_param = src.query_param

	if self.query_param == nil then
		self.query_param = "q"
	end

	self.full_url = src.url .. "?" .. self.query_param .. "=%s"

	if src.static_params ~= nil then
		self.full_url = self.full_url .. "&" .. src.static_params
	end
end

function Source:setQuery(query)
	self.query = query
end

function Source:open()
	local url_with_query = string.format(self.full_url, self.query)
	vim.cmd(string.format("silent !open '%s'", url_with_query))
end

function Source:testInBuffer()
	local url_with_query = string.format(self.full_url, self.query)
	local url = string.gsub(string.format("'%s'", url_with_query), "\n", "")

	openBuffer({ url })
end

return Source:new()
