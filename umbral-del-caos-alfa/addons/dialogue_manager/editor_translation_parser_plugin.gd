# Registra DMTranslationParserPlugin como nombre de clase global para usarlo en otros scripts.
class_name DMTranslationParserPlugin extends EditorTranslationParserPlugin


## Cached result of parsing a dialogue file.
var data: DMCompilerResult
## List of characters that were added.
var translated_character_names: PackedStringArray = []
# Crea translated_lines e inicializa su valor con [].
var translated_lines: Array[Dictionary] = []


# Define el metodo _parse_file para agrupar esta accion del script.
func _parse_file(path: String) -> Array[PackedStringArray]:
	# Crea msgs e inicializa su valor con [].
	var msgs: Array[PackedStringArray] = []
	# Crea file e inicializa su valor con FileAccess.open(path, FileAccess.READ).
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	# Crea text e inicializa su valor con file.get_as_text().
	var text: String = file.get_as_text()

	# Guarda en data el resultado de DMCompiler.compile_string(text, path).
	data = DMCompiler.compile_string(text, path)

	# Crea known_keys e inicializa su valor con PackedStringArray([]).
	var known_keys: PackedStringArray = PackedStringArray([])

	# Add all character names if settings ask for it
	if DMSettings.get_setting(DMSettings.INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST, true):
		# Guarda en translated_character_names el resultado de [] as Array[DialogueLine].
		translated_character_names = [] as Array[DialogueLine]
		# Ejecuta esta instruccion: for character_name: String in data.character_names:.
		for character_name: String in data.character_names:
			# Ejecuta esta instruccion: if character_name in known_keys: continue.
			if character_name in known_keys: continue

			# Llama al metodo known_keys.append para realizar esta accion en este punto.
			known_keys.append(character_name)

			# Llama al metodo translated_character_names.append para realizar esta accion en este punto.
			translated_character_names.append(character_name)
			# Llama al metodo msgs.append para realizar esta accion en este punto.
			msgs.append(PackedStringArray([character_name.replace('"', '\"'), "dialogue", "", DMConstants.translate("translation_plugin.character_name")]))

	# Add all dialogue lines and responses
	var dialogue: Dictionary = data.lines
	# Ejecuta esta instruccion: for key: String in dialogue.keys():.
	for key: String in dialogue.keys():
		# Crea line e inicializa su valor con dialogue.get(key).
		var line: Dictionary = dialogue.get(key)

		# Ejecuta esta instruccion: if not line.type in [DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE]: continue.
		if not line.type in [DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE]: continue

		# Crea translation_key e inicializa su valor con line.get(&"translation_key", line.text).
		var translation_key: String = line.get(&"translation_key", line.text)

		# Ejecuta esta instruccion: if translation_key in known_keys: continue.
		if translation_key in known_keys: continue

		# Llama al metodo known_keys.append para realizar esta accion en este punto.
		known_keys.append(translation_key)
		# Llama al metodo translated_lines.append para realizar esta accion en este punto.
		translated_lines.append(line)
		# Comprueba translation_key == line.text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if translation_key == line.text:
			# Llama al metodo msgs.append para realizar esta accion en este punto.
			msgs.append(PackedStringArray([line.text.replace('"', '\"'), "", "", line.get("notes", "")]))
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo msgs.append para realizar esta accion en este punto.
			msgs.append(PackedStringArray([line.text.replace('"', '\"'), line.translation_key.replace('"', '\"'), "", line.get("notes", "")]))

	# Termina el metodo y devuelve msgs a quien lo llamo.
	return msgs


# Define el metodo _get_recognized_extensions para agrupar esta accion del script.
func _get_recognized_extensions() -> PackedStringArray:
	# Termina el metodo y devuelve ["dialogue"] a quien lo llamo.
	return ["dialogue"]
