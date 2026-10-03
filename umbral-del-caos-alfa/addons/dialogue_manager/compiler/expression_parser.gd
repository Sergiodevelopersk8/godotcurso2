## A class for parsing a condition/mutation expression for use with the [DMCompiler].
class_name DMExpressionParser extends RefCounted


# Crea include_comments e inicializa su valor con false.
var include_comments: bool = false


# Reference to the common [RegEx] that the parser needs.
var regex: DMCompilerRegEx = DMCompilerRegEx.new()


## Break a string down into an expression.
func tokenise(text: String, line_type: String, index: int) -> Array:
	# Crea tokens e inicializa su valor con [].
	var tokens: Array[Dictionary] = []
	# Crea limit e inicializa su valor con 0.
	var limit: int = 0
	# Repite este bloque mientras text.strip_edges() != "" and limit < 1000 sea verdadero.
	while text.strip_edges() != "" and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea found e inicializa su valor con _find_match(text).
		var found = _find_match(text)
		# Comprueba found.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if found.size() > 0:
			# Llama al metodo tokens.append para realizar esta accion en este punto.
			tokens.append({
				# Guarda en index el resultado de index,.
				index = index,
				# Guarda en type el resultado de found.type,.
				type = found.type,
				# Guarda en value el resultado de found.value.
				value = found.value
			# Ejecuta esta instruccion: }).
			})
			# Suma a index el valor found.value.length() respecto de su valor anterior.
			index += found.value.length()
			# Guarda en text el resultado de found.remaining_text.
			text = found.remaining_text
		# Comprueba text.begins_with(" ") si las condiciones anteriores resultaron falsas.
		elif text.begins_with(" "):
			# Suma a index el valor 1 respecto de su valor anterior.
			index += 1
			# Guarda en text el resultado de text.substr(1).
			text = text.substr(1)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina el metodo y devuelve _build_token_tree_error([], DMConstants.ERR_INVALID_EXPRESSION, index) a quien lo llamo.
			return _build_token_tree_error([], DMConstants.ERR_INVALID_EXPRESSION, index)

	# Termina el metodo y devuelve _build_token_tree(tokens, line_type, "")[0] a quien lo llamo.
	return _build_token_tree(tokens, line_type, "")[0]


