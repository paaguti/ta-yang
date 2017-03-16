--- YANG (RFC6020) LPeg lexer.
-- Used yaml.lua and lua.lua for reference.
-- @author [Pedro A. Aranda](https://github.com/paaguti)
-- copyright 2017
-- @license MIT (see LICENSE)
-- @module yang

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'yang'}

-- Whitespace
-- TODO: indentation

local ws = token(l.WHITESPACE, l.space^1)

-- Comments from C++
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings are double quouted and can be multiline (!)
local dqm_str = l.delimited_range('"', false)
local string = token(l.STRING, dqm_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

local operator = token(l.OPERATOR, S(';{}'))

-- Identifiers.
local simple_ident = (R("09","AZ","az") + S('-'))^1
local identifier = token(l.IDENTIFIER, simple_ident)

-- Derived types
local _class = (simple_ident * (S(':') * simple_ident)^1)
local class = token(l.CLASS, _class)

local func = token(l.FUNCTION, (S('/') * _class * (S('/') * _class)^0))

-- Datetime.
local ts = token('custom_ts', 
  l.digit * l.digit * l.digit * l.digit * -- year
  '-' * l.digit * l.digit * -- month
  '-' * l.digit * l.digit -- day 
)

-- kewwords.
local keyword = token(l.KEYWORD, (word_match ({
  'anyxml',  'argument',  'augment',
  'base',  'bit',
  'case',  'choice',  'config',  'contact',  'container',
  'default',  'description',  'deviate',  'deviation',
  'enum',  'extension',
  'feature',
  'grouping',
  'identity',  'import',  'include',  'input',
  'key',
  'leaf',  'length',  'list',
  'mandatory',  'module',  'must',
  'namespace',  'notification',
  'organization',  'output',
  'path',  'pattern',  'position',  'prefix',  'presence',
  'range',  'reference',  'refine',  'revision',  'rpc',
  'status',  'submodule',
  'type',  'typedef',
  'unique',  'units',  'uses',
  'value',
  'when' }) + word_match({
  'belongs-to',
  'error-app-tag',  'error-message',
  'fraction-digits',
  'if-feature',
  'leaf-list',
  'min-elements',  'max-elements',
  'ordered-by',
  'require-instance',  'revision-date',
  'yang-version',  'yin-element'
},'-')))

-- builtin integer types

local builtin_types = token(l.TYPE, word_match{
  'int8',   'int16',   'int32',   'int64',
  'uint8',  'uint16',  'uint32',  'uint64'
})
   
M._rules = {
  {'whitespace', ws},
  {'comment', comment},
  {'keyword', keyword},
  {'timestamp', ts},
  {'string', string},
  {'number', number},
  {'function', func},
  {'type', builtin_types},
  {'class', class},
  {'identifier', identifier},
  {'operator', operator},
  {'error', token(l.ERROR, l.any)},
}

local italic_number_style = l.STYLE_NUMBER .. ',italics'
M._tokenstyles = {
  custom_ts = italic_number_style
}

M._FOLDBYINDENTATION = true

return M
