## Data associated with a dialogue jump/goto line.
class_name DMResolvedGotoData extends RefCounted


## The title that was specified
var title: String = ""
## The target line's ID
var next_id: String = ""
## An expression to determine the target line at runtime.
var expression: Array[Dictionary] = []
## The given line text with the jump syntax removed.
var text_without_goto: String = ""
## Whether this is a jump-and-return style jump.
var is_snippet: bool = false
## A parse error if there was one.
var error: int
## The index in the string where
var index: int = 0

# An instance of the compiler [RegEx] list.
var regex: DMCompilerRegEx = DMCompilerRegEx.new()


# Define el metodo _init para agrupar esta accion del script.
func _init(text: String, titles: Dictionary) -> void:
	# Ejecuta esta instruccion: if not "=> " in text and not "=>< " in text: return.
	if not "=> " in text and not "=>< " in text: return

	# Comprueba "=> " in text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if "=> " in text:
		# Guarda en text_without_goto el resultado de text.substr(0, text.find("=> ")).strip_edges().
		text_without_goto = text.substr(0, text.find("=> ")).strip_edges()
	# Comprueba "=>< " in text si las condiciones anteriores resultaron falsas.
	elif "=>< " in text:
		# Guarda en is_snippet el resultado de true.
		is_snippet = true
		# Guarda en text_without_goto el resultado de text.substr(0, text.find("=>< ")).strip_edges().
		text_without_goto = text.substr(0, text.find("=>< ")).strip_edges()

	# Crea found e inicializa su valor con regex.GOTO_REGEX.search(text).
	var found: RegExMatch = regex.GOTO_REGEX.search(text)
	# Comprueba found == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if found == null:
		# Termina el metodo sin devolver un valor.
		return

	# Guarda en title el resultado de found.strings[found.names.goto].strip_edges().
	title = found.strings[found.names.goto].strip_edges()
	# Guarda en index el resultado de found.get_start(0).
	index = found.get_start(0)

	# Comprueba title == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if title == "":
		# Guarda en error el resultado de DMConstants.ERR_UNKNOWN_TITLE.
		error = DMConstants.ERR_UNKNOWN_TITLE
		# Termina el metodo sin devolver un valor.
		return

	# "=> END!" means end the conversation, ignoring any "=><" chains.
	if title == "END!":
		# Guarda en next_id el resultado de DMConstants.ID_END_CONVERSATION.
		next_id = DMConstants.ID_END_CONVERSATION

	# "=> END" means end the current title (and go back to the previous one if there is one
	# in the stack)
	elif title == "END":
		# Guarda en next_id el resultado de DMConstants.ID_END.
		next_id = DMConstants.ID_END

	# Comprueba titles.has(title) si las condiciones anteriores resultaron falsas.
	elif titles.has(title):
		# Guarda en next_id el resultado de titles.get(title).
		next_id = titles.get(title)
	# Comprueba title.begins_with("{{") si las condiciones anteriores resultaron falsas.
	elif title.begins_with("{{"):
		# Crea expression_parser e inicializa su valor con DMExpressionParser.new().
		var expression_parser: DMExpressionParser = DMExpressionParser.new()
		# Crea title_expression e inicializa su valor con expression_parser.extract_replacements(title, 0).
		var title_expression: Array[Dictionary] = expression_parser.extract_replacements(title, 0)
		# Comprueba title_expression[0].has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if title_expression[0].has("error"):
			# Guarda en error el resultado de title_expression[0].error.
			error = title_expression[0].error
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en expression el resultado de title_expression[0].expression.
			expression = title_expression[0].expression
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en next_id el resultado de title.
		next_id = title
		# Guarda en error el resultado de DMConstants.ERR_UNKNOWN_TITLE.
		error = DMConstants.ERR_UNKNOWN_TITLE


# Define el metodo _to_string para agrupar esta accion del script.
func _to_string() -> String:
	# Termina el metodo y devuelve "%s =>%s %s (%s)" % [text_without_goto, "<" if is_snippet else "", title, next_id] a quien lo llamo.
	return "%s =>%s %s (%s)" % [text_without_goto, "<" if is_snippet else "", title, next_id]
