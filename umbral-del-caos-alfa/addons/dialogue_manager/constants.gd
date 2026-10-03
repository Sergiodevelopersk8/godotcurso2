# Registra DMConstants como nombre de clase global para usarlo en otros scripts.
class_name DMConstants extends RefCounted


# Define USER_CONFIG_PATH con el valor fijo "user://dialogue_manager_user_config.json".
const USER_CONFIG_PATH = "user://dialogue_manager_user_config.json"
# Define CACHE_PATH con el valor fijo "user://dialogue_manager_cache.json".
const CACHE_PATH = "user://dialogue_manager_cache.json"


# Ejecuta esta instruccion: enum MutationBehaviour {.
enum MutationBehaviour {
	# Ejecuta esta instruccion: Wait,.
	Wait,
	# Ejecuta esta instruccion: DoNotWait,.
	DoNotWait,
	# Ejecuta esta instruccion: Skip.
	Skip
}

# Ejecuta esta instruccion: enum TranslationSource {.
enum TranslationSource {
	# Ejecuta esta instruccion: None,.
	None,
	# Ejecuta esta instruccion: Guess,.
	Guess,
	# Ejecuta esta instruccion: CSV,.
	CSV,
	# Ejecuta esta instruccion: PO.
	PO
}

# Token types

# Define TOKEN_FUNCTION con el valor fijo &"function".
const TOKEN_FUNCTION = &"function"
# Define TOKEN_DICTIONARY_REFERENCE con el valor fijo &"dictionary_reference".
const TOKEN_DICTIONARY_REFERENCE = &"dictionary_reference"
# Define TOKEN_DICTIONARY_NESTED_REFERENCE con el valor fijo &"dictionary_nested_reference".
const TOKEN_DICTIONARY_NESTED_REFERENCE = &"dictionary_nested_reference"
# Define TOKEN_GROUP con el valor fijo &"group".
const TOKEN_GROUP = &"group"
# Define TOKEN_ARRAY con el valor fijo &"array".
const TOKEN_ARRAY = &"array"
# Define TOKEN_DICTIONARY con el valor fijo &"dictionary".
const TOKEN_DICTIONARY = &"dictionary"
# Define TOKEN_PARENS_OPEN con el valor fijo &"parens_open".
const TOKEN_PARENS_OPEN = &"parens_open"
# Define TOKEN_PARENS_CLOSE con el valor fijo &"parens_close".
const TOKEN_PARENS_CLOSE = &"parens_close"
# Define TOKEN_BRACKET_OPEN con el valor fijo &"bracket_open".
const TOKEN_BRACKET_OPEN = &"bracket_open"
# Define TOKEN_BRACKET_CLOSE con el valor fijo &"bracket_close".
const TOKEN_BRACKET_CLOSE = &"bracket_close"
# Define TOKEN_BRACE_OPEN con el valor fijo &"brace_open".
const TOKEN_BRACE_OPEN = &"brace_open"
# Define TOKEN_BRACE_CLOSE con el valor fijo &"brace_close".
const TOKEN_BRACE_CLOSE = &"brace_close"
# Define TOKEN_COLON con el valor fijo &"colon".
const TOKEN_COLON = &"colon"
# Define TOKEN_COMPARISON con el valor fijo &"comparison".
const TOKEN_COMPARISON = &"comparison"
# Define TOKEN_ASSIGNMENT con el valor fijo &"assignment".
const TOKEN_ASSIGNMENT = &"assignment"
# Define TOKEN_OPERATOR con el valor fijo &"operator".
const TOKEN_OPERATOR = &"operator"
# Define TOKEN_COMMA con el valor fijo &"comma".
const TOKEN_COMMA = &"comma"
# Define TOKEN_NULL_COALESCE con el valor fijo &"null_coalesce".
const TOKEN_NULL_COALESCE = &"null_coalesce"
# Define TOKEN_DOT con el valor fijo &"dot".
const TOKEN_DOT = &"dot"
# Define TOKEN_CONDITION con el valor fijo &"condition".
const TOKEN_CONDITION = &"condition"
# Define TOKEN_BOOL con el valor fijo &"bool".
const TOKEN_BOOL = &"bool"
# Define TOKEN_NOT con el valor fijo &"not".
const TOKEN_NOT = &"not"
# Define TOKEN_AND_OR con el valor fijo &"and_or".
const TOKEN_AND_OR = &"and_or"
# Define TOKEN_STRING con el valor fijo &"string".
const TOKEN_STRING = &"string"
# Define TOKEN_NUMBER con el valor fijo &"number".
const TOKEN_NUMBER = &"number"
# Define TOKEN_VARIABLE con el valor fijo &"variable".
const TOKEN_VARIABLE = &"variable"
# Define TOKEN_COMMENT con el valor fijo &"comment".
const TOKEN_COMMENT = &"comment"

