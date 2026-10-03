# Ejecuta esta instruccion: @tool.
@tool
# Registra DMSyntaxHighlighter como nombre de clase global para usarlo en otros scripts.
class_name DMSyntaxHighlighter extends SyntaxHighlighter


# Crea regex e inicializa su valor con DMCompilerRegEx.new().
var regex: DMCompilerRegEx = DMCompilerRegEx.new()
# Crea compilation e inicializa su valor con DMCompilation.new().
var compilation: DMCompilation = DMCompilation.new()
# Crea expression_parser e inicializa su valor con DMExpressionParser.new().
var expression_parser = DMExpressionParser.new()

# Crea cache e inicializa su valor con {}.
var cache: Dictionary = {}


# Define el metodo _clear_highlighting_cache para agrupar esta accion del script.
func _clear_highlighting_cache() -> void:
	# Llama al metodo cache.clear para realizar esta accion en este punto.
	cache.clear()


# Define el metodo _get_line_syntax_highlighting para agrupar esta accion del script.
func _get_line_syntax_highlighting(line: int) -> Dictionary:
	# Guarda en expression_parser.include_comments el resultado de true.
	expression_parser.include_comments = true

	# Crea colors e inicializa su valor con {}.
	var colors: Dictionary = {}
	# Crea text_edit e inicializa su valor con get_text_edit().
	var text_edit: TextEdit = get_text_edit()
	# Crea text e inicializa su valor con text_edit.get_line(line).
	var text: String = text_edit.get_line(line)

	# Prevent an error from popping up while developing
	if not is_instance_valid(text_edit) or text_edit.theme_overrides.is_empty():
		# Termina el metodo y devuelve colors a quien lo llamo.
		return colors

	# Disable this, as well as the line at the bottom of this function to remove the cache.
	if text in cache:
		# Termina el metodo y devuelve cache[text] a quien lo llamo.
		return cache[text]

	# Crea theme e inicializa su valor con text_edit.theme_overrides.
	var theme: Dictionary = text_edit.theme_overrides

	# Crea index e inicializa su valor con 0.
	var index: int = 0

	# Compara DMCompiler.get_line_type(text) con los casos siguientes y ejecuta el que coincida.
	match DMCompiler.get_line_type(text):
		# Ejecuta esta instruccion: DMConstants.TYPE_USING:.
		DMConstants.TYPE_USING:
			# Ejecuta esta instruccion: colors[index] = { color = theme.conditions_color }.
			colors[index] = { color = theme.conditions_color }
			# Ejecuta esta instruccion: colors[index + "using ".length()] = { color = theme.text_color }.
			colors[index + "using ".length()] = { color = theme.text_color }

		# Ejecuta esta instruccion: DMConstants.TYPE_IMPORT:.
		DMConstants.TYPE_IMPORT:
			# Ejecuta esta instruccion: colors[index] = { color = theme.conditions_color }.
			colors[index] = { color = theme.conditions_color }
			# Crea import e inicializa su valor con regex.IMPORT_REGEX.search(text).
			var import: RegExMatch = regex.IMPORT_REGEX.search(text)
			# Comprueba import; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if import:
				# Ejecuta esta instruccion: colors[index + import.get_start("path") - 1] = { color = theme.strings_color }.
				colors[index + import.get_start("path") - 1] = { color = theme.strings_color }
				# Ejecuta esta instruccion: colors[index + import.get_end("path") + 1] = { color = theme.conditions_color }.
				colors[index + import.get_end("path") + 1] = { color = theme.conditions_color }
				# Ejecuta esta instruccion: colors[index + import.get_start("prefix")] = { color = theme.text_color }.
				colors[index + import.get_start("prefix")] = { color = theme.text_color }

		# Ejecuta esta instruccion: DMConstants.TYPE_COMMENT:.
		DMConstants.TYPE_COMMENT:
			# Ejecuta esta instruccion: colors[index] = { color = theme.comments_color }.
			colors[index] = { color = theme.comments_color }

		# Ejecuta esta instruccion: DMConstants.TYPE_TITLE:.
		DMConstants.TYPE_TITLE:
			# Ejecuta esta instruccion: colors[index] = { color = theme.titles_color }.
			colors[index] = { color = theme.titles_color }

		# Ejecuta esta instruccion: DMConstants.TYPE_CONDITION, DMConstants.TYPE_WHILE, DMConstants.TYPE_MATCH, DMConstants.TYPE_WHEN:.
		DMConstants.TYPE_CONDITION, DMConstants.TYPE_WHILE, DMConstants.TYPE_MATCH, DMConstants.TYPE_WHEN:
			# Ejecuta esta instruccion: colors[0] = { color = theme.conditions_color }.
			colors[0] = { color = theme.conditions_color }
			# Guarda en index el resultado de text.find(" ").
			index = text.find(" ")
			# Comprueba index > -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if index > -1:
				# Crea expression e inicializa su valor con expression_parser.tokenise(text.substr(index), DMConstants.TYPE_CONDITION, 0).
				var expression: Array = expression_parser.tokenise(text.substr(index), DMConstants.TYPE_CONDITION, 0)
				# Comprueba expression.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if expression.size() == 0:
					# Ejecuta esta instruccion: colors[index] = { color = theme.critical_color }.
					colors[index] = { color = theme.critical_color }
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Llama al metodo _highlight_expression para realizar esta accion en este punto.
					_highlight_expression(expression, colors, index)

		# Ejecuta esta instruccion: DMConstants.TYPE_MUTATION:.
		DMConstants.TYPE_MUTATION:
			# Ejecuta esta instruccion: colors[0] = { color = theme.mutations_color }.
			colors[0] = { color = theme.mutations_color }
			# Guarda en index el resultado de text.find(" ").
			index = text.find(" ")
			# Crea expression e inicializa su valor con expression_parser.tokenise(text.substr(index), DMConstants.TYPE_MUTATION, 0).
			var expression: Array = expression_parser.tokenise(text.substr(index), DMConstants.TYPE_MUTATION, 0)
			# Comprueba expression.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if expression.size() == 0:
				# Ejecuta esta instruccion: colors[index] = { color = theme.critical_color }.
				colors[index] = { color = theme.critical_color }
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Llama al metodo _highlight_expression para realizar esta accion en este punto.
				_highlight_expression(expression, colors, index)

		# Ejecuta esta instruccion: DMConstants.TYPE_GOTO:.
		DMConstants.TYPE_GOTO:
			# Comprueba text.strip_edges().begins_with("%"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if text.strip_edges().begins_with("%"):
				# Ejecuta esta instruccion: colors[index] = { color = theme.symbols_color }.
				colors[index] = { color = theme.symbols_color }
				# Guarda en index el resultado de text.find(" ").
				index = text.find(" ")
			# Llama al metodo _highlight_goto para realizar esta accion en este punto.
			_highlight_goto(text, colors, index)

		# Ejecuta esta instruccion: DMConstants.TYPE_RANDOM:.
		DMConstants.TYPE_RANDOM:
			# Ejecuta esta instruccion: colors[index] = { color = theme.symbols_color }.
			colors[index] = { color = theme.symbols_color }

		# Ejecuta esta instruccion: DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE:.
		DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE:
			# Comprueba text.strip_edges().begins_with("%"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if text.strip_edges().begins_with("%"):
				# Ejecuta esta instruccion: colors[index] = { color = theme.symbols_color }.
				colors[index] = { color = theme.symbols_color }
				# Guarda en index el resultado de text.find(" ", text.find("%")).
				index = text.find(" ", text.find("%"))
			# Ejecuta esta instruccion: colors[index] = { color = theme.text_color.lerp(theme.symbols_color, 0.5) }.
			colors[index] = { color = theme.text_color.lerp(theme.symbols_color, 0.5) }

			# Crea dialogue_text e inicializa su valor con text.substr(index, text.find("=>")).
			var dialogue_text: String = text.substr(index, text.find("=>"))

			# Highlight character name (but ignore ":" within line ID reference)
			var split_index: int = dialogue_text.replace("\\:", "??").find(":")
			# Comprueba text.substr(split_index - 3, 3) != "[ID"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if text.substr(split_index - 3, 3) != "[ID":
				# Ejecuta esta instruccion: colors[index + split_index + 1] = { color = theme.text_color }.
				colors[index + split_index + 1] = { color = theme.text_color }
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# If there's no character name then just highlight the text as dialogue.
				colors[index] = { color = theme.text_color }

			# Interpolation
			var replacements: Array[RegExMatch] = regex.REPLACEMENTS_REGEX.search_all(dialogue_text)
			# Ejecuta esta instruccion: for replacement: RegExMatch in replacements:.
			for replacement: RegExMatch in replacements:
				# Crea expression_text e inicializa su valor con replacement.get_string().substr(0, replacement.get_string().length() - 2).substr(2).
				var expression_text: String = replacement.get_string().substr(0, replacement.get_string().length() - 2).substr(2)
				# Crea expression e inicializa su valor con expression_parser.tokenise(expression_text, DMConstants.TYPE_MUTATION, replacement.get_start()).
				var expression: Array = expression_parser.tokenise(expression_text, DMConstants.TYPE_MUTATION, replacement.get_start())
				# Crea expression_index e inicializa su valor con index + replacement.get_start().
				var expression_index: int = index + replacement.get_start()
				# Ejecuta esta instruccion: colors[expression_index] = { color = theme.symbols_color }.
				colors[expression_index] = { color = theme.symbols_color }
				# Comprueba expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR:
					# Ejecuta esta instruccion: colors[expression_index] = { color = theme.critical_color }.
					colors[expression_index] = { color = theme.critical_color }
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Llama al metodo _highlight_expression para realizar esta accion en este punto.
					_highlight_expression(expression, colors, index + 2)
				# Ejecuta esta instruccion: colors[expression_index + expression_text.length() + 2] = { color = theme.symbols_color }.
				colors[expression_index + expression_text.length() + 2] = { color = theme.symbols_color }
				# Ejecuta esta instruccion: colors[expression_index + expression_text.length() + 4] = { color = theme.text_color }.
				colors[expression_index + expression_text.length() + 4] = { color = theme.text_color }
			# Tags (and inline mutations)
			var resolved_line_data: DMResolvedLineData = DMResolvedLineData.new("")
			# Crea bbcodes e inicializa su valor con resolved_line_data.find_bbcode_positions_in_string(dialogue_text, true, true).
			var bbcodes: Array[Dictionary] = resolved_line_data.find_bbcode_positions_in_string(dialogue_text, true, true)
			# Ejecuta esta instruccion: for bbcode: Dictionary in bbcodes:.
			for bbcode: Dictionary in bbcodes:
				# Crea tag e inicializa su valor con bbcode.code.
				var tag: String = bbcode.code
				# Crea code e inicializa su valor con bbcode.raw_args.
				var code: String = bbcode.raw_args
				# Comprueba code.begins_with("["); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if code.begins_with("["):
					# Ejecuta esta instruccion: colors[index + bbcode.start] = { color = theme.symbols_color }.
					colors[index + bbcode.start] = { color = theme.symbols_color }
					# Ejecuta esta instruccion: colors[index + bbcode.start + 2] = { color = theme.text_color }.
					colors[index + bbcode.start + 2] = { color = theme.text_color }
					# Crea pipe_cursor e inicializa su valor con code.find("|").
					var pipe_cursor: int = code.find("|")
					# Repite este bloque mientras pipe_cursor > -1 sea verdadero.
					while pipe_cursor > -1:
						# Ejecuta esta instruccion: colors[index + bbcode.start + pipe_cursor + 1] = { color = theme.symbols_color }.
						colors[index + bbcode.start + pipe_cursor + 1] = { color = theme.symbols_color }
						# Ejecuta esta instruccion: colors[index + bbcode.start + pipe_cursor + 2] = { color = theme.text_color }.
						colors[index + bbcode.start + pipe_cursor + 2] = { color = theme.text_color }
						# Guarda en pipe_cursor el resultado de code.find("|", pipe_cursor + 1).
						pipe_cursor = code.find("|", pipe_cursor + 1)
					# Ejecuta esta instruccion: colors[index + bbcode.end - 1] = { color = theme.symbols_color }.
					colors[index + bbcode.end - 1] = { color = theme.symbols_color }
					# Ejecuta esta instruccion: colors[index + bbcode.end + 1] = { color = theme.text_color }.
					colors[index + bbcode.end + 1] = { color = theme.text_color }
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Ejecuta esta instruccion: colors[index + bbcode.start] = { color = theme.symbols_color }.
					colors[index + bbcode.start] = { color = theme.symbols_color }
					# Comprueba tag.begins_with("do") or tag.begins_with("set") or tag.begins_with("if"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if tag.begins_with("do") or tag.begins_with("set") or tag.begins_with("if"):
						# Comprueba tag.begins_with("if"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
						if tag.begins_with("if"):
							# Ejecuta esta instruccion: colors[index + bbcode.start + 1] = { color = theme.conditions_color }.
							colors[index + bbcode.start + 1] = { color = theme.conditions_color }
						# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
						else:
							# Ejecuta esta instruccion: colors[index + bbcode.start + 1] = { color = theme.mutations_color }.
							colors[index + bbcode.start + 1] = { color = theme.mutations_color }
						# Crea expression e inicializa su valor con expression_parser.tokenise(code, DMConstants.TYPE_MUTATION, bbcode.start + bbcode.code.length()).
						var expression: Array = expression_parser.tokenise(code, DMConstants.TYPE_MUTATION, bbcode.start + bbcode.code.length())
						# Comprueba expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
						if expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR:
							# Ejecuta esta instruccion: colors[index + bbcode.start + tag.length() + 1] = { color = theme.critical_color }.
							colors[index + bbcode.start + tag.length() + 1] = { color = theme.critical_color }
						# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
						else:
							# Llama al metodo _highlight_expression para realizar esta accion en este punto.
							_highlight_expression(expression, colors, index + 2)
					# else and closing if have no expression
					elif tag.begins_with("else") or tag.begins_with("/if"):
						# Ejecuta esta instruccion: colors[index + bbcode.start + 1] = { color = theme.conditions_color }.
						colors[index + bbcode.start + 1] = { color = theme.conditions_color }
					# Ejecuta esta instruccion: colors[index + bbcode.end] = { color = theme.symbols_color }.
					colors[index + bbcode.end] = { color = theme.symbols_color }
					# Ejecuta esta instruccion: colors[index + bbcode.end + 1] = { color = theme.text_color }.
					colors[index + bbcode.end + 1] = { color = theme.text_color }
			# Jumps
			if "=> " in text or "=>< " in text:
				# Llama al metodo _highlight_goto para realizar esta accion en este punto.
				_highlight_goto(text, colors, index)

	# Order the dictionary keys to prevent CodeEdit from having issues
	var ordered_colors: Dictionary = {}
	# Crea ordered_keys e inicializa su valor con colors.keys().
	var ordered_keys: Array = colors.keys()
	# Llama al metodo ordered_keys.sort para realizar esta accion en este punto.
	ordered_keys.sort()
	# Ejecuta esta instruccion: for key_index: int in ordered_keys:.
	for key_index: int in ordered_keys:
		# Ejecuta esta instruccion: ordered_colors[key_index] = colors[key_index].
		ordered_colors[key_index] = colors[key_index]

	# Ejecuta esta instruccion: cache[text] = ordered_colors.
	cache[text] = ordered_colors
	# Termina el metodo y devuelve ordered_colors a quien lo llamo.
	return ordered_colors


