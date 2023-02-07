local filetype = require("filetype")

filetype.setup({
  overrides = {
    -- extensions = {
    -- 	["blade.php"] = "blade",
    -- },
    -- function_extensions = {
    -- 	["blade.php"] = function()
    -- 		-- print("php blade")
    -- 		vim.bo.filetype = "blade"
    -- 	end,
    -- },
    extensions = {
      mdx = "markdown",
    },
    -- complex = {
    -- 	["*.blade.php"] = "blade",
    -- },
    function_complex = {
      [".*blade.php"] = function()
        vim.bo.filetype = "blade"
      end,
    },
  },
})