## Extract any expressions from some text
func extract_replacements(text: String, index: int) -> Array[Dictionary]:
	# Crea founds e inicializa su valor con regex.REPLACEMENTS_REGEX.search_all(text).
	var founds: Array[RegExMatch] = regex.REPLACEMENTS_REGEX.search_all(text)

	# Comprueba founds == null or founds.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if founds == null or founds.size() == 0:
		# Termina el metodo y devuelve [] a quien lo llamo.
		return []

	# Crea replacements e inicializa su valor con [].
	var replacements: Array[Dictionary] = []
	# Recorre founds y asigna cada elemento a found en cada vuelta.
	for found in founds:
		# Crea replacement e inicializa su valor con {}.
		var replacement: Dictionary = {}
		# Crea value_in_text e inicializa su valor con found.strings[0].substr(0, found.strings[0].length() - 2).substr(2).
		var value_in_text: String = found.strings[0].substr(0, found.strings[0].length() - 2).substr(2)

		# If there are closing curlie hard-up against the end of a {{...}} block then check for further
		# curlies just outside of the block.
		var text_suffix: String = text.substr(found.get_end(0))
		# Crea expression_suffix e inicializa su valor con "".
		var expression_suffix: String = ""
		# Repite este bloque mientras text_suffix.begins_with("}") sea verdadero.
		while text_suffix.begins_with("}"):
			# Suma a expression_suffix el valor "}" respecto de su valor anterior.
			expression_suffix += "}"
			# Guarda en text_suffix el resultado de text_suffix.substr(1).
			text_suffix = text_suffix.substr(1)
		# Suma a value_in_text el valor expression_suffix respecto de su valor anterior.
		value_in_text += expression_suffix

		# Crea expression e inicializa su valor con tokenise(value_in_text, DMConstants.TYPE_DIALOGUE, index + found.get_start(1)).
		var expression: Array = tokenise(value_in_text, DMConstants.TYPE_DIALOGUE, index + found.get_start(1))
		# Comprueba expression.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if expression.size() == 0:
			# Guarda en replacement el resultado de {.
			replacement = {
				# Guarda en index el resultado de index + found.get_start(1),.
				index = index + found.get_start(1),
				# Guarda en error el resultado de DMConstants.ERR_INCOMPLETE_EXPRESSION.
				error = DMConstants.ERR_INCOMPLETE_EXPRESSION
			}
		# Comprueba expression[0].type == DMConstants.TYPE_ERROR si las condiciones anteriores resultaron falsas.
		elif expression[0].type == DMConstants.TYPE_ERROR:
			# Guarda en replacement el resultado de {.
			replacement = {
				# Guarda en index el resultado de expression[0].i,.
				index = expression[0].i,
				# Guarda en error el resultado de expression[0].value.
				error = expression[0].value
			}
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en replacement el resultado de {.
			replacement = {
				# Guarda en value_in_text el resultado de "{{%s}}" % value_in_text,.
				value_in_text = "{{%s}}" % value_in_text,
				# Guarda en expression el resultado de expression.
				expression = expression
			}
		# Llama al metodo replacements.append para realizar esta accion en este punto.
		replacements.append(replacement)

	# Termina el metodo y devuelve replacements a quien lo llamo.
	return replacements


#region Helpers


# Create a token that represents an error.
func _build_token_tree_error(tree: Array, error: int, index: int) -> Array:
	# Llama al metodo tree.insert para realizar esta accion en este punto.
	tree.insert(0, {
		# Guarda en type el resultado de DMConstants.TOKEN_ERROR,.
		type = DMConstants.TOKEN_ERROR,
		# Guarda en value el resultado de error,.
		value = error,
		# Guarda en i el resultado de index.
		i = index
	# Ejecuta esta instruccion: }).
	})
	# Termina el metodo y devuelve tree a quien lo llamo.
	return tree


# Convert a list of tokens into an abstract syntax tree.
func _build_token_tree(tokens: Array[Dictionary], line_type: String, expected_close_token: String) -> Array:
	# Crea tree e inicializa su valor con [].
	var tree: Array[Dictionary] = []
	# Crea limit e inicializa su valor con 0.
	var limit = 0
	# Repite este bloque mientras tokens.size() > 0 and limit < 1000 sea verdadero.
	while tokens.size() > 0 and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens.pop_front().
		var token = tokens.pop_front()

		# Crea error e inicializa su valor con _check_next_token(token, tokens, line_type, expected_close_token).
		var error = _check_next_token(token, tokens, line_type, expected_close_token)
		# Comprueba error != OK; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if error != OK:
			# Crea error_token e inicializa su valor con tokens[1] if tokens.size() > 1 else token.
			var error_token: Dictionary = tokens[1] if tokens.size() > 1 else token
			# Termina el metodo y devuelve [_build_token_tree_error(tree, error, error_token.index), tokens] a quien lo llamo.
			return [_build_token_tree_error(tree, error, error_token.index), tokens]

		# Compara token.type con los casos siguientes y ejecuta el que coincida.
		match token.type:
			# Ejecuta esta instruccion: DMConstants.TOKEN_COMMENT:.
			DMConstants.TOKEN_COMMENT:
				# Comprueba include_comments; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if include_comments:
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append({
						# Guarda en type el resultado de DMConstants.TOKEN_COMMENT,.
						type = DMConstants.TOKEN_COMMENT,
						# Guarda en value el resultado de token.value,.
						value = token.value,
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: }).
					})

			# Ejecuta esta instruccion: DMConstants.TOKEN_FUNCTION:.
			DMConstants.TOKEN_FUNCTION:
				# Crea sub_tree e inicializa su valor con _build_token_tree(tokens, line_type, DMConstants.TOKEN_PARENS_CLOSE).
				var sub_tree = _build_token_tree(tokens, line_type, DMConstants.TOKEN_PARENS_CLOSE)

				# Comprueba sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens]

				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de DMConstants.TOKEN_FUNCTION,.
					type = DMConstants.TOKEN_FUNCTION,
					# Consume the trailing "("
					function = token.value.substr(0, token.value.length() - 1),
					# Guarda en value el resultado de _tokens_to_list(sub_tree[0]),.
					value = _tokens_to_list(sub_tree[0]),
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})
				# Guarda en tokens el resultado de sub_tree[1].
				tokens = sub_tree[1]

			# Ejecuta esta instruccion: DMConstants.TOKEN_DICTIONARY_REFERENCE:.
			DMConstants.TOKEN_DICTIONARY_REFERENCE:
				# Crea sub_tree e inicializa su valor con _build_token_tree(tokens, line_type, DMConstants.TOKEN_BRACKET_CLOSE).
				var sub_tree = _build_token_tree(tokens, line_type, DMConstants.TOKEN_BRACKET_CLOSE)

				# Comprueba sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens]

				# Crea args e inicializa su valor con _tokens_to_list(sub_tree[0]).
				var args = _tokens_to_list(sub_tree[0])
				# Comprueba args.size() != 1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if args.size() != 1:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, DMConstants.ERR_INVALID_INDEX, token.index), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, DMConstants.ERR_INVALID_INDEX, token.index), tokens]

				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de DMConstants.TOKEN_DICTIONARY_REFERENCE,.
					type = DMConstants.TOKEN_DICTIONARY_REFERENCE,
					# Consume the trailing "["
					variable = token.value.substr(0, token.value.length() - 1),
					# Guarda en value el resultado de args[0],.
					value = args[0],
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})
				# Guarda en tokens el resultado de sub_tree[1].
				tokens = sub_tree[1]

			# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_OPEN:.
			DMConstants.TOKEN_BRACE_OPEN:
				# Crea sub_tree e inicializa su valor con _build_token_tree(tokens, line_type, DMConstants.TOKEN_BRACE_CLOSE).
				var sub_tree = _build_token_tree(tokens, line_type, DMConstants.TOKEN_BRACE_CLOSE)

				# Comprueba sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens]

				# Crea t e inicializa su valor con sub_tree[0].
				var t = sub_tree[0]
				# Recorre range(0, t.size() - 2) y asigna cada elemento a i en cada vuelta.
				for i in range(0, t.size() - 2):
					# Convert Lua style dictionaries to string keys
					if t[i].type == DMConstants.TOKEN_VARIABLE and t[i+1].type == DMConstants.TOKEN_ASSIGNMENT:
						# Ejecuta esta instruccion: t[i].type = DMConstants.TOKEN_STRING.
						t[i].type = DMConstants.TOKEN_STRING
						# Ejecuta esta instruccion: t[i+1].type = DMConstants.TOKEN_COLON.
						t[i+1].type = DMConstants.TOKEN_COLON
						# Ejecuta esta instruccion: t[i+1].erase("value").
						t[i+1].erase("value")

				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de DMConstants.TOKEN_DICTIONARY,.
					type = DMConstants.TOKEN_DICTIONARY,
					# Guarda en value el resultado de _tokens_to_dictionary(sub_tree[0]),.
					value = _tokens_to_dictionary(sub_tree[0]),
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})

				# Guarda en tokens el resultado de sub_tree[1].
				tokens = sub_tree[1]

			# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_OPEN:.
			DMConstants.TOKEN_BRACKET_OPEN:
				# Crea sub_tree e inicializa su valor con _build_token_tree(tokens, line_type, DMConstants.TOKEN_BRACKET_CLOSE).
				var sub_tree = _build_token_tree(tokens, line_type, DMConstants.TOKEN_BRACKET_CLOSE)

				# Comprueba sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens]

				# Crea type e inicializa su valor con DMConstants.TOKEN_ARRAY.
				var type = DMConstants.TOKEN_ARRAY
				# Crea value e inicializa su valor con _tokens_to_list(sub_tree[0]).
				var value = _tokens_to_list(sub_tree[0])

				# See if this is referencing a nested dictionary value
				if tree.size() > 0:
					# Crea previous_token e inicializa su valor con tree[tree.size() - 1].
					var previous_token = tree[tree.size() - 1]
					# Comprueba previous_token.type in [DMConstants.TOKEN_DICTIONARY_REFERENCE, DMConstants.TOKEN_DICTIONARY_NESTED_REFERENCE]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if previous_token.type in [DMConstants.TOKEN_DICTIONARY_REFERENCE, DMConstants.TOKEN_DICTIONARY_NESTED_REFERENCE]:
						# Guarda en type el resultado de DMConstants.TOKEN_DICTIONARY_NESTED_REFERENCE.
						type = DMConstants.TOKEN_DICTIONARY_NESTED_REFERENCE
						# Guarda en value el resultado de value[0].
						value = value[0]

				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de type,.
					type = type,
					# Guarda en value el resultado de value,.
					value = value,
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})
				# Guarda en tokens el resultado de sub_tree[1].
				tokens = sub_tree[1]

			# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_OPEN:.
			DMConstants.TOKEN_PARENS_OPEN:
				# Crea sub_tree e inicializa su valor con _build_token_tree(tokens, line_type, DMConstants.TOKEN_PARENS_CLOSE).
				var sub_tree = _build_token_tree(tokens, line_type, DMConstants.TOKEN_PARENS_CLOSE)

				# Comprueba sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if sub_tree[0].size() > 0 and sub_tree[0][0].type == DMConstants.TOKEN_ERROR:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, sub_tree[0][0].value, sub_tree[0][0].i), tokens]

				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de DMConstants.TOKEN_GROUP,.
					type = DMConstants.TOKEN_GROUP,
					# Guarda en value el resultado de sub_tree[0],.
					value = sub_tree[0],
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})
				# Guarda en tokens el resultado de sub_tree[1].
				tokens = sub_tree[1]

			DMConstants.TOKEN_PARENS_CLOSE, \
			DMConstants.TOKEN_BRACE_CLOSE, \
			DMConstants.TOKEN_BRACKET_CLOSE:
				# Comprueba token.type != expected_close_token; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if token.type != expected_close_token:
					# Termina el metodo y devuelve [_build_token_tree_error(tree, DMConstants.ERR_UNEXPECTED_CLOSING_BRACKET, token.index), tokens] a quien lo llamo.
					return [_build_token_tree_error(tree, DMConstants.ERR_UNEXPECTED_CLOSING_BRACKET, token.index), tokens]

				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de token.type,.
					type = token.type,
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})

				# Termina el metodo y devuelve [tree, tokens] a quien lo llamo.
				return [tree, tokens]

			# Ejecuta esta instruccion: DMConstants.TOKEN_NOT:.
			DMConstants.TOKEN_NOT:
				# Double nots negate each other
				if tokens.size() > 0 and tokens.front().type == DMConstants.TOKEN_NOT:
					# Llama al metodo tokens.pop_front para realizar esta accion en este punto.
					tokens.pop_front()
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append({
						# Guarda en type el resultado de token.type,.
						type = token.type,
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: }).
					})

			DMConstants.TOKEN_COMMA, \
			DMConstants.TOKEN_COLON, \
			DMConstants.TOKEN_DOT, \
			DMConstants.TOKEN_NULL_COALESCE:
				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de token.type,.
					type = token.type,
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})

			DMConstants.TOKEN_COMPARISON, \
			DMConstants.TOKEN_ASSIGNMENT, \
			DMConstants.TOKEN_OPERATOR, \
			DMConstants.TOKEN_AND_OR, \
			DMConstants.TOKEN_VARIABLE:
				# Crea value e inicializa su valor con token.value.strip_edges().
				var value = token.value.strip_edges()
				# Comprueba value == "&&"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if value == "&&":
					# Guarda en value el resultado de "and".
					value = "and"
				# Comprueba value == "||" si las condiciones anteriores resultaron falsas.
				elif value == "||":
					# Guarda en value el resultado de "or".
					value = "or"
				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de token.type,.
					type = token.type,
					# Guarda en value el resultado de value,.
					value = value,
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})

			# Ejecuta esta instruccion: DMConstants.TOKEN_STRING:.
			DMConstants.TOKEN_STRING:
				# Comprueba token.value.begins_with("&"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if token.value.begins_with("&"):
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append({
						# Guarda en type el resultado de token.type,.
						type = token.type,
						# Guarda en value el resultado de StringName(token.value.substr(2, token.value.length() - 3)),.
						value = StringName(token.value.substr(2, token.value.length() - 3)),
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: }).
					})
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append({
						# Guarda en type el resultado de token.type,.
						type = token.type,
						# Guarda en value el resultado de token.value.substr(1, token.value.length() - 2),.
						value = token.value.substr(1, token.value.length() - 2),
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: }).
					})

			# Ejecuta esta instruccion: DMConstants.TOKEN_CONDITION:.
			DMConstants.TOKEN_CONDITION:
				# Termina el metodo y devuelve [_build_token_tree_error(tree, DMConstants.ERR_UNEXPECTED_CONDITION, token.index), token] a quien lo llamo.
				return [_build_token_tree_error(tree, DMConstants.ERR_UNEXPECTED_CONDITION, token.index), token]

			# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL:.
			DMConstants.TOKEN_BOOL:
				# Llama al metodo tree.append para realizar esta accion en este punto.
				tree.append({
					# Guarda en type el resultado de token.type,.
					type = token.type,
					# Guarda en value el resultado de token.value.to_lower() == "true",.
					value = token.value.to_lower() == "true",
					# Guarda en i el resultado de token.index.
					i = token.index
				# Ejecuta esta instruccion: }).
				})

			# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER:.
			DMConstants.TOKEN_NUMBER:
				# Crea value e inicializa su valor con token.value.to_float() if "." in token.value else token.value.to_int().
				var value = token.value.to_float() if "." in token.value else token.value.to_int()
				# If previous token is a number and this one is a negative number then
				# inject a minus operator token in between them.
				if tree.size() > 0 and token.value.begins_with("-") and tree[tree.size() - 1].type == DMConstants.TOKEN_NUMBER:
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append(({
						# Guarda en type el resultado de DMConstants.TOKEN_OPERATOR,.
						type = DMConstants.TOKEN_OPERATOR,
						# Guarda en value el resultado de "-",.
						value = "-",
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: })).
					}))
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append({
						# Guarda en type el resultado de token.type,.
						type = token.type,
						# Guarda en value el resultado de -1 * value,.
						value = -1 * value,
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: }).
					})
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Llama al metodo tree.append para realizar esta accion en este punto.
					tree.append({
						# Guarda en type el resultado de token.type,.
						type = token.type,
						# Guarda en value el resultado de value,.
						value = value,
						# Guarda en i el resultado de token.index.
						i = token.index
					# Ejecuta esta instruccion: }).
					})

	# Comprueba expected_close_token != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if expected_close_token != "":
		# Crea index e inicializa su valor con tokens[0].i if tokens.size() > 0 else 0.
		var index: int = tokens[0].i if tokens.size() > 0 else 0
		# Termina el metodo y devuelve [_build_token_tree_error(tree, DMConstants.ERR_MISSING_CLOSING_BRACKET, index), tokens] a quien lo llamo.
		return [_build_token_tree_error(tree, DMConstants.ERR_MISSING_CLOSING_BRACKET, index), tokens]

	# Termina el metodo y devuelve [tree, tokens] a quien lo llamo.
	return [tree, tokens]


