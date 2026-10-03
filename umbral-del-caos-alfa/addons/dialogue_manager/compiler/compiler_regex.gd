## A collection of [RegEx] for use by the [DMCompiler].
class_name DMCompilerRegEx extends RefCounted


# Crea IMPORT_REGEX e inicializa su valor con RegEx.create_from_string("import \"(?<path>[^\"]+)\" as (?<prefix>[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]+)").
var IMPORT_REGEX: RegEx = RegEx.create_from_string("import \"(?<path>[^\"]+)\" as (?<prefix>[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]+)")
# Crea USING_REGEX e inicializa su valor con RegEx.create_from_string("^using (?<state>.*)$").
var USING_REGEX: RegEx = RegEx.create_from_string("^using (?<state>.*)$")
# Crea INDENT_REGEX e inicializa su valor con RegEx.create_from_string("^\\t+").
var INDENT_REGEX: RegEx = RegEx.create_from_string("^\\t+")
# Crea VALID_TITLE_REGEX e inicializa su valor con RegEx.create_from_string("^[a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*$").
var VALID_TITLE_REGEX: RegEx = RegEx.create_from_string("^[a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*$")
# Crea BEGINS_WITH_NUMBER_REGEX e inicializa su valor con RegEx.create_from_string("^\\d").
var BEGINS_WITH_NUMBER_REGEX: RegEx = RegEx.create_from_string("^\\d")
# Crea CONDITION_REGEX e inicializa su valor con RegEx.create_from_string("(if|elif|while|else if|match|when) (?<expression>.*)\\:?").
var CONDITION_REGEX: RegEx = RegEx.create_from_string("(if|elif|while|else if|match|when) (?<expression>.*)\\:?")
# Crea WRAPPED_CONDITION_REGEX e inicializa su valor con RegEx.create_from_string("\\[if (?<expression>.*)\\]").
var WRAPPED_CONDITION_REGEX: RegEx = RegEx.create_from_string("\\[if (?<expression>.*)\\]")
# Crea MUTATION_REGEX e inicializa su valor con RegEx.create_from_string("(?<keyword>do|do!|set) (?<expression>.*)").
var MUTATION_REGEX: RegEx = RegEx.create_from_string("(?<keyword>do|do!|set) (?<expression>.*)")
# Crea STATIC_LINE_ID_REGEX e inicializa su valor con RegEx.create_from_string("\\[ID:(?<id>.*?)\\]").
var STATIC_LINE_ID_REGEX: RegEx = RegEx.create_from_string("\\[ID:(?<id>.*?)\\]")
# Crea WEIGHTED_RANDOM_SIBLINGS_REGEX e inicializa su valor con RegEx.create_from_string("^\\%(?<weight>[\\d.]+)?( \\[if (?<condition>.+?)\\])? ").
var WEIGHTED_RANDOM_SIBLINGS_REGEX: RegEx = RegEx.create_from_string("^\\%(?<weight>[\\d.]+)?( \\[if (?<condition>.+?)\\])? ")
# Crea GOTO_REGEX e inicializa su valor con RegEx.create_from_string("=><? (?<goto>.*)").
var GOTO_REGEX: RegEx = RegEx.create_from_string("=><? (?<goto>.*)")

# Crea INLINE_RANDOM_REGEX e inicializa su valor con RegEx.create_from_string("\\[\\[(?<options>.*?)\\]\\]").
var INLINE_RANDOM_REGEX: RegEx = RegEx.create_from_string("\\[\\[(?<options>.*?)\\]\\]")
# Crea INLINE_CONDITIONALS_REGEX e inicializa su valor con RegEx.create_from_string("\\[if (?<condition>.+?)\\](?<body>.*?)\\[\\/if\\]").
var INLINE_CONDITIONALS_REGEX: RegEx = RegEx.create_from_string("\\[if (?<condition>.+?)\\](?<body>.*?)\\[\\/if\\]")

# Crea TAGS_REGEX e inicializa su valor con RegEx.create_from_string("\\[#(?<tags>.*?)\\]").
var TAGS_REGEX: RegEx = RegEx.create_from_string("\\[#(?<tags>.*?)\\]")

# Crea REPLACEMENTS_REGEX e inicializa su valor con RegEx.create_from_string("{{(.*?)}}").
var REPLACEMENTS_REGEX: RegEx = RegEx.create_from_string("{{(.*?)}}")

# Crea ALPHA_NUMERIC e inicializa su valor con RegEx.create_from_string("[^a-zA-Z0-9\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]+").
var ALPHA_NUMERIC: RegEx = RegEx.create_from_string("[^a-zA-Z0-9\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]+")