# Define TOKEN_VALUE con el valor fijo &"value".
const TOKEN_VALUE = &"value"
# Define TOKEN_ERROR con el valor fijo &"error".
const TOKEN_ERROR = &"error"

# Line types

# Define TYPE_UNKNOWN con el valor fijo &"".
const TYPE_UNKNOWN = &""
# Define TYPE_IMPORT con el valor fijo &"import".
const TYPE_IMPORT = &"import"
# Define TYPE_USING con el valor fijo &"using".
const TYPE_USING = &"using"
# Define TYPE_COMMENT con el valor fijo &"comment".
const TYPE_COMMENT = &"comment"
# Define TYPE_RESPONSE con el valor fijo &"response".
const TYPE_RESPONSE = &"response"
# Define TYPE_TITLE con el valor fijo &"title".
const TYPE_TITLE = &"title"
# Define TYPE_CONDITION con el valor fijo &"condition".
const TYPE_CONDITION = &"condition"
# Define TYPE_WHILE con el valor fijo &"while".
const TYPE_WHILE = &"while"
# Define TYPE_MATCH con el valor fijo &"match".
const TYPE_MATCH = &"match"
# Define TYPE_WHEN con el valor fijo &"when".
const TYPE_WHEN = &"when"
# Define TYPE_MUTATION con el valor fijo &"mutation".
const TYPE_MUTATION = &"mutation"
# Define TYPE_GOTO con el valor fijo &"goto".
const TYPE_GOTO = &"goto"
# Define TYPE_DIALOGUE con el valor fijo &"dialogue".
const TYPE_DIALOGUE = &"dialogue"
# Define TYPE_RANDOM con el valor fijo &"random".
const TYPE_RANDOM = &"random"
# Define TYPE_ERROR con el valor fijo &"error".
const TYPE_ERROR = &"error"

# Line IDs

# Define ID_NULL con el valor fijo &"".
const ID_NULL = &""
# Define ID_ERROR con el valor fijo &"error".
const ID_ERROR = &"error"
# Define ID_ERROR_INVALID_TITLE con el valor fijo &"invalid title".
const ID_ERROR_INVALID_TITLE = &"invalid title"
# Define ID_ERROR_TITLE_HAS_NO_BODY con el valor fijo &"title has no body".
const ID_ERROR_TITLE_HAS_NO_BODY = &"title has no body"
# Define ID_END con el valor fijo &"end".
const ID_END = &"end"
# Define ID_END_CONVERSATION con el valor fijo &"end!".
const ID_END_CONVERSATION = &"end!"

# Errors

