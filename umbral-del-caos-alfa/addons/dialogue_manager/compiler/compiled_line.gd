## A compiled line of dialogue.
class_name DMCompiledLine extends RefCounted


## The ID of the line
var id: String
## The translation key (or static line ID).
var translation_key: String = ""
## The type of line.
var type: String = ""
## The character name.
var character: String = ""
## Any interpolation expressions for the character name.
var character_replacements: Array[Dictionary] = []
## The text of the line.
var text: String = ""
## Any interpolation expressions for the text.
var text_replacements: Array[Dictionary] = []
## Any response siblings associated with this line.
var responses: PackedStringArray = []
## Any randomise or case siblings for this line.
var siblings: Array[Dictionary] = []
## Any lines said simultaneously.
var concurrent_lines: PackedStringArray = []
## Any tags on this line.
var tags: PackedStringArray = []
## The condition or mutation expression for this line.
var expression: Dictionary = {}
## The express as the raw text that was given.
var expression_text: String = ""
## The next sequential line to go to after this line.
var next_id: String = ""
## The next line to go to after this line if it is unknown and compile time.
var next_id_expression: Array[Dictionary] = []
## Whether this jump line should return after the jump target sequence has ended.
var is_snippet: bool = false
## The ID of the next sibling line.
var next_sibling_id: String = ""
## The ID after this line if it belongs to a block (eg. conditions).
var next_id_after: String = ""
## Any doc comments attached to this line.
var notes: String = ""


#region Hooks


# Define el metodo _init para agrupar esta accion del script.
func _init(initial_id: String, initial_type: String) -> void:
	# Guarda en id el resultado de initial_id.
	id = initial_id
	# Guarda en type el resultado de initial_type.
	type = initial_type


# Define el metodo _to_string para agrupar esta accion del script.
func _to_string() -> String:
	# Crea s e inicializa su valor con [.
	var s: Array = [
		# Ejecuta esta instruccion: "[%s]" % [type],.
		"[%s]" % [type],
		# Ejecuta esta instruccion: "%s:" % [character] if character != "" else null,.
		"%s:" % [character] if character != "" else null,
		# Ejecuta esta instruccion: text if text != "" else null,.
		text if text != "" else null,
		# Ejecuta esta instruccion: expression if expression.size() > 0 else null,.
		expression if expression.size() > 0 else null,
		# Ejecuta esta instruccion: "[%s]" % [",".join(tags)] if tags.size() > 0 else null,.
		"[%s]" % [",".join(tags)] if tags.size() > 0 else null,
		# Llama al metodo str para realizar esta accion en este punto.
		str(siblings) if siblings.size() > 0 else null,
		# Llama al metodo str para realizar esta accion en este punto.
		str(responses) if responses.size() > 0 else null,
		# Ejecuta esta instruccion: "=> END" if "end" in next_id else "=> %s" % [next_id],.
		"=> END" if "end" in next_id else "=> %s" % [next_id],
		# Ejecuta esta instruccion: "(~> %s)" % [next_sibling_id] if next_sibling_id != "" else null,.
		"(~> %s)" % [next_sibling_id] if next_sibling_id != "" else null,
		# Ejecuta esta instruccion: "(==> %s)" % [next_id_after] if next_id_after != "" else null,.
		"(==> %s)" % [next_id_after] if next_id_after != "" else null,
	# Ejecuta esta instruccion: ].filter(func(item): return item != null).
	].filter(func(item): return item != null)

	# Termina el metodo y devuelve " ".join(s) a quien lo llamo.
	return " ".join(s)


#endregion

#region Helpers


