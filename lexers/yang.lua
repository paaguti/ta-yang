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

-- Strings are double quouted
local dq_str = P('L')^-1 * l.delimited_range('"', true)
local string = token(l.STRING, dq_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Identifiers.
local identifier = token(l.IDENTIFIER, (R("09","AZ","az") + P('-'))^1)

-- Datetime.
local ts = token('timestamp', l.digit * l.digit * l.digit * l.digit * -- year
                              '-' * l.digit * l.digit * -- month
                              '-' * l.digit * l.digit -- day 
)

-- kewwords.
local keyword = token(l.KEYWORD, word_match{
  'anyxml',
  'argument',
  'augment',
  'base',
  'belongs-to',
  'bit',
  'case',
  'choice',
  'config',
  'contact',
  'container',
  'default',
  'description',
  'deviate',
  'deviation',
  'enum',
  'error-app-tag',
  'error-message',
  'extension',
  'feature',
  'fraction-digits',
  'grouping',
  'identity',
  'if-feature',
  'import',
  'include',
  'input',
  'key',
  'leaf',
  'leaf-list',
  'length',
  'list',
  'mandatory',
  'max-elements',
  'min-elements',
  'module',
  'must',
  'namespace',
  'notification',
  'ordered-by',
  'organization',
  'output',
  'path',
  'pattern',
  'position',
  'prefix',
  'presence',
  'range',
  'reference',
  'refine',
  'require-instance',
  'revision',
  'revision-date',
  'rpc',
  'status',
  'submodule',
  'type',
  'typedef',
  'unique',
  'units',
  'uses',
  'value',
  'when',
  'yang-version',
  'yin-element'
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

M._rules = {
  {'whitespace', ws},
  {'comment', comment},
  {'keyword', keyword},
  {'timestamp', ts},
  {'string', string},
  {'number', number},
  {'identifier', identifier},
}

M._tokenstyles = {
  timestamp = l.STYLE_NUMBER,
}

M._FOLDBYINDENTATION = true

return M