# Define ERR_ERRORS_IN_IMPORTED_FILE con el valor fijo 100.
const ERR_ERRORS_IN_IMPORTED_FILE = 100
# Define ERR_FILE_ALREADY_IMPORTED con el valor fijo 101.
const ERR_FILE_ALREADY_IMPORTED = 101
# Define ERR_DUPLICATE_IMPORT_NAME con el valor fijo 102.
const ERR_DUPLICATE_IMPORT_NAME = 102
# Define ERR_EMPTY_TITLE con el valor fijo 103.
const ERR_EMPTY_TITLE = 103
# Define ERR_DUPLICATE_TITLE con el valor fijo 104.
const ERR_DUPLICATE_TITLE = 104
# Define ERR_TITLE_INVALID_CHARACTERS con el valor fijo 106.
const ERR_TITLE_INVALID_CHARACTERS = 106
# Define ERR_UNKNOWN_TITLE con el valor fijo 107.
const ERR_UNKNOWN_TITLE = 107
# Define ERR_INVALID_TITLE_REFERENCE con el valor fijo 108.
const ERR_INVALID_TITLE_REFERENCE = 108
# Define ERR_TITLE_REFERENCE_HAS_NO_CONTENT con el valor fijo 109.
const ERR_TITLE_REFERENCE_HAS_NO_CONTENT = 109
# Define ERR_INVALID_EXPRESSION con el valor fijo 110.
const ERR_INVALID_EXPRESSION = 110
# Define ERR_UNEXPECTED_CONDITION con el valor fijo 111.
const ERR_UNEXPECTED_CONDITION = 111
# Define ERR_DUPLICATE_ID con el valor fijo 112.
const ERR_DUPLICATE_ID = 112
# Define ERR_MISSING_ID con el valor fijo 113.
const ERR_MISSING_ID = 113
# Define ERR_INVALID_INDENTATION con el valor fijo 114.
const ERR_INVALID_INDENTATION = 114
# Define ERR_INVALID_CONDITION_INDENTATION con el valor fijo 115.
const ERR_INVALID_CONDITION_INDENTATION = 115
# Define ERR_INCOMPLETE_EXPRESSION con el valor fijo 116.
const ERR_INCOMPLETE_EXPRESSION = 116
# Define ERR_INVALID_EXPRESSION_FOR_VALUE con el valor fijo 117.
const ERR_INVALID_EXPRESSION_FOR_VALUE = 117
# Define ERR_UNKNOWN_LINE_SYNTAX con el valor fijo 118.
const ERR_UNKNOWN_LINE_SYNTAX = 118
# Define ERR_TITLE_BEGINS_WITH_NUMBER con el valor fijo 119.
const ERR_TITLE_BEGINS_WITH_NUMBER = 119
# Define ERR_UNEXPECTED_END_OF_EXPRESSION con el valor fijo 120.
const ERR_UNEXPECTED_END_OF_EXPRESSION = 120
# Define ERR_UNEXPECTED_FUNCTION con el valor fijo 121.
const ERR_UNEXPECTED_FUNCTION = 121
# Define ERR_UNEXPECTED_BRACKET con el valor fijo 122.
const ERR_UNEXPECTED_BRACKET = 122
# Define ERR_UNEXPECTED_CLOSING_BRACKET con el valor fijo 123.
const ERR_UNEXPECTED_CLOSING_BRACKET = 123
# Define ERR_MISSING_CLOSING_BRACKET con el valor fijo 124.
const ERR_MISSING_CLOSING_BRACKET = 124
# Define ERR_UNEXPECTED_OPERATOR con el valor fijo 125.
const ERR_UNEXPECTED_OPERATOR = 125
# Define ERR_UNEXPECTED_COMMA con el valor fijo 126.
const ERR_UNEXPECTED_COMMA = 126
# Define ERR_UNEXPECTED_COLON con el valor fijo 127.
const ERR_UNEXPECTED_COLON = 127
# Define ERR_UNEXPECTED_DOT con el valor fijo 128.
const ERR_UNEXPECTED_DOT = 128
# Define ERR_UNEXPECTED_BOOLEAN con el valor fijo 129.
const ERR_UNEXPECTED_BOOLEAN = 129
# Define ERR_UNEXPECTED_STRING con el valor fijo 130.
const ERR_UNEXPECTED_STRING = 130
# Define ERR_UNEXPECTED_NUMBER con el valor fijo 131.
const ERR_UNEXPECTED_NUMBER = 131
# Define ERR_UNEXPECTED_VARIABLE con el valor fijo 132.
const ERR_UNEXPECTED_VARIABLE = 132
# Define ERR_INVALID_INDEX con el valor fijo 133.
const ERR_INVALID_INDEX = 133
# Define ERR_UNEXPECTED_ASSIGNMENT con el valor fijo 134.
const ERR_UNEXPECTED_ASSIGNMENT = 134
# Define ERR_UNKNOWN_USING con el valor fijo 135.
const ERR_UNKNOWN_USING = 135
# Define ERR_EXPECTED_WHEN_OR_ELSE con el valor fijo 136.
const ERR_EXPECTED_WHEN_OR_ELSE = 136
# Define ERR_ONLY_ONE_ELSE_ALLOWED con el valor fijo 137.
const ERR_ONLY_ONE_ELSE_ALLOWED = 137
# Define ERR_WHEN_MUST_BELONG_TO_MATCH con el valor fijo 138.
const ERR_WHEN_MUST_BELONG_TO_MATCH = 138
# Define ERR_CONCURRENT_LINE_WITHOUT_ORIGIN con el valor fijo 139.
const ERR_CONCURRENT_LINE_WITHOUT_ORIGIN = 139
# Define ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES con el valor fijo 140.
const ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES = 140
# Define ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE con el valor fijo 141.
const ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE = 141
# Define ERR_NESTED_DIALOGUE_INVALID_JUMP con el valor fijo 142.
const ERR_NESTED_DIALOGUE_INVALID_JUMP = 142


