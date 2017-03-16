-- Copyright 2013 Pedro A. Aranda. See Textadept LICENSE.
common = require("common")
local M = {}

--[[ This comment is for LuaDoc.
---
-- The makefile module.
-- It provides utilities for editing Makefiles.
--
-- ## Key Bindings
--
-- + `Ctrl+L, M` (`⌘L, M` on Mac OSX | `M-L, M` in curses)
--   Open this module for editing.
-- @field sense
--   The makefile [Adeptsense](textadept.adeptsense.html).
--   empty for the moment being

module('_M.xml')]]

-- Compile and Run command tables use file extensions.
-- textadept.run.compile_command.makefile =
--  'make  -f %(filename)'
-- textadept.run.error_detail.makefile = {
--  pattern = '^(.-):(%d+): (.+)$',
--  filename = 1, line = 2, message = 3
-- }

-- Adeptsense.

-- None

-- Commands.

---
-- Table of XML-specific key bindings.
-- @class table
-- @name _G.keys.xml
keys.yang = {
--  [keys.LANGUAGE_MODULE_PREFIX] = {
--    m = {io.open_file,
--         (_HOME..'/modules/xml/init.lua'):iconv('UTF-8', _CHARSET)},
--  },
--  ['s\n'] = function()
--    buffer:line_end()
--    buffer:add_text(';')
--    buffer:new_line()
 -- end,

}

-- Snippets.

---
-- Table of XML-specific snippets.
-- @class table
-- @name _G.snippets.xml
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