# Define el metodo _highlight_expression para agrupar esta accion del script.
func _highlight_expression(tokens: Array, colors: Dictionary, index: int) -> int:
	# Crea theme e inicializa su valor con get_text_edit().theme_overrides.
	var theme: Dictionary = get_text_edit().theme_overrides
	# Crea last_index e inicializa su valor con index.
	var last_index: int = index
	# Ejecuta esta instruccion: for token: Dictionary in tokens:.
	for token: Dictionary in tokens:
		# Guarda en last_index el resultado de token.i.
		last_index = token.i
		# Compara token.type con los casos siguientes y ejecuta el que coincida.
		match token.type:
			# Ejecuta esta instruccion: DMConstants.TOKEN_COMMENT:.
			DMConstants.TOKEN_COMMENT:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.comments_color }.
				colors[index + token.i] = { color = theme.comments_color }

			# Ejecuta esta instruccion: DMConstants.TOKEN_CONDITION, DMConstants.TOKEN_AND_OR:.
			DMConstants.TOKEN_CONDITION, DMConstants.TOKEN_AND_OR:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.conditions_color }.
				colors[index + token.i] = { color = theme.conditions_color }

			# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE:.
			DMConstants.TOKEN_VARIABLE:
				# Comprueba token.value in ["true", "false"]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if token.value in ["true", "false"]:
					# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.conditions_color }.
					colors[index + token.i] = { color = theme.conditions_color }
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.members_color }.
					colors[index + token.i] = { color = theme.members_color }

			DMConstants.TOKEN_OPERATOR, DMConstants.TOKEN_COLON, \
			DMConstants.TOKEN_COMMA, DMConstants.TOKEN_DOT, DMConstants.TOKEN_NULL_COALESCE, \
			DMConstants.TOKEN_NUMBER, DMConstants.TOKEN_ASSIGNMENT:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.symbols_color }.
				colors[index + token.i] = { color = theme.symbols_color }

			# Ejecuta esta instruccion: DMConstants.TOKEN_STRING:.
			DMConstants.TOKEN_STRING:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.strings_color }.
				colors[index + token.i] = { color = theme.strings_color }

			# Ejecuta esta instruccion: DMConstants.TOKEN_FUNCTION:.
			DMConstants.TOKEN_FUNCTION:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.mutations_color }.
				colors[index + token.i] = { color = theme.mutations_color }
				# Ejecuta esta instruccion: colors[index + token.i + token.function.length()] = { color = theme.symbols_color }.
				colors[index + token.i + token.function.length()] = { color = theme.symbols_color }
				# Ejecuta esta instruccion: for parameter: Array in token.value:.
				for parameter: Array in token.value:
					# Guarda en last_index el resultado de _highlight_expression(parameter, colors, index).
					last_index = _highlight_expression(parameter, colors, index)
			# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_CLOSE:.
			DMConstants.TOKEN_PARENS_CLOSE:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.symbols_color }.
				colors[index + token.i] = { color = theme.symbols_color }

			# Ejecuta esta instruccion: DMConstants.TOKEN_DICTIONARY_REFERENCE:.
			DMConstants.TOKEN_DICTIONARY_REFERENCE:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.members_color }.
				colors[index + token.i] = { color = theme.members_color }
				# Ejecuta esta instruccion: colors[index + token.i + token.variable.length()] = { color = theme.symbols_color }.
				colors[index + token.i + token.variable.length()] = { color = theme.symbols_color }
				# Guarda en last_index el resultado de _highlight_expression(token.value, colors, index).
				last_index = _highlight_expression(token.value, colors, index)
			# Ejecuta esta instruccion: DMConstants.TOKEN_ARRAY:.
			DMConstants.TOKEN_ARRAY:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.symbols_color }.
				colors[index + token.i] = { color = theme.symbols_color }
				# Ejecuta esta instruccion: for item: Array in token.value:.
				for item: Array in token.value:
					# Guarda en last_index el resultado de _highlight_expression(item, colors, index).
					last_index = _highlight_expression(item, colors, index)
			# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_CLOSE:.
			DMConstants.TOKEN_BRACKET_CLOSE:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.symbols_color }.
				colors[index + token.i] = { color = theme.symbols_color }

			# Ejecuta esta instruccion: DMConstants.TOKEN_DICTIONARY:.
			DMConstants.TOKEN_DICTIONARY:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.symbols_color }.
				colors[index + token.i] = { color = theme.symbols_color }
				# Guarda en last_index el resultado de _highlight_expression(token.value.keys() + token.value.values(), colors, index).
				last_index = _highlight_expression(token.value.keys() + token.value.values(), colors, index)
			# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_CLOSE:.
			DMConstants.TOKEN_BRACE_CLOSE:
				# Ejecuta esta instruccion: colors[index + token.i] = { color = theme.symbols_color }.
				colors[index + token.i] = { color = theme.symbols_color }
				# Suma a last_index el valor 1 respecto de su valor anterior.
				last_index += 1

			# Ejecuta esta instruccion: DMConstants.TOKEN_GROUP:.
			DMConstants.TOKEN_GROUP:
				# Guarda en last_index el resultado de _highlight_expression(token.value, colors, index).
				last_index = _highlight_expression(token.value, colors, index)

	# Termina el metodo y devuelve last_index a quien lo llamo.
	return last_index