# Check the next token to see if it is valid to follow this one.
func _check_next_token(token: Dictionary, next_tokens: Array[Dictionary], line_type: String, expected_close_token: String) -> Error:
	# Crea next_token e inicializa su valor con { type = null }.
	var next_token: Dictionary = { type = null }
	# Comprueba next_tokens.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if next_tokens.size() > 0:
		# Guarda en next_token el resultado de next_tokens.front().
		next_token = next_tokens.front()

	# Guard for assigning in a condition. If the assignment token isn't inside a Lua dictionary
	# then it's an unexpected assignment in a condition line.
	if token.type == DMConstants.TOKEN_ASSIGNMENT and line_type == DMConstants.TYPE_CONDITION and not next_tokens.any(func(t): return t.type == expected_close_token):
		# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_ASSIGNMENT a quien lo llamo.
		return DMConstants.ERR_UNEXPECTED_ASSIGNMENT

	# Special case for a negative number after this one
	if token.type == DMConstants.TOKEN_NUMBER and next_token.type == DMConstants.TOKEN_NUMBER and next_token.value.begins_with("-"):
		# Termina el metodo y devuelve OK a quien lo llamo.
		return OK

	# Crea expected_token_types e inicializa su valor con [].
	var expected_token_types = []
	# Crea unexpected_token_types e inicializa su valor con [].
	var unexpected_token_types = []
	# Compara token.type con los casos siguientes y ejecuta el que coincida.
	match token.type:
		DMConstants.TOKEN_FUNCTION, \
		DMConstants.TOKEN_PARENS_OPEN:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: null,.
				null,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA,.
				DMConstants.TOKEN_COMMA,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COLON,.
				DMConstants.TOKEN_COLON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMPARISON,.
				DMConstants.TOKEN_COMPARISON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT,.
				DMConstants.TOKEN_ASSIGNMENT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_OPERATOR,.
				DMConstants.TOKEN_OPERATOR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_AND_OR,.
				DMConstants.TOKEN_AND_OR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_DOT.
				DMConstants.TOKEN_DOT
			]

		# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_CLOSE:.
		DMConstants.TOKEN_BRACKET_CLOSE:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: DMConstants.TOKEN_NOT,.
				DMConstants.TOKEN_NOT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL,.
				DMConstants.TOKEN_BOOL,
				# Ejecuta esta instruccion: DMConstants.TOKEN_STRING,.
				DMConstants.TOKEN_STRING,
				# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER,.
				DMConstants.TOKEN_NUMBER,
				# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE.
				DMConstants.TOKEN_VARIABLE
			]

		# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_OPEN:.
		DMConstants.TOKEN_BRACE_OPEN:
			# Guarda en expected_token_types el resultado de [.
			expected_token_types = [
				# Ejecuta esta instruccion: DMConstants.TOKEN_STRING,.
				DMConstants.TOKEN_STRING,
				# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE,.
				DMConstants.TOKEN_VARIABLE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER,.
				DMConstants.TOKEN_NUMBER,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_CLOSE.
				DMConstants.TOKEN_BRACE_CLOSE
			]

		DMConstants.TOKEN_PARENS_CLOSE, \
		DMConstants.TOKEN_BRACE_CLOSE:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: DMConstants.TOKEN_NOT,.
				DMConstants.TOKEN_NOT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT,.
				DMConstants.TOKEN_ASSIGNMENT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL,.
				DMConstants.TOKEN_BOOL,
				# Ejecuta esta instruccion: DMConstants.TOKEN_STRING,.
				DMConstants.TOKEN_STRING,
				# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER,.
				DMConstants.TOKEN_NUMBER,
				# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE.
				DMConstants.TOKEN_VARIABLE
			]

		DMConstants.TOKEN_COMPARISON, \
		DMConstants.TOKEN_OPERATOR, \
		DMConstants.TOKEN_DOT, \
		DMConstants.TOKEN_NULL_COALESCE, \
		DMConstants.TOKEN_NOT, \
		DMConstants.TOKEN_AND_OR, \
		DMConstants.TOKEN_DICTIONARY_REFERENCE:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: null,.
				null,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA,.
				DMConstants.TOKEN_COMMA,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COLON,.
				DMConstants.TOKEN_COLON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMPARISON,.
				DMConstants.TOKEN_COMPARISON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT,.
				DMConstants.TOKEN_ASSIGNMENT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_OPERATOR,.
				DMConstants.TOKEN_OPERATOR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_AND_OR,.
				DMConstants.TOKEN_AND_OR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_CLOSE,.
				DMConstants.TOKEN_PARENS_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_CLOSE,.
				DMConstants.TOKEN_BRACE_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_CLOSE,.
				DMConstants.TOKEN_BRACKET_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_DOT.
				DMConstants.TOKEN_DOT
			]

		# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA:.
		DMConstants.TOKEN_COMMA:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: null,.
				null,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA,.
				DMConstants.TOKEN_COMMA,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COLON,.
				DMConstants.TOKEN_COLON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT,.
				DMConstants.TOKEN_ASSIGNMENT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_OPERATOR,.
				DMConstants.TOKEN_OPERATOR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_AND_OR,.
				DMConstants.TOKEN_AND_OR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_CLOSE,.
				DMConstants.TOKEN_PARENS_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_CLOSE,.
				DMConstants.TOKEN_BRACE_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_CLOSE,.
				DMConstants.TOKEN_BRACKET_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_DOT.
				DMConstants.TOKEN_DOT
			]

		# Ejecuta esta instruccion: DMConstants.TOKEN_COLON:.
		DMConstants.TOKEN_COLON:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA,.
				DMConstants.TOKEN_COMMA,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COLON,.
				DMConstants.TOKEN_COLON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_COMPARISON,.
				DMConstants.TOKEN_COMPARISON,
				# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT,.
				DMConstants.TOKEN_ASSIGNMENT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_OPERATOR,.
				DMConstants.TOKEN_OPERATOR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_AND_OR,.
				DMConstants.TOKEN_AND_OR,
				# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_CLOSE,.
				DMConstants.TOKEN_PARENS_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_CLOSE,.
				DMConstants.TOKEN_BRACE_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_CLOSE,.
				DMConstants.TOKEN_BRACKET_CLOSE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_DOT.
				DMConstants.TOKEN_DOT
			]

		DMConstants.TOKEN_BOOL, \
		DMConstants.TOKEN_STRING, \
		DMConstants.TOKEN_NUMBER:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: DMConstants.TOKEN_NOT,.
				DMConstants.TOKEN_NOT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_ASSIGNMENT,.
				DMConstants.TOKEN_ASSIGNMENT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL,.
				DMConstants.TOKEN_BOOL,
				# Ejecuta esta instruccion: DMConstants.TOKEN_STRING,.
				DMConstants.TOKEN_STRING,
				# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER,.
				DMConstants.TOKEN_NUMBER,
				# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE,.
				DMConstants.TOKEN_VARIABLE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_FUNCTION,.
				DMConstants.TOKEN_FUNCTION,
				# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_OPEN,.
				DMConstants.TOKEN_PARENS_OPEN,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_OPEN,.
				DMConstants.TOKEN_BRACE_OPEN,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_OPEN.
				DMConstants.TOKEN_BRACKET_OPEN
			]

		# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE:.
		DMConstants.TOKEN_VARIABLE:
			# Guarda en unexpected_token_types el resultado de [.
			unexpected_token_types = [
				# Ejecuta esta instruccion: DMConstants.TOKEN_NOT,.
				DMConstants.TOKEN_NOT,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL,.
				DMConstants.TOKEN_BOOL,
				# Ejecuta esta instruccion: DMConstants.TOKEN_STRING,.
				DMConstants.TOKEN_STRING,
				# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER,.
				DMConstants.TOKEN_NUMBER,
				# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE,.
				DMConstants.TOKEN_VARIABLE,
				# Ejecuta esta instruccion: DMConstants.TOKEN_FUNCTION,.
				DMConstants.TOKEN_FUNCTION,
				# Ejecuta esta instruccion: DMConstants.TOKEN_PARENS_OPEN,.
				DMConstants.TOKEN_PARENS_OPEN,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACE_OPEN,.
				DMConstants.TOKEN_BRACE_OPEN,
				# Ejecuta esta instruccion: DMConstants.TOKEN_BRACKET_OPEN.
				DMConstants.TOKEN_BRACKET_OPEN
			]

	if (expected_token_types.size() > 0 and not next_token.type in expected_token_types) \
	or (unexpected_token_types.size() > 0 and next_token.type in unexpected_token_types):
		# Compara next_token.type con los casos siguientes y ejecuta el que coincida.
		match next_token.type:
			# Asocia la clave null con  dentro del diccionario.
			null:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_END_OF_EXPRESSION a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_END_OF_EXPRESSION

			# Ejecuta esta instruccion: DMConstants.TOKEN_FUNCTION:.
			DMConstants.TOKEN_FUNCTION:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_FUNCTION a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_FUNCTION

			DMConstants.TOKEN_PARENS_OPEN, \
			DMConstants.TOKEN_PARENS_CLOSE:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_BRACKET a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_BRACKET

			DMConstants.TOKEN_COMPARISON, \
			DMConstants.TOKEN_ASSIGNMENT, \
			DMConstants.TOKEN_OPERATOR, \
			DMConstants.TOKEN_NOT, \
			DMConstants.TOKEN_AND_OR:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_OPERATOR a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_OPERATOR

			# Ejecuta esta instruccion: DMConstants.TOKEN_COMMA:.
			DMConstants.TOKEN_COMMA:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_COMMA a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_COMMA
			# Ejecuta esta instruccion: DMConstants.TOKEN_COLON:.
			DMConstants.TOKEN_COLON:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_COLON a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_COLON
			# Ejecuta esta instruccion: DMConstants.TOKEN_DOT:.
			DMConstants.TOKEN_DOT:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_DOT a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_DOT

			# Ejecuta esta instruccion: DMConstants.TOKEN_BOOL:.
			DMConstants.TOKEN_BOOL:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_BOOLEAN a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_BOOLEAN
			# Ejecuta esta instruccion: DMConstants.TOKEN_STRING:.
			DMConstants.TOKEN_STRING:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_STRING a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_STRING
			# Ejecuta esta instruccion: DMConstants.TOKEN_NUMBER:.
			DMConstants.TOKEN_NUMBER:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_NUMBER a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_NUMBER
			# Ejecuta esta instruccion: DMConstants.TOKEN_VARIABLE:.
			DMConstants.TOKEN_VARIABLE:
				# Termina el metodo y devuelve DMConstants.ERR_UNEXPECTED_VARIABLE a quien lo llamo.
				return DMConstants.ERR_UNEXPECTED_VARIABLE

		# Termina el metodo y devuelve DMConstants.ERR_INVALID_EXPRESSION a quien lo llamo.
		return DMConstants.ERR_INVALID_EXPRESSION

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