## Express this line as a [Dictionary] that can be stored in a resource.
func to_data() -> Dictionary:
	# Crea d e inicializa su valor con {.
	var d: Dictionary = {
		# Guarda en id el resultado de id,.
		id = id,
		# Guarda en type el resultado de type,.
		type = type,
		# Guarda en next_id el resultado de next_id.
		next_id = next_id
	}

	# Comprueba next_id_expression.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if next_id_expression.size() > 0:
		# Guarda en d.next_id_expression el resultado de next_id_expression.
		d.next_id_expression = next_id_expression

	# Compara type con los casos siguientes y ejecuta el que coincida.
	match type:
		# Ejecuta esta instruccion: DMConstants.TYPE_CONDITION:.
		DMConstants.TYPE_CONDITION:
			# Guarda en d.condition el resultado de expression.
			d.condition = expression
			# Comprueba not next_sibling_id.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not next_sibling_id.is_empty():
				# Guarda en d.next_sibling_id el resultado de next_sibling_id.
				d.next_sibling_id = next_sibling_id
			# Guarda en d.next_id_after el resultado de next_id_after.
			d.next_id_after = next_id_after

		# Ejecuta esta instruccion: DMConstants.TYPE_WHILE:.
		DMConstants.TYPE_WHILE:
			# Guarda en d.condition el resultado de expression.
			d.condition = expression
			# Guarda en d.next_id_after el resultado de next_id_after.
			d.next_id_after = next_id_after

		# Ejecuta esta instruccion: DMConstants.TYPE_MATCH:.
		DMConstants.TYPE_MATCH:
			# Guarda en d.condition el resultado de expression.
			d.condition = expression
			# Guarda en d.next_id_after el resultado de next_id_after.
			d.next_id_after = next_id_after
			# Guarda en d.cases el resultado de siblings.
			d.cases = siblings

		# Ejecuta esta instruccion: DMConstants.TYPE_MUTATION:.
		DMConstants.TYPE_MUTATION:
			# Guarda en d.mutation el resultado de expression.
			d.mutation = expression

		# Ejecuta esta instruccion: DMConstants.TYPE_GOTO:.
		DMConstants.TYPE_GOTO:
			# Guarda en d.is_snippet el resultado de is_snippet.
			d.is_snippet = is_snippet
			# Guarda en d.next_id_after el resultado de next_id_after.
			d.next_id_after = next_id_after
			# Comprueba not siblings.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not siblings.is_empty():
				# Guarda en d.siblings el resultado de siblings.
				d.siblings = siblings

		# Ejecuta esta instruccion: DMConstants.TYPE_RANDOM:.
		DMConstants.TYPE_RANDOM:
			# Guarda en d.siblings el resultado de siblings.
			d.siblings = siblings

		# Ejecuta esta instruccion: DMConstants.TYPE_RESPONSE:.
		DMConstants.TYPE_RESPONSE:
			# Guarda en d.text el resultado de text.
			d.text = text

			# Comprueba not responses.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not responses.is_empty():
				# Guarda en d.responses el resultado de responses.
				d.responses = responses

			# Comprueba translation_key != text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if translation_key != text:
				# Guarda en d.translation_key el resultado de translation_key.
				d.translation_key = translation_key
			# Comprueba not expression.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not expression.is_empty():
				# Guarda en d.condition el resultado de expression.
				d.condition = expression
			# Comprueba not character.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not character.is_empty():
				# Guarda en d.character el resultado de character.
				d.character = character
			# Comprueba not character_replacements.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not character_replacements.is_empty():
				# Guarda en d.character_replacements el resultado de character_replacements.
				d.character_replacements = character_replacements
			# Comprueba not text_replacements.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not text_replacements.is_empty():
				# Guarda en d.text_replacements el resultado de text_replacements.
				d.text_replacements = text_replacements
			# Comprueba not tags.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not tags.is_empty():
				# Guarda en d.tags el resultado de tags.
				d.tags = tags
			# Comprueba not notes.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not notes.is_empty():
				# Guarda en d.notes el resultado de notes.
				d.notes = notes
			# Comprueba not expression_text.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not expression_text.is_empty():
				# Guarda en d.condition_as_text el resultado de expression_text.
				d.condition_as_text = expression_text

		# Ejecuta esta instruccion: DMConstants.TYPE_DIALOGUE:.
		DMConstants.TYPE_DIALOGUE:
			# Guarda en d.text el resultado de text.
			d.text = text

			# Comprueba translation_key != text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if translation_key != text:
				# Guarda en d.translation_key el resultado de translation_key.
				d.translation_key = translation_key

			# Comprueba not character.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not character.is_empty():
				# Guarda en d.character el resultado de character.
				d.character = character
			# Comprueba not character_replacements.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not character_replacements.is_empty():
				# Guarda en d.character_replacements el resultado de character_replacements.
				d.character_replacements = character_replacements
			# Comprueba not text_replacements.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not text_replacements.is_empty():
				# Guarda en d.text_replacements el resultado de text_replacements.
				d.text_replacements = text_replacements
			# Comprueba not tags.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not tags.is_empty():
				# Guarda en d.tags el resultado de tags.
				d.tags = tags
			# Comprueba not notes.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not notes.is_empty():
				# Guarda en d.notes el resultado de notes.
				d.notes = notes
			# Comprueba not siblings.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not siblings.is_empty():
				# Guarda en d.siblings el resultado de siblings.
				d.siblings = siblings
			# Comprueba not concurrent_lines.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not concurrent_lines.is_empty():
				# Guarda en d.concurrent_lines el resultado de concurrent_lines.
				d.concurrent_lines = concurrent_lines

	# Termina el metodo y devuelve d a quien lo llamo.
	return d


#endregion