## Get the error message
static func get_error_message(error: int) -> String:
	# Compara error con los casos siguientes y ejecuta el que coincida.
	match error:
		# Asocia la clave ERR_ERRORS_IN_IMPORTED_FILE con  dentro del diccionario.
		ERR_ERRORS_IN_IMPORTED_FILE:
			# Termina el metodo y devuelve translate(&"errors.import_errors") a quien lo llamo.
			return translate(&"errors.import_errors")
		# Asocia la clave ERR_FILE_ALREADY_IMPORTED con  dentro del diccionario.
		ERR_FILE_ALREADY_IMPORTED:
			# Termina el metodo y devuelve translate(&"errors.already_imported") a quien lo llamo.
			return translate(&"errors.already_imported")
		# Asocia la clave ERR_DUPLICATE_IMPORT_NAME con  dentro del diccionario.
		ERR_DUPLICATE_IMPORT_NAME:
			# Termina el metodo y devuelve translate(&"errors.duplicate_import") a quien lo llamo.
			return translate(&"errors.duplicate_import")
		# Asocia la clave ERR_EMPTY_TITLE con  dentro del diccionario.
		ERR_EMPTY_TITLE:
			# Termina el metodo y devuelve translate(&"errors.empty_title") a quien lo llamo.
			return translate(&"errors.empty_title")
		# Asocia la clave ERR_DUPLICATE_TITLE con  dentro del diccionario.
		ERR_DUPLICATE_TITLE:
			# Termina el metodo y devuelve translate(&"errors.duplicate_title") a quien lo llamo.
			return translate(&"errors.duplicate_title")
		# Asocia la clave ERR_TITLE_INVALID_CHARACTERS con  dentro del diccionario.
		ERR_TITLE_INVALID_CHARACTERS:
			# Termina el metodo y devuelve translate(&"errors.invalid_title_string") a quien lo llamo.
			return translate(&"errors.invalid_title_string")
		# Asocia la clave ERR_TITLE_BEGINS_WITH_NUMBER con  dentro del diccionario.
		ERR_TITLE_BEGINS_WITH_NUMBER:
			# Termina el metodo y devuelve translate(&"errors.invalid_title_number") a quien lo llamo.
			return translate(&"errors.invalid_title_number")
		# Asocia la clave ERR_UNKNOWN_TITLE con  dentro del diccionario.
		ERR_UNKNOWN_TITLE:
			# Termina el metodo y devuelve translate(&"errors.unknown_title") a quien lo llamo.
			return translate(&"errors.unknown_title")
		# Asocia la clave ERR_INVALID_TITLE_REFERENCE con  dentro del diccionario.
		ERR_INVALID_TITLE_REFERENCE:
			# Termina el metodo y devuelve translate(&"errors.jump_to_invalid_title") a quien lo llamo.
			return translate(&"errors.jump_to_invalid_title")
		# Asocia la clave ERR_TITLE_REFERENCE_HAS_NO_CONTENT con  dentro del diccionario.
		ERR_TITLE_REFERENCE_HAS_NO_CONTENT:
			# Termina el metodo y devuelve translate(&"errors.title_has_no_content") a quien lo llamo.
			return translate(&"errors.title_has_no_content")
		# Asocia la clave ERR_INVALID_EXPRESSION con  dentro del diccionario.
		ERR_INVALID_EXPRESSION:
			# Termina el metodo y devuelve translate(&"errors.invalid_expression") a quien lo llamo.
			return translate(&"errors.invalid_expression")
		# Asocia la clave ERR_UNEXPECTED_CONDITION con  dentro del diccionario.
		ERR_UNEXPECTED_CONDITION:
			# Termina el metodo y devuelve translate(&"errors.unexpected_condition") a quien lo llamo.
			return translate(&"errors.unexpected_condition")
		# Asocia la clave ERR_DUPLICATE_ID con  dentro del diccionario.
		ERR_DUPLICATE_ID:
			# Termina el metodo y devuelve translate(&"errors.duplicate_id") a quien lo llamo.
			return translate(&"errors.duplicate_id")
		# Asocia la clave ERR_MISSING_ID con  dentro del diccionario.
		ERR_MISSING_ID:
			# Termina el metodo y devuelve translate(&"errors.missing_id") a quien lo llamo.
			return translate(&"errors.missing_id")
		# Asocia la clave ERR_INVALID_INDENTATION con  dentro del diccionario.
		ERR_INVALID_INDENTATION:
			# Termina el metodo y devuelve translate(&"errors.invalid_indentation") a quien lo llamo.
			return translate(&"errors.invalid_indentation")
		# Asocia la clave ERR_INVALID_CONDITION_INDENTATION con  dentro del diccionario.
		ERR_INVALID_CONDITION_INDENTATION:
			# Termina el metodo y devuelve translate(&"errors.condition_has_no_content") a quien lo llamo.
			return translate(&"errors.condition_has_no_content")
		# Asocia la clave ERR_INCOMPLETE_EXPRESSION con  dentro del diccionario.
		ERR_INCOMPLETE_EXPRESSION:
			# Termina el metodo y devuelve translate(&"errors.incomplete_expression") a quien lo llamo.
			return translate(&"errors.incomplete_expression")
		# Asocia la clave ERR_INVALID_EXPRESSION_FOR_VALUE con  dentro del diccionario.
		ERR_INVALID_EXPRESSION_FOR_VALUE:
			# Termina el metodo y devuelve translate(&"errors.invalid_expression_for_value") a quien lo llamo.
			return translate(&"errors.invalid_expression_for_value")
		# Asocia la clave ERR_FILE_NOT_FOUND con  dentro del diccionario.
		ERR_FILE_NOT_FOUND:
			# Termina el metodo y devuelve translate(&"errors.file_not_found") a quien lo llamo.
			return translate(&"errors.file_not_found")
		# Asocia la clave ERR_UNEXPECTED_END_OF_EXPRESSION con  dentro del diccionario.
		ERR_UNEXPECTED_END_OF_EXPRESSION:
			# Termina el metodo y devuelve translate(&"errors.unexpected_end_of_expression") a quien lo llamo.
			return translate(&"errors.unexpected_end_of_expression")
		# Asocia la clave ERR_UNEXPECTED_FUNCTION con  dentro del diccionario.
		ERR_UNEXPECTED_FUNCTION:
			# Termina el metodo y devuelve translate(&"errors.unexpected_function") a quien lo llamo.
			return translate(&"errors.unexpected_function")
		# Asocia la clave ERR_UNEXPECTED_BRACKET con  dentro del diccionario.
		ERR_UNEXPECTED_BRACKET:
			# Termina el metodo y devuelve translate(&"errors.unexpected_bracket") a quien lo llamo.
			return translate(&"errors.unexpected_bracket")
		# Asocia la clave ERR_UNEXPECTED_CLOSING_BRACKET con  dentro del diccionario.
		ERR_UNEXPECTED_CLOSING_BRACKET:
			# Termina el metodo y devuelve translate(&"errors.unexpected_closing_bracket") a quien lo llamo.
			return translate(&"errors.unexpected_closing_bracket")
		# Asocia la clave ERR_MISSING_CLOSING_BRACKET con  dentro del diccionario.
		ERR_MISSING_CLOSING_BRACKET:
			# Termina el metodo y devuelve translate(&"errors.missing_closing_bracket") a quien lo llamo.
			return translate(&"errors.missing_closing_bracket")
		# Asocia la clave ERR_UNEXPECTED_OPERATOR con  dentro del diccionario.
		ERR_UNEXPECTED_OPERATOR:
			# Termina el metodo y devuelve translate(&"errors.unexpected_operator") a quien lo llamo.
			return translate(&"errors.unexpected_operator")
		# Asocia la clave ERR_UNEXPECTED_COMMA con  dentro del diccionario.
		ERR_UNEXPECTED_COMMA:
			# Termina el metodo y devuelve translate(&"errors.unexpected_comma") a quien lo llamo.
			return translate(&"errors.unexpected_comma")
		# Asocia la clave ERR_UNEXPECTED_COLON con  dentro del diccionario.
		ERR_UNEXPECTED_COLON:
			# Termina el metodo y devuelve translate(&"errors.unexpected_colon") a quien lo llamo.
			return translate(&"errors.unexpected_colon")
		# Asocia la clave ERR_UNEXPECTED_DOT con  dentro del diccionario.
		ERR_UNEXPECTED_DOT:
			# Termina el metodo y devuelve translate(&"errors.unexpected_dot") a quien lo llamo.
			return translate(&"errors.unexpected_dot")
		# Asocia la clave ERR_UNEXPECTED_BOOLEAN con  dentro del diccionario.
		ERR_UNEXPECTED_BOOLEAN:
			# Termina el metodo y devuelve translate(&"errors.unexpected_boolean") a quien lo llamo.
			return translate(&"errors.unexpected_boolean")
		# Asocia la clave ERR_UNEXPECTED_STRING con  dentro del diccionario.
		ERR_UNEXPECTED_STRING:
			# Termina el metodo y devuelve translate(&"errors.unexpected_string") a quien lo llamo.
			return translate(&"errors.unexpected_string")
		# Asocia la clave ERR_UNEXPECTED_NUMBER con  dentro del diccionario.
		ERR_UNEXPECTED_NUMBER:
			# Termina el metodo y devuelve translate(&"errors.unexpected_number") a quien lo llamo.
			return translate(&"errors.unexpected_number")
		# Asocia la clave ERR_UNEXPECTED_VARIABLE con  dentro del diccionario.
		ERR_UNEXPECTED_VARIABLE:
			# Termina el metodo y devuelve translate(&"errors.unexpected_variable") a quien lo llamo.
			return translate(&"errors.unexpected_variable")
		# Asocia la clave ERR_INVALID_INDEX con  dentro del diccionario.
		ERR_INVALID_INDEX:
			# Termina el metodo y devuelve translate(&"errors.invalid_index") a quien lo llamo.
			return translate(&"errors.invalid_index")
		# Asocia la clave ERR_UNEXPECTED_ASSIGNMENT con  dentro del diccionario.
		ERR_UNEXPECTED_ASSIGNMENT:
			# Termina el metodo y devuelve translate(&"errors.unexpected_assignment") a quien lo llamo.
			return translate(&"errors.unexpected_assignment")
		# Asocia la clave ERR_UNKNOWN_USING con  dentro del diccionario.
		ERR_UNKNOWN_USING:
			# Termina el metodo y devuelve translate(&"errors.unknown_using") a quien lo llamo.
			return translate(&"errors.unknown_using")
		# Asocia la clave ERR_EXPECTED_WHEN_OR_ELSE con  dentro del diccionario.
		ERR_EXPECTED_WHEN_OR_ELSE:
			# Termina el metodo y devuelve translate(&"errors.expected_when_or_else") a quien lo llamo.
			return translate(&"errors.expected_when_or_else")
		# Asocia la clave ERR_ONLY_ONE_ELSE_ALLOWED con  dentro del diccionario.
		ERR_ONLY_ONE_ELSE_ALLOWED:
			# Termina el metodo y devuelve translate(&"errors.only_one_else_allowed") a quien lo llamo.
			return translate(&"errors.only_one_else_allowed")
		# Asocia la clave ERR_WHEN_MUST_BELONG_TO_MATCH con  dentro del diccionario.
		ERR_WHEN_MUST_BELONG_TO_MATCH:
			# Termina el metodo y devuelve translate(&"errors.when_must_belong_to_match") a quien lo llamo.
			return translate(&"errors.when_must_belong_to_match")
		# Asocia la clave ERR_CONCURRENT_LINE_WITHOUT_ORIGIN con  dentro del diccionario.
		ERR_CONCURRENT_LINE_WITHOUT_ORIGIN:
			# Termina el metodo y devuelve translate(&"errors.concurrent_line_without_origin") a quien lo llamo.
			return translate(&"errors.concurrent_line_without_origin")
		# Asocia la clave ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES con  dentro del diccionario.
		ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES:
			# Termina el metodo y devuelve translate(&"errors.goto_not_allowed_on_concurrect_lines") a quien lo llamo.
			return translate(&"errors.goto_not_allowed_on_concurrect_lines")
		# Asocia la clave ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE con  dentro del diccionario.
		ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE:
			# Termina el metodo y devuelve translate(&"errors.unexpected_syntax_on_nested_dialogue_line") a quien lo llamo.
			return translate(&"errors.unexpected_syntax_on_nested_dialogue_line")
		# Asocia la clave ERR_NESTED_DIALOGUE_INVALID_JUMP con  dentro del diccionario.
		ERR_NESTED_DIALOGUE_INVALID_JUMP:
			# Termina el metodo y devuelve translate(&"errors.err_nested_dialogue_invalid_jump") a quien lo llamo.
			return translate(&"errors.err_nested_dialogue_invalid_jump")

	# Termina el metodo y devuelve translate(&"errors.unknown") a quien lo llamo.
	return translate(&"errors.unknown")


