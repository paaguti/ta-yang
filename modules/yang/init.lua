-- Copyright 2013 Pedro A. Aranda. See Textadept LICENSE.
common = require("common")
local M = {}

--[[ This comment is for LuaDoc.
---
-- The makefile module.
-- It provides utilities for editing Makefiles.
--
-- @field sense
--   The makefile [Adeptsense](textadept.adeptsense.yang).
--   empty for the moment being

module('_M.yang')]]

-- TODO:
-- Compile and Run command tables use file extensions.
-- textadept.run.compile_command.yang =
--  'make  -f %(filename)'
-- textadept.run.error_detail.yang = {
--  pattern = '^(.-):(%d+): (.+)$',
--  filename = 1, line = 2, message = 3
-- }

-- Adeptsense.

-- None

-- Commands.

---
-- Table of YANG-specific key bindings.
-- @class table
-- @name _G.keys.yang
keys.yang = {
	['s\n'] = function()
    buffer:line_end()
    buffer:add_text(';')
    buffer:new_line()
	end,
  ['{'] = function() return common.enclose_keys('{', '}') end,
  ['('] = function() return common.enclose_keys('(', ')') end,

}

-- Snippets.

---
-- Table of YANG-specific snippets.
-- @class table
-- @name _G.snippets.yang
if type(snippets) == 'table' then
  snippets.yang = {
  }
end

events.connect(events.LEXER_LOADED, function(lang)
  if lang == 'yang' then
    buffer.use_tabs = false
    buffer.tab_width = 2
    buffer.wrap_mode = buffer.WRAP_WHITESPACE
  end
end)

return M
