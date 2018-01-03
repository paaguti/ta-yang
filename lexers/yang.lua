--- YANG (RFC6020) LPeg lexer.
-- Used yaml.lua and lua.lua for reference.
-- @author [Pedro A. Aranda](https://github.com/paaguti)
-- copyright 2017-18
-- 17-01-03: migrate to OOlexer
-- @license MIT (see LICENSE)
-- @module yang

-- TODO: indentation
local lexer = require("lexer")
local token, word_match = lexer.token, lexer.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local lex = lexer.new('yang', { fold_by_indentation = true })

-- Whitespace
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Comments from C++ and C are accepted in YANG
local line_comment = '//' * lexer.nonnewline_esc^0
local block_comment = '/*' * (lexer.any - '*/')^0 * P('*/')^-1
lex:add_rule('comment', token(lexer.COMMENT, line_comment + block_comment))

-- keywords.
lex:add_rule('keyword',
  token(lexer.KEYWORD, (word_match ({
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
    'when' }) +
  word_match({
    'belongs-to',
    'error-app-tag',  'error-message',
    'fraction-digits',
    'if-feature',
    'leaf-list',
    'min-elements',  'max-elements',
    'ordered-by',
    'require-instance',  'revision-date',
    'yang-version',  'yin-element'
  },'-'))))

-- Datetime.
lex:add_rule('timestamp', token('custom_ts',
  lexer.digit * lexer.digit * lexer.digit * lexer.digit * -- year
  '-' * lexer.digit * lexer.digit * -- month
  '-' * lexer.digit * lexer.digit -- day
))
lex:add_style('custom_ts', lexer.STYLE_NUMBER .. ',italics')

-- Strings are double quouted and can be multiline (!)
local dqm_str = lexer.delimited_range('"', false)
lex:add_rule('string', token(lexer.STRING, dqm_str))


-- Numbers.
lex:add_rule('number', token(lexer.NUMBER, lexer.float + lexer.integer))

-- Identifiers.
local simple_ident = (R("09","AZ","az") + S('-'))^1
local _class = (simple_ident * (S(':') * simple_ident)^1)

-- Functions
lex:add_rule('function',  token(lexer.FUNCTION, (S('/') * _class * (S('/') * _class)^0)))

-- builtin integer types
lex:add_rule('type', token(lexer.TYPE, word_match{
  'int8',   'int16',   'int32',   'int64',
  'uint8',  'uint16',  'uint32',  'uint64'
}))

-- Derived types
lex:add_rule('class', token(lexer.CLASS, _class))

lex:add_rule('identifier', token(lexer.IDENTIFIER, simple_ident))

lex:add_rule('operator', token(lexer.OPERATOR, S(';{}')))

lex:add_rule('error', token(lexer.ERROR, lexer.any))

return lex