# Ejecuta esta instruccion: static func translate(string: String) -> String:.
static func translate(string: String) -> String:
	# Crea base_path e inicializa su valor con new().get_script().resource_path.get_base_dir().
	var base_path = new().get_script().resource_path.get_base_dir()

	# Crea language e inicializa su valor con TranslationServer.get_tool_locale().
	var language: String = TranslationServer.get_tool_locale()
	# Crea translations_path e inicializa su valor con "%s/l10n/%s.po" % [base_path, language].
	var translations_path: String = "%s/l10n/%s.po" % [base_path, language]
	# Crea fallback_translations_path e inicializa su valor con "%s/l10n/%s.po" % [base_path, TranslationServer.get_tool_locale().substr(0, 2)].
	var fallback_translations_path: String = "%s/l10n/%s.po" % [base_path, TranslationServer.get_tool_locale().substr(0, 2)]
	# Crea en_translations_path e inicializa su valor con "%s/l10n/en.po" % base_path.
	var en_translations_path: String = "%s/l10n/en.po" % base_path
	# Crea translations e inicializa su valor con load(translations_path if FileAccess.file_exists(translations_path) else (fallback_translations_path if FileAccess.file_exists(fallback_translations_path) else en_translations_path)).
	var translations: Translation = load(translations_path if FileAccess.file_exists(translations_path) else (fallback_translations_path if FileAccess.file_exists(fallback_translations_path) else en_translations_path))
	# Termina el metodo y devuelve translations.get_message(string) a quien lo llamo.
	return translations.get_message(string)