# Convert a series of comma separated tokens to an [Array].
func _tokens_to_list(tokens: Array[Dictionary]) -> Array[Array]:
	# Crea list e inicializa su valor con [].
	var list: Array[Array] = []
	# Crea current_item e inicializa su valor con [].
	var current_item: Array[Dictionary] = []
	# Recorre tokens y asigna cada elemento a token en cada vuelta.
	for token in tokens:
		# Comprueba token.type == DMConstants.TOKEN_COMMA; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_COMMA:
			# Llama al metodo list.append para realizar esta accion en este punto.
			list.append(current_item)
			# Guarda en current_item el resultado de [].
			current_item = []
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo current_item.append para realizar esta accion en este punto.
			current_item.append(token)

	# Comprueba current_item.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_item.size() > 0:
		# Llama al metodo list.append para realizar esta accion en este punto.
		list.append(current_item)

	# Termina el metodo y devuelve list a quien lo llamo.
	return list


# Convert a series of key/value tokens into a [Dictionary]
func _tokens_to_dictionary(tokens: Array[Dictionary]) -> Dictionary:
	# Crea dictionary e inicializa su valor con {}.
	var dictionary = {}
	# Recorre range(0, tokens.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, tokens.size()):
		# Comprueba tokens[i].type == DMConstants.TOKEN_COLON; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if tokens[i].type == DMConstants.TOKEN_COLON:
			# Comprueba tokens.size() == i + 2; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if tokens.size() == i + 2:
				# Ejecuta esta instruccion: dictionary[tokens[i - 1]] = tokens[i + 1].
				dictionary[tokens[i - 1]] = tokens[i + 1]
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Ejecuta esta instruccion: dictionary[tokens[i - 1]] = { type = DMConstants.TOKEN_GROUP, value = tokens.slice(i + 1), i = tokens[0].i }.
				dictionary[tokens[i - 1]] = { type = DMConstants.TOKEN_GROUP, value = tokens.slice(i + 1), i = tokens[0].i }

	# Termina el metodo y devuelve dictionary a quien lo llamo.
	return dictionary


# Work out what the next token is from a string.
func _find_match(input: String) -> Dictionary:
	# Recorre regex.TOKEN_DEFINITIONS.keys() y asigna cada elemento a key en cada vuelta.
	for key in regex.TOKEN_DEFINITIONS.keys():
		# Crea regex e inicializa su valor con regex.TOKEN_DEFINITIONS.get(key).
		var regex = regex.TOKEN_DEFINITIONS.get(key)
		# Crea found e inicializa su valor con regex.search(input).
		var found = regex.search(input)
		# Comprueba found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if found:
			# Termina el metodo y devuelve { a quien lo llamo.
			return {
				# Guarda en type el resultado de key,.
				type = key,
				# Guarda en remaining_text el resultado de input.substr(found.strings[0].length()),.
				remaining_text = input.substr(found.strings[0].length()),
				# Guarda en value el resultado de found.strings[0].
				value = found.strings[0]
			}

	# Termina el metodo y devuelve {} a quien lo llamo.
	return {}


#endregion
