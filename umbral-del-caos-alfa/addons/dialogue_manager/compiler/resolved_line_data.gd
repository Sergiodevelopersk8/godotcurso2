## Any data associated with inline dialogue BBCodes.
class_name DMResolvedLineData extends RefCounted

## The line's text
var text: String = ""
## A map of pauses against where they are found in the text.
var pauses: Dictionary = {}
## A map of speed changes against where they are found in the text.
var speeds: Dictionary = {}
## A list of any mutations to run and where they are found in the text.
var mutations: Array[Array] = []
## A duration reference for the line. Represented as "auto" or a stringified number.
var time: String = ""


# Define el metodo _init para agrupar esta accion del script.
func _init(line: String) -> void:
	# Guarda en text el resultado de line.
	text = line
	# Guarda en pauses el resultado de {}.
	pauses = {}
	# Guarda en speeds el resultado de {}.
	speeds = {}
	# Guarda en mutations el resultado de [].
	mutations = []
	# Guarda en time el resultado de "".
	time = ""

	# Crea bbcodes e inicializa su valor con [].
	var bbcodes: Array = []

	# Remove any escaped brackets (ie. "\[")
	var escaped_open_brackets: PackedInt32Array = []
	# Crea escaped_close_brackets e inicializa su valor con [].
	var escaped_close_brackets: PackedInt32Array = []
	# Recorre range(0, text.length() - 1) y asigna cada elemento a i en cada vuelta.
	for i in range(0, text.length() - 1):
		# Comprueba text.substr(i, 2) == "\\["; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if text.substr(i, 2) == "\\[":
			# Guarda en text el resultado de text.substr(0, i) + "!" + text.substr(i + 2).
			text = text.substr(0, i) + "!" + text.substr(i + 2)
			# Llama al metodo escaped_open_brackets.append para realizar esta accion en este punto.
			escaped_open_brackets.append(i)
		# Comprueba text.substr(i, 2) == "\\]" si las condiciones anteriores resultaron falsas.
		elif text.substr(i, 2) == "\\]":
			# Guarda en text el resultado de text.substr(0, i) + "!" + text.substr(i + 2).
			text = text.substr(0, i) + "!" + text.substr(i + 2)
			# Llama al metodo escaped_close_brackets.append para realizar esta accion en este punto.
			escaped_close_brackets.append(i)

	# Extract all of the BB codes so that we know the actual text (we could do this easier with
	# a RichTextLabel but then we'd need to await idle_frame which is annoying)
	var bbcode_positions = find_bbcode_positions_in_string(text)
	# Crea accumulaive_length_offset e inicializa su valor con 0.
	var accumulaive_length_offset = 0
	# Recorre bbcode_positions y asigna cada elemento a position en cada vuelta.
	for position in bbcode_positions:
		# Ignore our own markers
		if position.code in ["wait", "speed", "/speed", "do", "do!", "set", "next", "if", "else", "/if"]:
			# Pasa directamente a la siguiente vuelta del bucle.
			continue

		# Llama al metodo bbcodes.append para realizar esta accion en este punto.
		bbcodes.append({
			# Guarda en bbcode el resultado de position.bbcode,.
			bbcode = position.bbcode,
			# Guarda en start el resultado de position.start,.
			start = position.start,
			# Guarda en offset_start el resultado de position.start - accumulaive_length_offset.
			offset_start = position.start - accumulaive_length_offset
		# Ejecuta esta instruccion: }).
		})
		# Suma a accumulaive_length_offset el valor position.bbcode.length() respecto de su valor anterior.
		accumulaive_length_offset += position.bbcode.length()

	# Recorre bbcodes y asigna cada elemento a bb en cada vuelta.
	for bb in bbcodes:
		# Guarda en text el resultado de text.substr(0, bb.offset_start) + text.substr(bb.offset_start + bb.bbcode.length()).
		text = text.substr(0, bb.offset_start) + text.substr(bb.offset_start + bb.bbcode.length())

	# Now find any dialogue markers
	var next_bbcode_position = find_bbcode_positions_in_string(text, false)
	# Crea limit e inicializa su valor con 0.
	var limit = 0
	# Repite este bloque mientras next_bbcode_position.size() > 0 and limit < 1000 sea verdadero.
	while next_bbcode_position.size() > 0 and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1

		# Crea bbcode e inicializa su valor con next_bbcode_position[0].
		var bbcode = next_bbcode_position[0]

		# Crea index e inicializa su valor con bbcode.start.
		var index = bbcode.start
		# Crea code e inicializa su valor con bbcode.code.
		var code = bbcode.code
		# Crea raw_args e inicializa su valor con bbcode.raw_args.
		var raw_args = bbcode.raw_args
		# Crea args e inicializa su valor con {}.
		var args = {}
		# Comprueba code in ["do", "do!", "set"]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if code in ["do", "do!", "set"]:
			# Crea compilation e inicializa su valor con DMCompilation.new().
			var compilation: DMCompilation = DMCompilation.new()
			# Ejecuta esta instruccion: args["value"] = compilation.extract_mutation("%s %s" % [code, raw_args]).
			args["value"] = compilation.extract_mutation("%s %s" % [code, raw_args])
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Could be something like:
			# 	"=1.0"
			# 	" rate=20 level=10"
			if raw_args and raw_args[0] == "=":
				# Guarda en raw_args el resultado de "value" + raw_args.
				raw_args = "value" + raw_args
			# Recorre raw_args.strip_edges().split(" ") y asigna cada elemento a pair en cada vuelta.
			for pair in raw_args.strip_edges().split(" "):
				# Comprueba "=" in pair; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if "=" in pair:
					# Crea bits e inicializa su valor con pair.split("=").
					var bits = pair.split("=")
					# Ejecuta esta instruccion: args[bits[0]] = bits[1].
					args[bits[0]] = bits[1]

		# Compara code con los casos siguientes y ejecuta el que coincida.
		match code:
			# Asocia la clave "wait" con  dentro del diccionario.
			"wait":
				# Comprueba pauses.has(index); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if pauses.has(index):
					# Ejecuta esta instruccion: pauses[index] += args.get("value").to_float().
					pauses[index] += args.get("value").to_float()
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Ejecuta esta instruccion: pauses[index] = args.get("value").to_float().
					pauses[index] = args.get("value").to_float()
			# Asocia la clave "speed" con  dentro del diccionario.
			"speed":
				# Ejecuta esta instruccion: speeds[index] = args.get("value").to_float().
				speeds[index] = args.get("value").to_float()
			# Asocia la clave "/speed" con  dentro del diccionario.
			"/speed":
				# Ejecuta esta instruccion: speeds[index] = 1.0.
				speeds[index] = 1.0
			# Ejecuta esta instruccion: "do", "do!", "set":.
			"do", "do!", "set":
				# Llama al metodo mutations.append para realizar esta accion en este punto.
				mutations.append([index, args.get("value")])
			# Asocia la clave "next" con  dentro del diccionario.
			"next":
				# Guarda en time el resultado de args.get("value") if args.has("value") else "0".
				time = args.get("value") if args.has("value") else "0"

		# Find any BB codes that are after this index and remove the length from their start
		var length = bbcode.bbcode.length()
		# Recorre bbcodes y asigna cada elemento a bb en cada vuelta.
		for bb in bbcodes:
			# Comprueba bb.offset_start > bbcode.start; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if bb.offset_start > bbcode.start:
				# Resta de bb.offset_start el valor length respecto de su valor anterior.
				bb.offset_start -= length
				# Resta de bb.start el valor length respecto de su valor anterior.
				bb.start -= length

		# Find any escaped brackets after this that need moving
		for i in range(0, escaped_open_brackets.size()):
			# Comprueba escaped_open_brackets[i] > bbcode.start; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if escaped_open_brackets[i] > bbcode.start:
				# Ejecuta esta instruccion: escaped_open_brackets[i] -= length.
				escaped_open_brackets[i] -= length
		# Recorre range(0, escaped_close_brackets.size()) y asigna cada elemento a i en cada vuelta.
		for i in range(0, escaped_close_brackets.size()):
			# Comprueba escaped_close_brackets[i] > bbcode.start; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if escaped_close_brackets[i] > bbcode.start:
				# Ejecuta esta instruccion: escaped_close_brackets[i] -= length.
				escaped_close_brackets[i] -= length

		# Guarda en text el resultado de text.substr(0, index) + text.substr(index + length).
		text = text.substr(0, index) + text.substr(index + length)
		# Guarda en next_bbcode_position el resultado de find_bbcode_positions_in_string(text, false).
		next_bbcode_position = find_bbcode_positions_in_string(text, false)

	# Put the BB Codes back in
	for bb in bbcodes:
		# Guarda en text el resultado de text.insert(bb.start, bb.bbcode).
		text = text.insert(bb.start, bb.bbcode)

	# Put the escaped brackets back in
	for index in escaped_open_brackets:
		# Guarda en text el resultado de text.left(index) + "[" + text.right(text.length() - index - 1).
		text = text.left(index) + "[" + text.right(text.length() - index - 1)
	# Recorre escaped_close_brackets y asigna cada elemento a index en cada vuelta.
	for index in escaped_close_brackets:
		# Guarda en text el resultado de text.left(index) + "]" + text.right(text.length() - index - 1).
		text = text.left(index) + "]" + text.right(text.length() - index - 1)