# Define el metodo _highlight_goto para agrupar esta accion del script.
func _highlight_goto(text: String, colors: Dictionary, index: int) -> int:
	# Crea theme e inicializa su valor con get_text_edit().theme_overrides.
	var theme: Dictionary = get_text_edit().theme_overrides
	# Crea goto_data e inicializa su valor con DMResolvedGotoData.new(text, {}).
	var goto_data: DMResolvedGotoData = DMResolvedGotoData.new(text, {})
	# Ejecuta esta instruccion: colors[goto_data.index] = { color = theme.jumps_color }.
	colors[goto_data.index] = { color = theme.jumps_color }
	# Comprueba "{{" in text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if "{{" in text:
		# Guarda en index el resultado de text.find("{{", goto_data.index).
		index = text.find("{{", goto_data.index)
		# Crea last_index e inicializa su valor con 0.
		var last_index: int = 0
		# Comprueba goto_data.error; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if goto_data.error:
			# Ejecuta esta instruccion: colors[index + 2] = { color = theme.critical_color }.
			colors[index + 2] = { color = theme.critical_color }
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en last_index el resultado de _highlight_expression(goto_data.expression, colors, index).
			last_index = _highlight_expression(goto_data.expression, colors, index)
		# Guarda en index el resultado de text.find("}}", index + last_index).
		index = text.find("}}", index + last_index)
		# Ejecuta esta instruccion: colors[index] = { color = theme.jumps_color }.
		colors[index] = { color = theme.jumps_color }

	# Termina el metodo y devuelve index a quien lo llamo.
	return index