# Crea TOKEN_DEFINITIONS e inicializa su valor con {.
var TOKEN_DEFINITIONS: Dictionary = {
	# Ejecuta esta instruccion: DMConstants.TOKEN_FUNCTION: RegEx.create_from_string("^[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*\\("),.
	DMConstants.TOKEN_FUNCTION: RegEx.create_from_string("^[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*\\("),
	# Ejecuta esta instruccion: DMConstants.TOKEN_DICTIONARY_REFERENCE: RegEx.create_from_string("^[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*\\["),.
	DMConstants.TOKEN_DICTIONARY_REFERENCE: RegEx.create_from_string("^[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*\\["),
	# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_OPEN: RegEx.create_from_string("^\\("),.
	DMConstants.TOKEN_PARENS_OPEN: RegEx.create_from_string("^\\("),
	# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_CLOSE: RegEx.create_from_string("^\\)"),.
	DMConstants.TOKEN_PARENS_CLOSE: RegEx.create_from_string("^\\)"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_OPEN: RegEx.create_from_string("^\\["),.
	DMConstants.TOKEN_BRACKET_OPEN: RegEx.create_from_string("^\\["),
	# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_CLOSE: RegEx.create_from_string("^\\]"),.
	DMConstants.TOKEN_BRACKET_CLOSE: RegEx.create_from_string("^\\]"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_OPEN: RegEx.create_from_string("^\\{"),.
	DMConstants.TOKEN_BRACE_OPEN: RegEx.create_from_string("^\\{"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_CLOSE: RegEx.create_from_string("^\\}"),.
	DMConstants.TOKEN_BRACE_CLOSE: RegEx.create_from_string("^\\}"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_COLON: RegEx.create_from_string("^:"),.
	DMConstants.TOKEN_COLON: RegEx.create_from_string("^:"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_COMPARISON: RegEx.create_from_string("^(==|<=|>=|<|>|!=|in )"),.
	DMConstants.TOKEN_COMPARISON: RegEx.create_from_string("^(==|<=|>=|<|>|!=|in )"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT: RegEx.create_from_string("^(\\+=|\\-=|\\*=|/=|=)"),.
	DMConstants.TOKEN_ASSIGNMENT: RegEx.create_from_string("^(\\+=|\\-=|\\*=|/=|=)"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER: RegEx.create_from_string("^\\-?\\d+(\\.\\d+)?"),.
	DMConstants.TOKEN_NUMBER: RegEx.create_from_string("^\\-?\\d+(\\.\\d+)?"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_OPERATOR: RegEx.create_from_string("^(\\+|\\-|\\*|/|%)"),.
	DMConstants.TOKEN_OPERATOR: RegEx.create_from_string("^(\\+|\\-|\\*|/|%)"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA: RegEx.create_from_string("^,"),.
	DMConstants.TOKEN_COMMA: RegEx.create_from_string("^,"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_NULL_COALESCE: RegEx.create_from_string("^\\?\\."),.
	DMConstants.TOKEN_NULL_COALESCE: RegEx.create_from_string("^\\?\\."),
	# Ejecuta esta instruccion: DMConstants.TOKEN_DOT: RegEx.create_from_string("^\\."),.
	DMConstants.TOKEN_DOT: RegEx.create_from_string("^\\."),
	# Ejecuta esta instruccion: DMConstants.TOKEN_STRING: RegEx.create_from_string("^&?(\".*?\"|\'.*?\')"),.
	DMConstants.TOKEN_STRING: RegEx.create_from_string("^&?(\".*?\"|\'.*?\')"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_NOT: RegEx.create_from_string("^(not( |$)|!)"),.
	DMConstants.TOKEN_NOT: RegEx.create_from_string("^(not( |$)|!)"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_AND_OR: RegEx.create_from_string("^(and|or|&&|\\|\\|)( |$)"),.
	DMConstants.TOKEN_AND_OR: RegEx.create_from_string("^(and|or|&&|\\|\\|)( |$)"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE: RegEx.create_from_string("^[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*"),.
	DMConstants.TOKEN_VARIABLE: RegEx.create_from_string("^[a-zA-Z_\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}][a-zA-Z_0-9\\p{Emoji_Presentation}\\p{Han}\\p{Katakana}\\p{Hiragana}\\p{Cyrillic}]*"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_COMMENT: RegEx.create_from_string("^#.*"),.
	DMConstants.TOKEN_COMMENT: RegEx.create_from_string("^#.*"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_CONDITION: RegEx.create_from_string("^(if|elif|else)"),.
	DMConstants.TOKEN_CONDITION: RegEx.create_from_string("^(if|elif|else)"),
	# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL: RegEx.create_from_string("^(true|false)").
	DMConstants.TOKEN_BOOL: RegEx.create_from_string("^(true|false)")
}