# Define el metodo find_bbcode_positions_in_string para agrupar esta accion del script.
func find_bbcode_positions_in_string(string: String, find_all: bool = true, include_conditions: bool = false) -> Array[Dictionary]:
	# Ejecuta esta instruccion: if not "[" in string: return [].
	if not "[" in string: return []

	# Crea positions e inicializa su valor con [].
	var positions: Array[Dictionary] = []

	# Crea open_brace_count e inicializa su valor con 0.
	var open_brace_count: int = 0
	# Crea start e inicializa su valor con 0.
	var start: int = 0
	# Crea bbcode e inicializa su valor con "".
	var bbcode: String = ""
	# Crea code e inicializa su valor con "".
	var code: String = ""
	# Crea is_finished_code e inicializa su valor con false.
	var is_finished_code: bool = false
	# Recorre range(0, string.length()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, string.length()):
		# Comprueba string[i] == "["; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if string[i] == "[":
			# Comprueba open_brace_count == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if open_brace_count == 0:
				# Guarda en start el resultado de i.
				start = i
				# Guarda en bbcode el resultado de "".
				bbcode = ""
				# Guarda en code el resultado de "".
				code = ""
				# Guarda en is_finished_code el resultado de false.
				is_finished_code = false
			# Suma a open_brace_count el valor 1 respecto de su valor anterior.
			open_brace_count += 1

		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Comprueba not is_finished_code and (string[i].to_upper() != string[i] or string[i] == "/" or string[i] == "!"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not is_finished_code and (string[i].to_upper() != string[i] or string[i] == "/" or string[i] == "!"):
				# Suma a code el valor string[i] respecto de su valor anterior.
				code += string[i]
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en is_finished_code el resultado de true.
				is_finished_code = true

		# Comprueba open_brace_count > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if open_brace_count > 0:
			# Suma a bbcode el valor string[i] respecto de su valor anterior.
			bbcode += string[i]

		# Comprueba string[i] == "]"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if string[i] == "]":
			# Resta de open_brace_count el valor 1 respecto de su valor anterior.
			open_brace_count -= 1
			# Comprueba open_brace_count == 0 and (include_conditions or not code in ["if", "else", "/if"]); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if open_brace_count == 0 and (include_conditions or not code in ["if", "else", "/if"]):
				# Llama al metodo positions.append para realizar esta accion en este punto.
				positions.append({
					# Guarda en bbcode el resultado de bbcode,.
					bbcode = bbcode,
					# Guarda en code el resultado de code,.
					code = code,
					# Guarda en start el resultado de start,.
					start = start,
					# Guarda en end el resultado de i,.
					end = i,
					# Guarda en raw_args el resultado de bbcode.substr(code.length() + 1, bbcode.length() - code.length() - 2).strip_edges().
					raw_args = bbcode.substr(code.length() + 1, bbcode.length() - code.length() - 2).strip_edges()
				# Ejecuta esta instruccion: }).
				})

				# Comprueba not find_all; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if not find_all:
					# Termina el metodo y devuelve positions a quien lo llamo.
					return positions

	# Termina el metodo y devuelve positions a quien lo llamo.
	return positions
