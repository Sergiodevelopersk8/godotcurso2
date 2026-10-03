## A single compilation instance of some dialogue.
class_name DMCompilation extends RefCounted


#region Compilation locals


## A list of file paths that were imported by this file.
var imported_paths: PackedStringArray = []
## A list of state names from "using" clauses.
var using_states: PackedStringArray = []
## A map of titles in this file.
var titles: Dictionary = {}
## The first encountered title in this file.
var first_title: String = ""
## A list of character names in this file.
var character_names: PackedStringArray = []
## A list of any compilation errors.
var errors: Array[Dictionary] = []
## A map of all compiled lines.
var lines: Dictionary = {}
## A flattened and simplified map of compiled lines for storage in a resource.
var data: Dictionary = {}


#endregion

#region Internal variables


# A list of all [RegEx] references
var regex: DMCompilerRegEx = DMCompilerRegEx.new()
# For parsing condition/mutation expressions
var expression_parser: DMExpressionParser = DMExpressionParser.new()

# A map of titles that came from imported files.
var _imported_titles: Dictionary = {}
# Used to keep track of circular imports.
var _imported_line_map: Dictionary = {}
# The number of imported lines.
var _imported_line_count: int = 0
# A list of already encountered static line IDs.
var _known_translation_keys: Dictionary = {}
# A noop for retrieving the next line without conditions.
var _first: Callable = func(_s): return true

# Title jumps are adjusted as they are parsed so any goto lines might need to be adjusted after they are first seen.
var _goto_lines: Dictionary = {}


#endregion

#region Main


## Compile some text.
func compile(text: String, path: String = ".") -> Error:
	# Guarda en titles el resultado de {}.
	titles = {}
	# Guarda en character_names el resultado de [].
	character_names = []

	# Llama al metodo parse_line_tree para realizar esta accion en este punto.
	parse_line_tree(build_line_tree(inject_imported_files(text + "\n=> END", path)))

	# Convert the compiles lines to a Dictionary so they can be stored.
	for id in lines:
		# Crea line e inicializa su valor con lines[id].
		var line: DMCompiledLine = lines[id]
		# Ejecuta esta instruccion: data[id] = line.to_data().
		data[id] = line.to_data()

	# Comprueba errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if errors.size() > 0:
		# Termina el metodo y devuelve ERR_PARSE_ERROR a quien lo llamo.
		return ERR_PARSE_ERROR

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


## Inject any imported files
func inject_imported_files(text: String, path: String) -> PackedStringArray:
	# Work out imports
	var known_imports: Dictionary = {}

	# Include the base file path so that we can get around circular dependencies
	known_imports[path.hash()] = "."

	# Crea raw_lines e inicializa su valor con text.split("\n").
	var raw_lines: PackedStringArray = text.split("\n")

	# Recorre range(0, raw_lines.size()) y asigna cada elemento a id en cada vuelta.
	for id in range(0, raw_lines.size()):
		# Crea line e inicializa su valor con raw_lines[id].
		var line = raw_lines[id]
		# Comprueba is_import_line(line); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if is_import_line(line):
			# Crea import_data e inicializa su valor con extract_import_path_and_name(line).
			var import_data: Dictionary = extract_import_path_and_name(line)

			# Ejecuta esta instruccion: if not import_data.has("path"): continue.
			if not import_data.has("path"): continue

			# Crea import_hash e inicializa su valor con import_data.path.hash().
			var import_hash: int = import_data.path.hash()
			# Comprueba import_data.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if import_data.size() > 0:
				# Keep track of titles so we can add imported ones later
				if str(import_hash) in _imported_titles.keys():
					# Llama al metodo add_error para realizar esta accion en este punto.
					add_error(id, 0, DMConstants.ERR_FILE_ALREADY_IMPORTED)
				# Comprueba import_data.prefix in _imported_titles.values(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if import_data.prefix in _imported_titles.values():
					# Llama al metodo add_error para realizar esta accion en este punto.
					add_error(id, 0, DMConstants.ERR_DUPLICATE_IMPORT_NAME)
				# Ejecuta esta instruccion: _imported_titles[str(import_hash)] = import_data.prefix.
				_imported_titles[str(import_hash)] = import_data.prefix

				# Import the file content
				if not known_imports.has(import_hash):
					# Crea error e inicializa su valor con import_content(import_data.path, import_data.prefix, _imported_line_map, known_imports).
					var error: Error = import_content(import_data.path, import_data.prefix, _imported_line_map, known_imports)
					# Comprueba error != OK; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if error != OK:
						# Llama al metodo add_error para realizar esta accion en este punto.
						add_error(id, 0, error)

				# Make a map so we can refer compiled lines to where they were imported from
				if not _imported_line_map.has(import_hash):
					# Ejecuta esta instruccion: _imported_line_map[import_hash] = {.
					_imported_line_map[import_hash] = {
						# Guarda en hash el resultado de import_hash,.
						hash = import_hash,
						# Guarda en imported_on_line_number el resultado de id,.
						imported_on_line_number = id,
						# Guarda en from_line el resultado de 0,.
						from_line = 0,
						# Guarda en to_line el resultado de 0.
						to_line = 0
					}

	# Crea imported_content e inicializa su valor con "".
	var imported_content: String =  ""
	# Crea cummulative_line_number e inicializa su valor con 0.
	var cummulative_line_number: int = 0
	# Recorre _imported_line_map.values() y asigna cada elemento a item en cada vuelta.
	for item in _imported_line_map.values():
		# Ejecuta esta instruccion: item["from_line"] = cummulative_line_number.
		item["from_line"] = cummulative_line_number
		# Comprueba known_imports.has(item.hash); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if known_imports.has(item.hash):
			# Suma a cummulative_line_number el valor known_imports[item.hash].split("\n").size() respecto de su valor anterior.
			cummulative_line_number += known_imports[item.hash].split("\n").size()
		# Ejecuta esta instruccion: item["to_line"] = cummulative_line_number.
		item["to_line"] = cummulative_line_number
		# Comprueba known_imports.has(item.hash); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if known_imports.has(item.hash):
			# Suma a imported_content el valor known_imports[item.hash] + "\n" respecto de su valor anterior.
			imported_content += known_imports[item.hash] + "\n"

	# Comprueba imported_content == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if imported_content == "":
		# Guarda en _imported_line_count el resultado de 0.
		_imported_line_count = 0
		# Termina el metodo y devuelve text.split("\n") a quien lo llamo.
		return text.split("\n")
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en _imported_line_count el resultado de cummulative_line_number + 1.
		_imported_line_count = cummulative_line_number + 1
		# Combine imported lines with the original lines
		return (imported_content + "\n" + text).split("\n")


## Import content from another dialogue file or return an ERR
func import_content(path: String, prefix: String, imported_line_map: Dictionary, known_imports: Dictionary) -> Error:
	# Comprueba FileAccess.file_exists(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if FileAccess.file_exists(path):
		# Crea file e inicializa su valor con FileAccess.open(path, FileAccess.READ).
		var file = FileAccess.open(path, FileAccess.READ)
		# Crea content e inicializa su valor con file.get_as_text().strip_edges().split("\n").
		var content: PackedStringArray = file.get_as_text().strip_edges().split("\n")

		# Recorre range(0, content.size()) y asigna cada elemento a index en cada vuelta.
		for index in range(0, content.size()):
			# Crea line e inicializa su valor con content[index].
			var line = content[index]
			# Comprueba is_import_line(line); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if is_import_line(line):
				# Crea import e inicializa su valor con extract_import_path_and_name(line).
				var import = extract_import_path_and_name(line)
				# Comprueba import.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if import.size() > 0:
					# Comprueba not known_imports.has(import.path.hash()); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if not known_imports.has(import.path.hash()):
						# Add an empty record into the keys just so we don't end up with cyclic dependencies
						known_imports[import.path.hash()] = ""
						# Comprueba import_content(import.path, import.prefix, imported_line_map, known_imports) != OK; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
						if import_content(import.path, import.prefix, imported_line_map, known_imports) != OK:
							# Termina el metodo y devuelve ERR_LINK_FAILED a quien lo llamo.
							return ERR_LINK_FAILED

					# Comprueba not imported_line_map.has(import.path.hash()); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if not imported_line_map.has(import.path.hash()):
						# Make a map so we can refer compiled lines to where they were imported from
						imported_line_map[import.path.hash()] = {
							# Guarda en hash el resultado de import.path.hash(),.
							hash = import.path.hash(),
							# Guarda en imported_on_line_number el resultado de index,.
							imported_on_line_number = index,
							# Guarda en from_line el resultado de 0,.
							from_line = 0,
							# Guarda en to_line el resultado de 0.
							to_line = 0
						}

					# Ejecuta esta instruccion: _imported_titles[import.prefix] = import.path.hash().
					_imported_titles[import.prefix] = import.path.hash()

		# Crea origin_hash e inicializa su valor con -1.
		var origin_hash: int = -1
		# Recorre known_imports.keys() y asigna cada elemento a hash_value en cada vuelta.
		for hash_value in known_imports.keys():
			# Comprueba known_imports[hash_value] == "."; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if known_imports[hash_value] == ".":
				# Guarda en origin_hash el resultado de hash_value.
				origin_hash = hash_value

		# Replace any titles or jump points with references to the files they point to (event if they point to their own file)
		for i in range(0, content.size()):
			# Crea line e inicializa su valor con content[i].
			var line = content[i]
			# Comprueba line.strip_edges().begins_with("~ "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if line.strip_edges().begins_with("~ "):
				# Crea indent e inicializa su valor con "\t".repeat(get_indent(line)).
				var indent: String = "\t".repeat(get_indent(line))
				# Crea title e inicializa su valor con line.strip_edges().substr(2).
				var title = line.strip_edges().substr(2)
				# Comprueba "/" in line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if "/" in line:
					# Crea bits e inicializa su valor con title.split("/").
					var bits = title.split("/")
					# Ejecuta esta instruccion: content[i] = "%s~ %s/%s" % [indent, _imported_titles[bits[0]], bits[1]].
					content[i] = "%s~ %s/%s" % [indent, _imported_titles[bits[0]], bits[1]]
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Ejecuta esta instruccion: content[i] = "%s~ %s/%s" % [indent, str(path.hash()), title].
					content[i] = "%s~ %s/%s" % [indent, str(path.hash()), title]

			# Comprueba "=>< " in line si las condiciones anteriores resultaron falsas.
			elif "=>< " in line:
				# Crea jump e inicializa su valor con line.substr(line.find("=>< ") + "=>< ".length()).strip_edges().
				var jump: String = line.substr(line.find("=>< ") + "=>< ".length()).strip_edges()
				# Comprueba "/" in jump; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if "/" in jump:
					# Crea bits e inicializa su valor con jump.split("/").
					var bits: PackedStringArray = jump.split("/")
					# Crea title_hash e inicializa su valor con _imported_titles[bits[0]].
					var title_hash: int = _imported_titles[bits[0]]
					# Comprueba title_hash == origin_hash; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if title_hash == origin_hash:
						# Ejecuta esta instruccion: content[i] = "%s=>< %s" % [line.split("=>< ")[0], bits[1]].
						content[i] = "%s=>< %s" % [line.split("=>< ")[0], bits[1]]
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Ejecuta esta instruccion: content[i] = "%s=>< %s/%s" % [line.split("=>< ")[0], title_hash, bits[1]].
						content[i] = "%s=>< %s/%s" % [line.split("=>< ")[0], title_hash, bits[1]]

				# Comprueba not jump in ["END", "END!"] si las condiciones anteriores resultaron falsas.
				elif not jump in ["END", "END!"]:
					# Ejecuta esta instruccion: content[i] = "%s=>< %s/%s" % [line.split("=>< ")[0], str(path.hash()), jump].
					content[i] = "%s=>< %s/%s" % [line.split("=>< ")[0], str(path.hash()), jump]

			# Comprueba "=> " in line si las condiciones anteriores resultaron falsas.
			elif "=> " in line:
				# Crea jump e inicializa su valor con line.substr(line.find("=> ") + "=> ".length()).strip_edges().
				var jump: String = line.substr(line.find("=> ") + "=> ".length()).strip_edges()
				# Comprueba "/" in jump; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if "/" in jump:
					# Crea bits e inicializa su valor con jump.split("/").
					var bits: PackedStringArray = jump.split("/")
					# Crea title_hash e inicializa su valor con _imported_titles[bits[0]].
					var title_hash: int = _imported_titles[bits[0]]
					# Comprueba title_hash == origin_hash; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if title_hash == origin_hash:
						# Ejecuta esta instruccion: content[i] = "%s=> %s" % [line.split("=> ")[0], bits[1]].
						content[i] = "%s=> %s" % [line.split("=> ")[0], bits[1]]
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Ejecuta esta instruccion: content[i] = "%s=> %s/%s" % [line.split("=> ")[0], title_hash, bits[1]].
						content[i] = "%s=> %s/%s" % [line.split("=> ")[0], title_hash, bits[1]]

				# Comprueba not jump in ["END", "END!"] si las condiciones anteriores resultaron falsas.
				elif not jump in ["END", "END!"]:
					# Ejecuta esta instruccion: content[i] = "%s=> %s/%s" % [line.split("=> ")[0], str(path.hash()), jump].
					content[i] = "%s=> %s/%s" % [line.split("=> ")[0], str(path.hash()), jump]

		# Llama al metodo imported_paths.append para realizar esta accion en este punto.
		imported_paths.append(path)
		# Ejecuta esta instruccion: known_imports[path.hash()] = "\n".join(content) + "\n=> END\n".
		known_imports[path.hash()] = "\n".join(content) + "\n=> END\n"
		# Termina el metodo y devuelve OK a quien lo llamo.
		return OK
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve ERR_FILE_NOT_FOUND a quien lo llamo.
		return ERR_FILE_NOT_FOUND


## Build a tree of parent/child relationships
func build_line_tree(raw_lines: PackedStringArray) -> DMTreeLine:
	# Crea root e inicializa su valor con DMTreeLine.new("").
	var root: DMTreeLine = DMTreeLine.new("")
	# Crea parent_chain e inicializa su valor con [root].
	var parent_chain: Array[DMTreeLine] = [root]
	# Declara previous_line para guardar un dato utilizado por este script.
	var previous_line: DMTreeLine
	# Crea doc_comments e inicializa su valor con [].
	var doc_comments: PackedStringArray = []

	# Get list of known autoloads
	var autoload_names: PackedStringArray = get_autoload_names()

	# Recorre range(0, raw_lines.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, raw_lines.size()):
		# Crea raw_line e inicializa su valor con raw_lines[i].
		var raw_line: String = raw_lines[i]
		# Crea tree_line e inicializa su valor con DMTreeLine.new(str(i - _imported_line_count)).
		var tree_line: DMTreeLine = DMTreeLine.new(str(i - _imported_line_count))

		# Guarda en tree_line.line_number el resultado de i + 1.
		tree_line.line_number = i + 1
		# Guarda en tree_line.type el resultado de get_line_type(raw_line).
		tree_line.type = get_line_type(raw_line)
		# Guarda en tree_line.text el resultado de raw_line.strip_edges().
		tree_line.text = raw_line.strip_edges()

		# Handle any "using" directives.
		if tree_line.type == DMConstants.TYPE_USING:
			# Crea using_match e inicializa su valor con regex.USING_REGEX.search(raw_line).
			var using_match: RegExMatch = regex.USING_REGEX.search(raw_line)
			# Comprueba "state" in using_match.names; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if "state" in using_match.names:
				# Crea using_state e inicializa su valor con using_match.strings[using_match.names.state].strip_edges().
				var using_state: String = using_match.strings[using_match.names.state].strip_edges()
				# Comprueba not using_state in autoload_names; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if not using_state in autoload_names:
					# Llama al metodo add_error para realizar esta accion en este punto.
					add_error(tree_line.line_number, 0, DMConstants.ERR_UNKNOWN_USING)
				# Comprueba not using_state in using_states si las condiciones anteriores resultaron falsas.
				elif not using_state in using_states:
					# Llama al metodo using_states.append para realizar esta accion en este punto.
					using_states.append(using_state)
				# Pasa directamente a la siguiente vuelta del bucle.
				continue
		# Ignore import lines because they've already been processed.
		elif is_import_line(raw_line):
			# Pasa directamente a la siguiente vuelta del bucle.
			continue

		# Guarda en tree_line.indent el resultado de get_indent(raw_line).
		tree_line.indent = get_indent(raw_line)

		# Attach doc comments
		if raw_line.strip_edges().begins_with("##"):
			# Llama al metodo doc_comments.append para realizar esta accion en este punto.
			doc_comments.append(raw_line.replace("##", "").strip_edges())
		# Comprueba tree_line.type == DMConstants.TYPE_DIALOGUE si las condiciones anteriores resultaron falsas.
		elif tree_line.type == DMConstants.TYPE_DIALOGUE:
			# Guarda en tree_line.notes el resultado de "\n".join(doc_comments).
			tree_line.notes = "\n".join(doc_comments)
			# Llama al metodo doc_comments.clear para realizar esta accion en este punto.
			doc_comments.clear()

		# Empty lines are only kept so that we can work out groupings of things (eg. randomised
		# lines). Therefore we only need to keep one empty line in a row even if there
		# are multiple. The indent of an empty line is assumed to be the same as the non-empty line
		# following it. That way, grouping calculations should work.
		if tree_line.type in [DMConstants.TYPE_UNKNOWN, DMConstants.TYPE_COMMENT] and raw_lines.size() > i + 1:
			# Crea next_line e inicializa su valor con raw_lines[i + 1].
			var next_line = raw_lines[i + 1]
			# Comprueba get_line_type(next_line) in [DMConstants.TYPE_UNKNOWN, DMConstants.TYPE_COMMENT]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if get_line_type(next_line) in [DMConstants.TYPE_UNKNOWN, DMConstants.TYPE_COMMENT]:
				# Pasa directamente a la siguiente vuelta del bucle.
				continue
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en tree_line.type el resultado de DMConstants.TYPE_UNKNOWN.
				tree_line.type = DMConstants.TYPE_UNKNOWN
				# Guarda en tree_line.indent el resultado de get_indent(next_line).
				tree_line.indent = get_indent(next_line)

		# Nothing should be more than a single indent past its parent.
		if tree_line.indent > parent_chain.size():
			# Llama al metodo add_error para realizar esta accion en este punto.
			add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_INDENTATION)

		# Check for indentation changes
		if tree_line.indent > parent_chain.size() - 1:
			# Llama al metodo parent_chain.append para realizar esta accion en este punto.
			parent_chain.append(previous_line)
		# Comprueba tree_line.indent < parent_chain.size() - 1 si las condiciones anteriores resultaron falsas.
		elif tree_line.indent < parent_chain.size() - 1:
			# Llama al metodo parent_chain.resize para realizar esta accion en este punto.
			parent_chain.resize(tree_line.indent + 1)

		# Add any titles to the list of known titles
		if tree_line.type == DMConstants.TYPE_TITLE:
			# Crea title e inicializa su valor con tree_line.text.substr(2).
			var title: String = tree_line.text.substr(2)
			# Comprueba title == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if title == "":
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(i, 2, DMConstants.ERR_EMPTY_TITLE)
			# Comprueba titles.has(title) si las condiciones anteriores resultaron falsas.
			elif titles.has(title):
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(i, 2, DMConstants.ERR_DUPLICATE_TITLE)
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Ejecuta esta instruccion: titles[title] = tree_line.id.
				titles[title] = tree_line.id
				# Comprueba "/" in title; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if "/" in title:
					# Replace the hash title with something human readable.
					var bits: PackedStringArray = title.split("/")
					# Comprueba _imported_titles.has(bits[0]); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if _imported_titles.has(bits[0]):
						# Guarda en title el resultado de _imported_titles[bits[0]] + "/" + bits[1].
						title = _imported_titles[bits[0]] + "/" + bits[1]
						# Ejecuta esta instruccion: titles[title] = tree_line.id.
						titles[title] = tree_line.id
				# Comprueba first_title == "" and i >= _imported_line_count si las condiciones anteriores resultaron falsas.
				elif first_title == "" and i >= _imported_line_count:
					# Guarda en first_title el resultado de tree_line.id.
					first_title = tree_line.id

		# Append the current line to the current parent (note: the root is the most basic parent).
		var parent: DMTreeLine = parent_chain[parent_chain.size() - 1]
		# Guarda en tree_line.parent el resultado de weakref(parent).
		tree_line.parent = weakref(parent)
		# Llama al metodo parent.children.append para realizar esta accion en este punto.
		parent.children.append(tree_line)

		# Guarda en previous_line el resultado de tree_line.
		previous_line = tree_line

	# Termina el metodo y devuelve root a quien lo llamo.
	return root


#endregion

#region Parsing


# Define el metodo parse_line_tree para agrupar esta accion del script.
func parse_line_tree(root: DMTreeLine, parent: DMCompiledLine = null) -> Array[DMCompiledLine]:
	# Crea compiled_lines e inicializa su valor con [].
	var compiled_lines: Array[DMCompiledLine] = []

	# Recorre range(0, root.children.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, root.children.size()):
		# Crea tree_line e inicializa su valor con root.children[i].
		var tree_line: DMTreeLine = root.children[i]
		# Crea line e inicializa su valor con DMCompiledLine.new(tree_line.id, tree_line.type).
		var line: DMCompiledLine = DMCompiledLine.new(tree_line.id, tree_line.type)

		# Compara line.type con los casos siguientes y ejecuta el que coincida.
		match line.type:
			# Ejecuta esta instruccion: DMConstants.TYPE_UNKNOWN:.
			DMConstants.TYPE_UNKNOWN:
				# Guarda en line.next_id el resultado de get_next_matching_sibling_id(root.children, i, parent, _first).
				line.next_id = get_next_matching_sibling_id(root.children, i, parent, _first)

			# Ejecuta esta instruccion: DMConstants.TYPE_TITLE:.
			DMConstants.TYPE_TITLE:
				# Llama al metodo parse_title_line para realizar esta accion en este punto.
				parse_title_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_CONDITION:.
			DMConstants.TYPE_CONDITION:
				# Llama al metodo parse_condition_line para realizar esta accion en este punto.
				parse_condition_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_WHILE:.
			DMConstants.TYPE_WHILE:
				# Llama al metodo parse_while_line para realizar esta accion en este punto.
				parse_while_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_MATCH:.
			DMConstants.TYPE_MATCH:
				# Llama al metodo parse_match_line para realizar esta accion en este punto.
				parse_match_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_WHEN:.
			DMConstants.TYPE_WHEN:
				# Llama al metodo parse_when_line para realizar esta accion en este punto.
				parse_when_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_MUTATION:.
			DMConstants.TYPE_MUTATION:
				# Llama al metodo parse_mutation_line para realizar esta accion en este punto.
				parse_mutation_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_GOTO:.
			DMConstants.TYPE_GOTO:
				# Extract any weighted random calls before parsing dialogue
				if tree_line.text.begins_with("%"):
					# Llama al metodo parse_random_line para realizar esta accion en este punto.
					parse_random_line(tree_line, line, root.children, i, parent)
				# Llama al metodo parse_goto_line para realizar esta accion en este punto.
				parse_goto_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_RESPONSE:.
			DMConstants.TYPE_RESPONSE:
				# Llama al metodo parse_response_line para realizar esta accion en este punto.
				parse_response_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_RANDOM:.
			DMConstants.TYPE_RANDOM:
				# Llama al metodo parse_random_line para realizar esta accion en este punto.
				parse_random_line(tree_line, line, root.children, i, parent)

			# Ejecuta esta instruccion: DMConstants.TYPE_DIALOGUE:.
			DMConstants.TYPE_DIALOGUE:
				# Extract any weighted random calls before parsing dialogue
				if tree_line.text.begins_with("%"):
					# Llama al metodo parse_random_line para realizar esta accion en este punto.
					parse_random_line(tree_line, line, root.children, i, parent)
				# Llama al metodo parse_dialogue_line para realizar esta accion en este punto.
				parse_dialogue_line(tree_line, line, root.children, i, parent)

		# Main line map is keyed by ID
		lines[line.id] = line

		# Returned lines order is preserved so that it can be used for compiling children
		compiled_lines.append(line)

	# Termina el metodo y devuelve compiled_lines a quien lo llamo.
	return compiled_lines


## Parse a title and apply it to the given line
func parse_title_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea result e inicializa su valor con OK.
	var result: Error = OK

	# Guarda en line.text el resultado de tree_line.text.substr(tree_line.text.find("~ ") + 2).strip_edges().
	line.text = tree_line.text.substr(tree_line.text.find("~ ") + 2).strip_edges()

	# Titles can't have numbers as the first letter (unless they are external titles which get replaced with hashes)
	if tree_line.line_number >= _imported_line_count and regex.BEGINS_WITH_NUMBER_REGEX.search(line.text):
		# Guarda en result el resultado de add_error(tree_line.line_number, 2, DMConstants.ERR_TITLE_BEGINS_WITH_NUMBER).
		result = add_error(tree_line.line_number, 2, DMConstants.ERR_TITLE_BEGINS_WITH_NUMBER)

	# Only import titles are allowed to have "/" in them
	var valid_title = regex.VALID_TITLE_REGEX.search(line.text.replace("/", ""))
	# Comprueba not valid_title; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not valid_title:
		# Guarda en result el resultado de add_error(tree_line.line_number, 2, DMConstants.ERR_TITLE_INVALID_CHARACTERS).
		result = add_error(tree_line.line_number, 2, DMConstants.ERR_TITLE_INVALID_CHARACTERS)

	# Guarda en line.next_id el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, _first).
	line.next_id = get_next_matching_sibling_id(siblings, sibling_index, parent, _first)

	## Update the titles reference to point to the actual first line
	titles[line.text] = line.next_id

	## Update any lines that point to this title
	if _goto_lines.has(line.text):
		# Recorre _goto_lines[line.text] y asigna cada elemento a goto_line en cada vuelta.
		for goto_line in _goto_lines[line.text]:
			# Guarda en goto_line.next_id el resultado de line.next_id.
			goto_line.next_id = line.next_id

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


## Parse a goto and apply it to the given line.
func parse_goto_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Work out where this line is jumping to.
	var goto_data: DMResolvedGotoData = DMResolvedGotoData.new(tree_line.text, titles)
	# Comprueba goto_data.error; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if goto_data.error:
		# Termina el metodo y devuelve add_error(tree_line.line_number, tree_line.indent + 2, goto_data.error) a quien lo llamo.
		return add_error(tree_line.line_number, tree_line.indent + 2, goto_data.error)
	# Comprueba goto_data.next_id or goto_data.expression; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if goto_data.next_id or goto_data.expression:
		# Guarda en line.next_id el resultado de goto_data.next_id.
		line.next_id = goto_data.next_id
		# Guarda en line.next_id_expression el resultado de goto_data.expression.
		line.next_id_expression = goto_data.expression
		# Llama al metodo add_reference_to_title para realizar esta accion en este punto.
		add_reference_to_title(goto_data.title, line)

	# Comprueba goto_data.is_snippet; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if goto_data.is_snippet:
		# Guarda en line.is_snippet el resultado de true.
		line.is_snippet = true
		# Guarda en line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, _first).
		line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, _first)

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


## Parse a condition line and apply to the given line
func parse_condition_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Work out the next IDs before parsing the condition line itself so that the last
	# child can inherit from the chain.

	# Find the next conditional sibling that is part of this grouping (if there is one).
	for next_sibling: DMTreeLine in siblings.slice(sibling_index + 1):
		# Comprueba not next_sibling.type in [DMConstants.TYPE_UNKNOWN, DMConstants.TYPE_CONDITION]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not next_sibling.type in [DMConstants.TYPE_UNKNOWN, DMConstants.TYPE_CONDITION]:
			# Termina inmediatamente el bucle actual.
			break
		# Comprueba next_sibling.type == DMConstants.TYPE_CONDITION si las condiciones anteriores resultaron falsas.
		elif next_sibling.type == DMConstants.TYPE_CONDITION:
			# Comprueba next_sibling.text.begins_with("el"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if next_sibling.text.begins_with("el"):
				# Guarda en line.next_sibling_id el resultado de next_sibling.id.
				line.next_sibling_id = next_sibling.id
				# Termina inmediatamente el bucle actual.
				break
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina inmediatamente el bucle actual.
				break

	# Guarda en line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, func(s: DMTreeLine):.
	line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, func(s: DMTreeLine):
		# The next line that isn't a conditional or is a new "if"
		return s.type != DMConstants.TYPE_CONDITION or s.text.begins_with("if ")
	)
	# Any empty IDs should end the conversation.
	if line.next_id_after == DMConstants.ID_NULL:
		# Guarda en line.next_id_after el resultado de parent.next_id_after if parent != null and parent.next_id_after else DMConstants.ID_END.
		line.next_id_after = parent.next_id_after if parent != null and parent.next_id_after else DMConstants.ID_END

	# Having no nested body is an immediate failure.
	if tree_line.children.size() == 0:
		# Termina el metodo y devuelve add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_CONDITION_INDENTATION) a quien lo llamo.
		return add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_CONDITION_INDENTATION)

	# Try to parse the conditional expression ("else" has no expression).
	if "if " in tree_line.text:
		# Crea condition e inicializa su valor con extract_condition(tree_line.text, false, tree_line.indent).
		var condition: Dictionary = extract_condition(tree_line.text, false, tree_line.indent)
		# Comprueba condition.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if condition.has("error"):
			# Termina el metodo y devuelve add_error(tree_line.line_number, condition.index, condition.error) a quien lo llamo.
			return add_error(tree_line.line_number, condition.index, condition.error)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en line.expression el resultado de condition.
			line.expression = condition

	# Parse any nested body lines
	parse_children(tree_line, line)

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


## Parse a while loop and apply it to the given line.
func parse_while_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Guarda en line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, _first).
	line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, _first)

	# Parse the while condition
	var condition: Dictionary = extract_condition(tree_line.text, false, tree_line.indent)
	# Comprueba condition.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if condition.has("error"):
		# Termina el metodo y devuelve add_error(tree_line.line_number, condition.index, condition.error) a quien lo llamo.
		return add_error(tree_line.line_number, condition.index, condition.error)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en line.expression el resultado de condition.
		line.expression = condition

	# Parse the nested body (it should take care of looping back to this line when it finishes)
	parse_children(tree_line, line)

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


# Define el metodo parse_match_line para agrupar esta accion del script.
func parse_match_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea result e inicializa su valor con OK.
	var result: Error = OK

	# The next line after is the next sibling
	line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, _first)

	# Extract the condition to match to
	var condition: Dictionary = extract_condition(tree_line.text, false, tree_line.indent)
	# Comprueba condition.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if condition.has("error"):
		# Guarda en result el resultado de add_error(tree_line.line_number, condition.index, condition.error).
		result = add_error(tree_line.line_number, condition.index, condition.error)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en line.expression el resultado de condition.
		line.expression = condition

	# Match statements should have children
	if tree_line.children.size() == 0:
		# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_CONDITION_INDENTATION).
		result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_CONDITION_INDENTATION)

	# Check that all children are when or else.
	for child in tree_line.children:
		# Ejecuta esta instruccion: if child.type == DMConstants.TYPE_WHEN: continue.
		if child.type == DMConstants.TYPE_WHEN: continue
		# Ejecuta esta instruccion: if child.type == DMConstants.TYPE_UNKNOWN: continue.
		if child.type == DMConstants.TYPE_UNKNOWN: continue
		# Ejecuta esta instruccion: if child.type == DMConstants.TYPE_CONDITION and child.text.begins_with("else"): continue.
		if child.type == DMConstants.TYPE_CONDITION and child.text.begins_with("else"): continue

		# Guarda en result el resultado de add_error(child.line_number, child.indent, DMConstants.ERR_EXPECTED_WHEN_OR_ELSE).
		result = add_error(child.line_number, child.indent, DMConstants.ERR_EXPECTED_WHEN_OR_ELSE)

	# Each child should be a "when" or "else". We don't need those lines themselves, just their
	# condition and the line they point to if the conditions passes.
	var children: Array[DMCompiledLine] = parse_children(tree_line, line)
	# Ejecuta esta instruccion: for child: DMCompiledLine in children:.
	for child: DMCompiledLine in children:
		# "when" cases
		if child.type == DMConstants.TYPE_WHEN:
			# Llama al metodo line.siblings.append para realizar esta accion en este punto.
			line.siblings.append({
				# Guarda en condition el resultado de child.expression,.
				condition = child.expression,
				# Guarda en next_id el resultado de child.next_id.
				next_id = child.next_id
			# Ejecuta esta instruccion: }).
			})
		# "else" case
		elif child.type == DMConstants.TYPE_CONDITION:
			# Comprueba line.siblings.any(func(s): return s.has("is_else")); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if line.siblings.any(func(s): return s.has("is_else")):
				# Guarda en result el resultado de add_error(child.line_number, child.indent, DMConstants.ERR_ONLY_ONE_ELSE_ALLOWED).
				result = add_error(child.line_number, child.indent, DMConstants.ERR_ONLY_ONE_ELSE_ALLOWED)
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Llama al metodo line.siblings.append para realizar esta accion en este punto.
				line.siblings.append({
					# Guarda en next_id el resultado de child.next_id,.
					next_id = child.next_id,
					# Guarda en is_else el resultado de true.
					is_else = true
				# Ejecuta esta instruccion: }).
				})
		# Remove the line from the list of all lines because we don't need it any more.
		lines.erase(child.id)

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


# Define el metodo parse_when_line para agrupar esta accion del script.
func parse_when_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea result e inicializa su valor con OK.
	var result: Error = OK

	# This when line should be found inside a match line
	if parent.type != DMConstants.TYPE_MATCH:
		# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_WHEN_MUST_BELONG_TO_MATCH).
		result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_WHEN_MUST_BELONG_TO_MATCH)

	# When lines should have children
	if tree_line.children.size() == 0:
		# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_CONDITION_INDENTATION).
		result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_CONDITION_INDENTATION)

	# The next line after a when is the same as its parent match line
	line.next_id_after = parent.next_id_after

	# Extract the condition to match to
	var condition: Dictionary = extract_condition(tree_line.text, false, tree_line.indent)
	# Comprueba condition.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if condition.has("error"):
		# Guarda en result el resultado de add_error(tree_line.line_number, condition.index, condition.error).
		result = add_error(tree_line.line_number, condition.index, condition.error)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en line.expression el resultado de condition.
		line.expression = condition

	# Llama al metodo parse_children para realizar esta accion en este punto.
	parse_children(tree_line, line)

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


## Parse a mutation line and apply it to the given line
func parse_mutation_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea mutation e inicializa su valor con extract_mutation(tree_line.text).
	var mutation: Dictionary = extract_mutation(tree_line.text)
	# Comprueba mutation.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if mutation.has("error"):
		# Termina el metodo y devuelve add_error(tree_line.line_number, mutation.index, mutation.error) a quien lo llamo.
		return add_error(tree_line.line_number, mutation.index, mutation.error)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en line.expression el resultado de mutation.
		line.expression = mutation

	# Guarda en line.next_id el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, _first).
	line.next_id = get_next_matching_sibling_id(siblings, sibling_index, parent, _first)

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


## Parse a response and apply it to the given line.
func parse_response_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea result e inicializa su valor con OK.
	var result: Error = OK

	# Remove the "- "
	tree_line.text = tree_line.text.substr(2)

	# Extract the static line ID
	var static_line_id: String = extract_static_line_id(tree_line.text)
	# Comprueba static_line_id; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if static_line_id:
		# Guarda en tree_line.text el resultado de tree_line.text.replace("[ID:%s]" % [static_line_id], "").
		tree_line.text = tree_line.text.replace("[ID:%s]" % [static_line_id], "")
		# Guarda en line.translation_key el resultado de static_line_id.
		line.translation_key = static_line_id

	# Handle conditional responses and remove them from the prompt text.
	if " [if " in tree_line.text:
		# Crea condition e inicializa su valor con extract_condition(tree_line.text, true, tree_line.indent).
		var condition = extract_condition(tree_line.text, true, tree_line.indent)
		# Comprueba condition.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if condition.has("error"):
			# Guarda en result el resultado de add_error(tree_line.line_number, condition.index, condition.error).
			result = add_error(tree_line.line_number, condition.index, condition.error)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en line.expression el resultado de condition.
			line.expression = condition
			# Extract just the raw condition text
			var found: RegExMatch = regex.WRAPPED_CONDITION_REGEX.search(tree_line.text)
			# Guarda en line.expression_text el resultado de found.strings[found.names.expression].
			line.expression_text = found.strings[found.names.expression]

			# Guarda en tree_line.text el resultado de regex.WRAPPED_CONDITION_REGEX.sub(tree_line.text, "").strip_edges().
			tree_line.text = regex.WRAPPED_CONDITION_REGEX.sub(tree_line.text, "").strip_edges()

	# Find the original response in this group of responses.
	var original_response: DMTreeLine = tree_line
	# Recorre range(sibling_index - 1, -1, -1) y asigna cada elemento a i en cada vuelta.
	for i in range(sibling_index - 1, -1, -1):
		# Comprueba siblings[i].type == DMConstants.TYPE_RESPONSE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if siblings[i].type == DMConstants.TYPE_RESPONSE:
			# Guarda en original_response el resultado de siblings[i].
			original_response = siblings[i]
		# Comprueba siblings[i].type != DMConstants.TYPE_UNKNOWN si las condiciones anteriores resultaron falsas.
		elif siblings[i].type != DMConstants.TYPE_UNKNOWN:
			# Termina inmediatamente el bucle actual.
			break

	# If it's the original response then set up an original line.
	if original_response == tree_line:
		# Guarda en line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, (func(s: DMTreeLine):.
		line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, (func(s: DMTreeLine):
			# The next line that isn't a response.
			return not s.type in [DMConstants.TYPE_RESPONSE, DMConstants.TYPE_UNKNOWN]
		# Ejecuta esta instruccion: ), true).
		), true)
		# Guarda en line.responses el resultado de [line.id].
		line.responses = [line.id]
		# If this line has children then the next ID is the first child.
		if tree_line.children.size() > 0:
			# Llama al metodo parse_children para realizar esta accion en este punto.
			parse_children(tree_line, line)
		# Otherwise use the same ID for after the random group.
		else:
			# Guarda en line.next_id el resultado de line.next_id_after.
			line.next_id = line.next_id_after
	# Otherwise let the original line know about it.
	else:
		# Crea original_line e inicializa su valor con lines[original_response.id].
		var original_line: DMCompiledLine = lines[original_response.id]
		# Guarda en line.next_id_after el resultado de original_line.next_id_after.
		line.next_id_after = original_line.next_id_after
		# Guarda en line.siblings el resultado de original_line.siblings.
		line.siblings = original_line.siblings
		# Llama al metodo original_line.responses.append para realizar esta accion en este punto.
		original_line.responses.append(line.id)
		# If this line has children then the next ID is the first child.
		if tree_line.children.size() > 0:
			# Llama al metodo parse_children para realizar esta accion en este punto.
			parse_children(tree_line, line)
		# Otherwise use the original line's next ID after.
		else:
			# Guarda en line.next_id el resultado de original_line.next_id_after.
			line.next_id = original_line.next_id_after

	# Llama al metodo parse_character_and_dialogue para realizar esta accion en este punto.
	parse_character_and_dialogue(tree_line, line, siblings, sibling_index, parent)

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


## Parse a randomised line
func parse_random_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Find the weight
	var weight: float = 1
	# Crea found e inicializa su valor con regex.WEIGHTED_RANDOM_SIBLINGS_REGEX.search(tree_line.text + " ").
	var found = regex.WEIGHTED_RANDOM_SIBLINGS_REGEX.search(tree_line.text + " ")
	# Crea condition e inicializa su valor con {}.
	var condition: Dictionary = {}
	# Comprueba found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if found:
		# Comprueba found.names.has("weight"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if found.names.has("weight"):
			# Guarda en weight el resultado de found.strings[found.names.weight].to_float().
			weight = found.strings[found.names.weight].to_float()
		# Comprueba found.names.has("condition"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if found.names.has("condition"):
			# Guarda en condition el resultado de extract_condition(tree_line.text, true, tree_line.indent).
			condition = extract_condition(tree_line.text, true, tree_line.indent)

	# Find the original random sibling. It will be the jump off point.
	var original_sibling: DMTreeLine = tree_line
	# Recorre range(sibling_index - 1, -1, -1) y asigna cada elemento a i en cada vuelta.
	for i in range(sibling_index - 1, -1, -1):
		# Comprueba siblings[i] and siblings[i].is_random; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if siblings[i] and siblings[i].is_random:
			# Guarda en original_sibling el resultado de siblings[i].
			original_sibling = siblings[i]
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina inmediatamente el bucle actual.
			break

	# Crea weighted_sibling e inicializa su valor con { weight = weight, id = line.id, condition = condition }.
	var weighted_sibling: Dictionary = { weight = weight, id = line.id, condition = condition }

	# If it's the original sibling then set up an original line.
	if original_sibling == tree_line:
		# Guarda en line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, (func(s: DMTreeLine):.
		line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, (func(s: DMTreeLine):
			# The next line that isn't a randomised line.
			# NOTE: DMTreeLine.is_random won't be set at this point so we need to check for the "%" prefix.
			return not s.text.begins_with("%")
		# Ejecuta esta instruccion: ), true).
		), true)
		# Guarda en line.siblings el resultado de [weighted_sibling].
		line.siblings = [weighted_sibling]
		# If this line has children then the next ID is the first child.
		if tree_line.children.size() > 0:
			# Llama al metodo parse_children para realizar esta accion en este punto.
			parse_children(tree_line, line)
		# Otherwise use the same ID for after the random group.
		else:
			# Guarda en line.next_id el resultado de line.next_id_after.
			line.next_id = line.next_id_after

	# Otherwise let the original line know about it.
	else:
		# Crea original_line e inicializa su valor con lines[original_sibling.id].
		var original_line: DMCompiledLine = lines[original_sibling.id]
		# Guarda en line.next_id_after el resultado de original_line.next_id_after.
		line.next_id_after = original_line.next_id_after
		# Guarda en line.siblings el resultado de original_line.siblings.
		line.siblings = original_line.siblings
		# Llama al metodo original_line.siblings.append para realizar esta accion en este punto.
		original_line.siblings.append(weighted_sibling)
		# If this line has children then the next ID is the first child.
		if tree_line.children.size() > 0:
			# Llama al metodo parse_children para realizar esta accion en este punto.
			parse_children(tree_line, line)
		# Otherwise use the original line's next ID after.
		else:
			# Guarda en line.next_id el resultado de original_line.next_id_after.
			line.next_id = original_line.next_id_after

	# Remove the randomise syntax from the line.
	tree_line.text = regex.WEIGHTED_RANDOM_SIBLINGS_REGEX.sub(tree_line.text, "")
	# Guarda en tree_line.is_random el resultado de true.
	tree_line.is_random = true

	# Termina el metodo y devuelve OK a quien lo llamo.
	return OK


## Parse some dialogue and apply it to the given line.
func parse_dialogue_line(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea result e inicializa su valor con OK.
	var result: Error = OK

	# Remove escape character
	if tree_line.text.begins_with("\\using"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\if"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\if"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\elif"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\elif"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\else"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\else"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\while"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\while"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\match"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\match"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\when"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\when"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\do"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\do"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\set"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\set"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\-"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\-"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\~"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\~"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\=>"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\=>"): tree_line.text = tree_line.text.substr(1)
	# Ejecuta esta instruccion: if tree_line.text.begins_with("\\%"): tree_line.text = tree_line.text.substr(1).
	if tree_line.text.begins_with("\\%"): tree_line.text = tree_line.text.substr(1)

	# Append any further dialogue
	for i in range(0, tree_line.children.size()):
		# Crea child e inicializa su valor con tree_line.children[i].
		var child: DMTreeLine = tree_line.children[i]
		# Comprueba child.type == DMConstants.TYPE_DIALOGUE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if child.type == DMConstants.TYPE_DIALOGUE:
			# Nested dialogue lines cannot have further nested dialogue.
			if child.children.size() > 0:
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(child.children[0].line_number, child.children[0].indent, DMConstants.ERR_INVALID_INDENTATION)
			# Mark this as a dialogue child of another dialogue line.
			child.is_nested_dialogue = true
			# Crea child_line e inicializa su valor con DMCompiledLine.new("", DMConstants.TYPE_DIALOGUE).
			var child_line = DMCompiledLine.new("", DMConstants.TYPE_DIALOGUE)
			# Llama al metodo parse_character_and_dialogue para realizar esta accion en este punto.
			parse_character_and_dialogue(child, child_line, [], 0, parent)
			# Crea child_static_line_id e inicializa su valor con extract_static_line_id(child.text).
			var child_static_line_id: String = extract_static_line_id(child.text)
			# Comprueba child_line.character != "" or child_static_line_id != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if child_line.character != "" or child_static_line_id != "":
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(child.line_number, child.indent, DMConstants.ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE)
			# Check that only the last child (or none) has a jump reference
			if i < tree_line.children.size() - 1 and " =>" in child.text:
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(child.line_number, child.indent, DMConstants.ERR_NESTED_DIALOGUE_INVALID_JUMP)
			# Comprueba i == 0 and " =>" in tree_line.text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if i == 0 and " =>" in tree_line.text:
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_NESTED_DIALOGUE_INVALID_JUMP)

			# Suma a tree_line.text el valor "\n" + child.text respecto de su valor anterior.
			tree_line.text += "\n" + child.text
		# Comprueba child.type == DMConstants.TYPE_UNKNOWN si las condiciones anteriores resultaron falsas.
		elif child.type == DMConstants.TYPE_UNKNOWN:
			# Suma a tree_line.text el valor "\n" respecto de su valor anterior.
			tree_line.text += "\n"
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en result el resultado de add_error(child.line_number, child.indent, DMConstants.ERR_INVALID_INDENTATION).
			result = add_error(child.line_number, child.indent, DMConstants.ERR_INVALID_INDENTATION)

	# Extract the static line ID
	var static_line_id: String = extract_static_line_id(tree_line.text)
	# Comprueba static_line_id; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if static_line_id:
		# Guarda en tree_line.text el resultado de tree_line.text.replace(" [ID:", "[ID:").replace("[ID:%s]" % [static_line_id], "").
		tree_line.text = tree_line.text.replace(" [ID:", "[ID:").replace("[ID:%s]" % [static_line_id], "")
		# Guarda en line.translation_key el resultado de static_line_id.
		line.translation_key = static_line_id

	# Check for simultaneous lines
	if tree_line.text.begins_with("| "):
		# Jumps are only allowed on the origin line.
		if " =>" in tree_line.text:
			# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES).
			result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES)
		# Check for a valid previous line.
		tree_line.text = tree_line.text.substr(2)
		# Crea previous_sibling e inicializa su valor con siblings[sibling_index - 1].
		var previous_sibling: DMTreeLine = siblings[sibling_index - 1]
		# Comprueba previous_sibling.type != DMConstants.TYPE_DIALOGUE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if previous_sibling.type != DMConstants.TYPE_DIALOGUE:
			# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_CONCURRENT_LINE_WITHOUT_ORIGIN).
			result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_CONCURRENT_LINE_WITHOUT_ORIGIN)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Because the previous line's concurrent_lines array is the same as
			# any line before that this doesn't need to check any higher up.
			var previous_line: DMCompiledLine = lines[previous_sibling.id]
			# Llama al metodo previous_line.concurrent_lines.append para realizar esta accion en este punto.
			previous_line.concurrent_lines.append(line.id)
			# Guarda en line.concurrent_lines el resultado de previous_line.concurrent_lines.
			line.concurrent_lines = previous_line.concurrent_lines

	# Llama al metodo parse_character_and_dialogue para realizar esta accion en este punto.
	parse_character_and_dialogue(tree_line, line, siblings, sibling_index, parent)

	# Check for any inline expression errors
	var resolved_line_data: DMResolvedLineData = DMResolvedLineData.new("")
	# Crea bbcodes e inicializa su valor con resolved_line_data.find_bbcode_positions_in_string(tree_line.text, true, true).
	var bbcodes: Array[Dictionary] = resolved_line_data.find_bbcode_positions_in_string(tree_line.text, true, true)
	# Ejecuta esta instruccion: for bbcode: Dictionary in bbcodes:.
	for bbcode: Dictionary in bbcodes:
		# Crea tag e inicializa su valor con bbcode.code.
		var tag: String = bbcode.code
		# Crea code e inicializa su valor con bbcode.raw_args.
		var code: String = bbcode.raw_args
		# Comprueba tag.begins_with("do") or tag.begins_with("set") or tag.begins_with("if"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if tag.begins_with("do") or tag.begins_with("set") or tag.begins_with("if"):
			# Crea expression e inicializa su valor con expression_parser.tokenise(code, DMConstants.TYPE_MUTATION, bbcode.start + bbcode.code.length()).
			var expression: Array = expression_parser.tokenise(code, DMConstants.TYPE_MUTATION, bbcode.start + bbcode.code.length())
			# Comprueba expression.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if expression.size() == 0:
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_INVALID_EXPRESSION)
			# Comprueba expression[0].type == DMConstants.TYPE_ERROR si las condiciones anteriores resultaron falsas.
			elif expression[0].type == DMConstants.TYPE_ERROR:
				# Llama al metodo add_error para realizar esta accion en este punto.
				add_error(tree_line.line_number, tree_line.indent + expression[0].i, expression[0].value)

	# If the line isn't part of a weighted random group then make it point to the next
	# available sibling.
	if line.next_id == DMConstants.ID_NULL and line.siblings.size() == 0:
		# Guarda en line.next_id el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, func(s: DMTreeLine):.
		line.next_id = get_next_matching_sibling_id(siblings, sibling_index, parent, func(s: DMTreeLine):
			# Ignore concurrent lines.
			return not s.text.begins_with("| ")
		)

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


## Parse the character name and dialogue and apply it to a given line.
func parse_character_and_dialogue(tree_line: DMTreeLine, line: DMCompiledLine, siblings: Array[DMTreeLine], sibling_index: int, parent: DMCompiledLine) -> Error:
	# Crea result e inicializa su valor con OK.
	var result: Error = OK

	# Crea text e inicializa su valor con tree_line.text.
	var text: String = tree_line.text

	# Attach any doc comments.
	line.notes = tree_line.notes

	# Extract tags.
	var tag_data: DMResolvedTagData = DMResolvedTagData.new(text)
	# Guarda en line.tags el resultado de tag_data.tags.
	line.tags = tag_data.tags
	# Guarda en text el resultado de tag_data.text_without_tags.
	text = tag_data.text_without_tags

	# Handle inline gotos and remove them from the prompt text.
	if " =><" in text:
		# Because of when the return point needs to be known at runtime we need to split
		# this line into two (otherwise the return point would be dependent on the balloon).
		var goto_data: DMResolvedGotoData = DMResolvedGotoData.new(text, titles)
		# Comprueba goto_data.error; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if goto_data.error:
			# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent + 3, goto_data.error).
			result = add_error(tree_line.line_number, tree_line.indent + 3, goto_data.error)
		# Comprueba goto_data.next_id or goto_data.expression; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if goto_data.next_id or goto_data.expression:
			# Guarda en text el resultado de goto_data.text_without_goto.
			text = goto_data.text_without_goto
			# Crea goto_line e inicializa su valor con DMCompiledLine.new(line.id + ".1", DMConstants.TYPE_GOTO).
			var goto_line: DMCompiledLine = DMCompiledLine.new(line.id + ".1", DMConstants.TYPE_GOTO)
			# Guarda en goto_line.next_id el resultado de goto_data.next_id.
			goto_line.next_id = goto_data.next_id
			# Guarda en line.next_id_expression el resultado de goto_data.expression.
			line.next_id_expression = goto_data.expression
			# Comprueba line.type == DMConstants.TYPE_RESPONSE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if line.type == DMConstants.TYPE_RESPONSE:
				# Guarda en goto_line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, func(s: DMTreeLine):.
				goto_line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, func(s: DMTreeLine):
					# If this is coming from a response then we want the next non-response line.
					return s.type != DMConstants.TYPE_RESPONSE
				)
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en goto_line.next_id_after el resultado de get_next_matching_sibling_id(siblings, sibling_index, parent, _first).
				goto_line.next_id_after = get_next_matching_sibling_id(siblings, sibling_index, parent, _first)
			# Guarda en goto_line.is_snippet el resultado de true.
			goto_line.is_snippet = true
			# Ejecuta esta instruccion: lines[goto_line.id] = goto_line.
			lines[goto_line.id] = goto_line
			# Guarda en line.next_id el resultado de goto_line.id.
			line.next_id = goto_line.id
			# Llama al metodo add_reference_to_title para realizar esta accion en este punto.
			add_reference_to_title(goto_data.title, goto_line)
	# Comprueba " =>" in text si las condiciones anteriores resultaron falsas.
	elif " =>" in text:
		# Crea goto_data e inicializa su valor con DMResolvedGotoData.new(text, titles).
		var goto_data: DMResolvedGotoData = DMResolvedGotoData.new(text, titles)
		# Comprueba goto_data.error; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if goto_data.error:
			# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent + 2, goto_data.error).
			result = add_error(tree_line.line_number, tree_line.indent + 2, goto_data.error)
		# Comprueba goto_data.next_id or goto_data.expression; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if goto_data.next_id or goto_data.expression:
			# Guarda en text el resultado de goto_data.text_without_goto.
			text = goto_data.text_without_goto
			# Guarda en line.next_id el resultado de goto_data.next_id.
			line.next_id = goto_data.next_id
			# Guarda en line.next_id_expression el resultado de goto_data.expression.
			line.next_id_expression = goto_data.expression
			# Llama al metodo add_reference_to_title para realizar esta accion en este punto.
			add_reference_to_title(goto_data.title, line)

	# Handle the dialogue.
	text = text.replace("\\:", "!ESCAPED_COLON!")
	# Comprueba ": " in text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if ": " in text:
		# If a character was given then split it out.
		var bits = Array(text.strip_edges().split(": "))
		# Guarda en line.character el resultado de bits.pop_front().strip_edges().
		line.character = bits.pop_front().strip_edges()
		# Comprueba not line.character in character_names; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not line.character in character_names:
			# Llama al metodo character_names.append para realizar esta accion en este punto.
			character_names.append(line["character"])
		# Character names can have expressions in them.
		line.character_replacements = expression_parser.extract_replacements(line.character, tree_line.indent)
		# Recorre line.character_replacements y asigna cada elemento a replacement en cada vuelta.
		for replacement in line.character_replacements:
			# Comprueba replacement.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if replacement.has("error"):
				# Guarda en result el resultado de add_error(tree_line.line_number, replacement.index, replacement.error).
				result = add_error(tree_line.line_number, replacement.index, replacement.error)
		# Guarda en text el resultado de ": ".join(bits).replace("!ESCAPED_COLON!", ":").
		text = ": ".join(bits).replace("!ESCAPED_COLON!", ":")
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en line.character el resultado de "".
		line.character = ""
		# Guarda en text el resultado de text.replace("!ESCAPED_COLON!", ":").
		text = text.replace("!ESCAPED_COLON!", ":")

	# Extract any expressions in the dialogue.
	line.text_replacements = expression_parser.extract_replacements(text, line.character.length() + 2 + tree_line.indent)
	# Recorre line.text_replacements y asigna cada elemento a replacement en cada vuelta.
	for replacement in line.text_replacements:
		# Comprueba replacement.has("error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if replacement.has("error"):
			# Guarda en result el resultado de add_error(tree_line.line_number, replacement.index, replacement.error).
			result = add_error(tree_line.line_number, replacement.index, replacement.error)

	# Replace any newlines.
	text = text.replace("\\n", "\n").strip_edges()

	# If there was no manual translation key then just use the text itself (unless this is a
	# child dialogue below another dialogue line).
	if not tree_line.is_nested_dialogue and line.translation_key == "":
		# Show an error if missing translations is enabled
		if DMSettings.get_setting(DMSettings.MISSING_TRANSLATIONS_ARE_ERRORS, false):
			# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_MISSING_ID).
			result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_MISSING_ID)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en line.translation_key el resultado de text.
			line.translation_key = text

	# Guarda en line.text el resultado de text.
	line.text = text

	# IDs can't be duplicated for text that doesn't match.
	if line.translation_key != "":
		# Comprueba _known_translation_keys.has(line.translation_key) and _known_translation_keys.get(line.translation_key) != line.text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if _known_translation_keys.has(line.translation_key) and _known_translation_keys.get(line.translation_key) != line.text:
			# Guarda en result el resultado de add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_DUPLICATE_ID).
			result = add_error(tree_line.line_number, tree_line.indent, DMConstants.ERR_DUPLICATE_ID)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Ejecuta esta instruccion: _known_translation_keys[line.translation_key] = line.text.
			_known_translation_keys[line.translation_key] = line.text

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


#endregion

#region Errors


## Add a compilation error to the list. Returns the given error code.
func add_error(line_number: int, column_number: int, error: int) -> Error:
	# See if the error was in an imported file
	for item in _imported_line_map.values():
		# Comprueba line_number < item.to_line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if line_number < item.to_line:
			# Llama al metodo errors.append para realizar esta accion en este punto.
			errors.append({
				# Guarda en line_number el resultado de item.imported_on_line_number,.
				line_number = item.imported_on_line_number,
				# Guarda en column_number el resultado de 0,.
				column_number = 0,
				# Guarda en error el resultado de DMConstants.ERR_ERRORS_IN_IMPORTED_FILE,.
				error = DMConstants.ERR_ERRORS_IN_IMPORTED_FILE,
				# Guarda en external_error el resultado de error,.
				external_error = error,
				# Guarda en external_line_number el resultado de line_number.
				external_line_number = line_number
			# Ejecuta esta instruccion: }).
			})
			# Termina el metodo y devuelve error a quien lo llamo.
			return error

	# Otherwise, it's in this file
	errors.append({
		# Guarda en line_number el resultado de line_number - _imported_line_count,.
		line_number = line_number - _imported_line_count,
		# Guarda en column_number el resultado de column_number,.
		column_number = column_number,
		# Guarda en error el resultado de error.
		error = error
	# Ejecuta esta instruccion: }).
	})

	# Termina el metodo y devuelve error a quien lo llamo.
	return error


#endregion

#region Helpers


## Get the names of any autoloads in the project.
func get_autoload_names() -> PackedStringArray:
	# Crea autoloads e inicializa su valor con [].
	var autoloads: PackedStringArray = []

	# Crea project e inicializa su valor con ConfigFile.new().
	var project = ConfigFile.new()
	# Llama al metodo project.load para realizar esta accion en este punto.
	project.load("res://project.godot")
	# Comprueba project.has_section("autoload"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if project.has_section("autoload"):
		# Termina el metodo y devuelve Array(project.get_section_keys("autoload")).filter(func(key): return key != "DialogueManager") a quien lo llamo.
		return Array(project.get_section_keys("autoload")).filter(func(key): return key != "DialogueManager")

	# Termina el metodo y devuelve autoloads a quien lo llamo.
	return autoloads


## Check if a line is importing another file.
func is_import_line(text: String) -> bool:
	# Termina el metodo y devuelve text.begins_with("import ") and " as " in text a quien lo llamo.
	return text.begins_with("import ") and " as " in text


## Extract the import information from an import line
func extract_import_path_and_name(line: String) -> Dictionary:
	# Crea found e inicializa su valor con regex.IMPORT_REGEX.search(line).
	var found: RegExMatch = regex.IMPORT_REGEX.search(line)
	# Comprueba found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if found:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en path el resultado de found.strings[found.names.path],.
			path = found.strings[found.names.path],
			# Guarda en prefix el resultado de found.strings[found.names.prefix].
			prefix = found.strings[found.names.prefix]
		}
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve {} a quien lo llamo.
		return {}


## Get the indent of a raw line
func get_indent(raw_line: String) -> int:
	# Crea tabs e inicializa su valor con regex.INDENT_REGEX.search(raw_line).
	var tabs: RegExMatch = regex.INDENT_REGEX.search(raw_line)
	# Comprueba tabs; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if tabs:
		# Termina el metodo y devuelve tabs.get_string().length() a quien lo llamo.
		return tabs.get_string().length()
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve 0 a quien lo llamo.
		return 0


## Get the type of a raw line
func get_line_type(raw_line: String) -> String:
	# Guarda en raw_line el resultado de raw_line.strip_edges().
	raw_line = raw_line.strip_edges()
	# Crea text e inicializa su valor con regex.WEIGHTED_RANDOM_SIBLINGS_REGEX.sub(raw_line + " ", "").strip_edges().
	var text: String = regex.WEIGHTED_RANDOM_SIBLINGS_REGEX.sub(raw_line + " ", "").strip_edges()

	# Comprueba text.begins_with("import "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("import "):
		# Termina el metodo y devuelve DMConstants.TYPE_IMPORT a quien lo llamo.
		return DMConstants.TYPE_IMPORT

	# Comprueba text.begins_with("using "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("using "):
		# Termina el metodo y devuelve DMConstants.TYPE_USING a quien lo llamo.
		return DMConstants.TYPE_USING

	# Comprueba text.begins_with("#"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("#"):
		# Termina el metodo y devuelve DMConstants.TYPE_COMMENT a quien lo llamo.
		return DMConstants.TYPE_COMMENT

	# Comprueba text.begins_with("~ "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("~ "):
		# Termina el metodo y devuelve DMConstants.TYPE_TITLE a quien lo llamo.
		return DMConstants.TYPE_TITLE

	# Comprueba text.begins_with("if ") or text.begins_with("elif") or text.begins_with("else"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("if ") or text.begins_with("elif") or text.begins_with("else"):
		# Termina el metodo y devuelve DMConstants.TYPE_CONDITION a quien lo llamo.
		return DMConstants.TYPE_CONDITION

	# Comprueba text.begins_with("while "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("while "):
		# Termina el metodo y devuelve DMConstants.TYPE_WHILE a quien lo llamo.
		return DMConstants.TYPE_WHILE

	# Comprueba text.begins_with("match "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("match "):
		# Termina el metodo y devuelve DMConstants.TYPE_MATCH a quien lo llamo.
		return DMConstants.TYPE_MATCH

	# Comprueba text.begins_with("when "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("when "):
		# Termina el metodo y devuelve DMConstants.TYPE_WHEN a quien lo llamo.
		return DMConstants.TYPE_WHEN

	# Comprueba text.begins_with("do ") or text.begins_with("do! ") or text.begins_with("set "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("do ") or text.begins_with("do! ") or text.begins_with("set "):
		# Termina el metodo y devuelve DMConstants.TYPE_MUTATION a quien lo llamo.
		return DMConstants.TYPE_MUTATION

	# Comprueba text.begins_with("=> ") or text.begins_with("=>< "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("=> ") or text.begins_with("=>< "):
		# Termina el metodo y devuelve DMConstants.TYPE_GOTO a quien lo llamo.
		return DMConstants.TYPE_GOTO

	# Comprueba text.begins_with("- "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text.begins_with("- "):
		# Termina el metodo y devuelve DMConstants.TYPE_RESPONSE a quien lo llamo.
		return DMConstants.TYPE_RESPONSE

	# Comprueba raw_line.begins_with("%") and text.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if raw_line.begins_with("%") and text.is_empty():
		# Termina el metodo y devuelve DMConstants.TYPE_RANDOM a quien lo llamo.
		return DMConstants.TYPE_RANDOM

	# Comprueba not text.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not text.is_empty():
		# Termina el metodo y devuelve DMConstants.TYPE_DIALOGUE a quien lo llamo.
		return DMConstants.TYPE_DIALOGUE

	# Termina el metodo y devuelve DMConstants.TYPE_UNKNOWN a quien lo llamo.
	return DMConstants.TYPE_UNKNOWN


## Get the next sibling that passes a [Callable] matcher.
func get_next_matching_sibling_id(siblings: Array[DMTreeLine], from_index: int, parent: DMCompiledLine, matcher: Callable, with_empty_lines: bool = false) -> String:
	# Recorre range(from_index + 1, siblings.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(from_index + 1, siblings.size()):
		# Crea next_sibling e inicializa su valor con siblings[i].
		var next_sibling: DMTreeLine = siblings[i]

		# Comprueba not with_empty_lines; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not with_empty_lines:
			# Ignore empty lines
			if not next_sibling or next_sibling.type == DMConstants.TYPE_UNKNOWN:
				# Pasa directamente a la siguiente vuelta del bucle.
				continue

		# Comprueba matcher.call(next_sibling); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if matcher.call(next_sibling):
			# Termina el metodo y devuelve next_sibling.id a quien lo llamo.
			return next_sibling.id

	# If no next ID can be found then check the parent for where to go next.
	if parent != null:
		# Termina el metodo y devuelve parent.id if parent.type == DMConstants.TYPE_WHILE else parent.next_id_after a quien lo llamo.
		return parent.id if parent.type == DMConstants.TYPE_WHILE else parent.next_id_after

	# Termina el metodo y devuelve DMConstants.ID_NULL a quien lo llamo.
	return DMConstants.ID_NULL


## Extract a static line ID from some text.
func extract_static_line_id(text: String) -> String:
		# Find a static translation key, eg. [ID:something]
	var found: RegExMatch = regex.STATIC_LINE_ID_REGEX.search(text)
	# Comprueba found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if found:
		# Termina el metodo y devuelve found.strings[found.names.id] a quien lo llamo.
		return found.strings[found.names.id]
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve "" a quien lo llamo.
		return ""


## Extract a condition (or inline condition) from some text.
func extract_condition(text: String, is_wrapped: bool, index: int) -> Dictionary:
	# Crea regex e inicializa su valor con regex.WRAPPED_CONDITION_REGEX if is_wrapped else regex.CONDITION_REGEX.
	var regex: RegEx = regex.WRAPPED_CONDITION_REGEX if is_wrapped else regex.CONDITION_REGEX
	# Crea found e inicializa su valor con regex.search(text).
	var found: RegExMatch = regex.search(text)

	# Comprueba found == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if found == null:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en index el resultado de 0,.
			index = 0,
			# Guarda en error el resultado de DMConstants.ERR_INCOMPLETE_EXPRESSION.
			error = DMConstants.ERR_INCOMPLETE_EXPRESSION
		}

	# Crea raw_condition e inicializa su valor con found.strings[found.names.expression].
	var raw_condition: String = found.strings[found.names.expression]
	# Comprueba raw_condition.ends_with(":"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if raw_condition.ends_with(":"):
		# Guarda en raw_condition el resultado de raw_condition.substr(0, raw_condition.length() - 1).
		raw_condition = raw_condition.substr(0, raw_condition.length() - 1)

	# Crea expression e inicializa su valor con expression_parser.tokenise(raw_condition, DMConstants.TYPE_CONDITION, index + found.get_start("expression")).
	var expression: Array = expression_parser.tokenise(raw_condition, DMConstants.TYPE_CONDITION, index + found.get_start("expression"))

	# Comprueba expression.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if expression.size() == 0:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en index el resultado de index + found.get_start("expression"),.
			index = index + found.get_start("expression"),
			# Guarda en error el resultado de DMConstants.ERR_INCOMPLETE_EXPRESSION.
			error = DMConstants.ERR_INCOMPLETE_EXPRESSION
		}
	# Comprueba expression[0].type == DMConstants.TYPE_ERROR si las condiciones anteriores resultaron falsas.
	elif expression[0].type == DMConstants.TYPE_ERROR:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en index el resultado de expression[0].i,.
			index = expression[0].i,
			# Guarda en error el resultado de expression[0].value.
			error = expression[0].value
		}
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en expression el resultado de expression.
			expression = expression
		}


## Extract a mutation from some text.
func extract_mutation(text: String) -> Dictionary:
	# Crea found e inicializa su valor con regex.MUTATION_REGEX.search(text).
	var found: RegExMatch = regex.MUTATION_REGEX.search(text)

	# Comprueba not found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not found:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en index el resultado de 0,.
			index = 0,
			# Guarda en error el resultado de DMConstants.ERR_INCOMPLETE_EXPRESSION.
			error = DMConstants.ERR_INCOMPLETE_EXPRESSION
		}

	# Comprueba found.names.has("expression"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if found.names.has("expression"):
		# Crea expression e inicializa su valor con expression_parser.tokenise(found.strings[found.names.expression], DMConstants.TYPE_MUTATION, found.get_start("expression")).
		var expression: Array = expression_parser.tokenise(found.strings[found.names.expression], DMConstants.TYPE_MUTATION, found.get_start("expression"))
		# Comprueba expression.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if expression.size() == 0:
			# Termina el metodo y devuelve { a quien lo llamo.
			return {
				# Guarda en index el resultado de found.get_start("expression"),.
				index = found.get_start("expression"),
				# Guarda en error el resultado de DMConstants.ERR_INCOMPLETE_EXPRESSION.
				error = DMConstants.ERR_INCOMPLETE_EXPRESSION
			}
		# Comprueba expression[0].type == DMConstants.TYPE_ERROR si las condiciones anteriores resultaron falsas.
		elif expression[0].type == DMConstants.TYPE_ERROR:
			# Termina el metodo y devuelve { a quien lo llamo.
			return {
				# Guarda en index el resultado de expression[0].i,.
				index = expression[0].i,
				# Guarda en error el resultado de expression[0].value.
				error = expression[0].value
			}
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina el metodo y devuelve { a quien lo llamo.
			return {
				# Guarda en expression el resultado de expression,.
				expression = expression,
				# Guarda en is_blocking el resultado de not "!" in found.strings[found.names.keyword].
				is_blocking = not "!" in found.strings[found.names.keyword]
			}

	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve { a quien lo llamo.
		return {
			# Guarda en index el resultado de found.get_start(),.
			index = found.get_start(),
			# Guarda en error el resultado de DMConstants.ERR_INCOMPLETE_EXPRESSION.
			error = DMConstants.ERR_INCOMPLETE_EXPRESSION
		}


## Keep track of lines referencing titles because their own next_id might not have been resolved yet.
func add_reference_to_title(title: String, line: DMCompiledLine) -> void:
	# Ejecuta esta instruccion: if title in [DMConstants.ID_END, DMConstants.ID_END_CONVERSATION, DMConstants.ID_NULL]: return.
	if title in [DMConstants.ID_END, DMConstants.ID_END_CONVERSATION, DMConstants.ID_NULL]: return

	# Comprueba not _goto_lines.has(title); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not _goto_lines.has(title):
		# Ejecuta esta instruccion: _goto_lines[title] = [].
		_goto_lines[title] = []
	# Ejecuta esta instruccion: _goto_lines[title].append(line).
	_goto_lines[title].append(line)


## Parse a nested block of child lines
func parse_children(tree_line: DMTreeLine, line: DMCompiledLine) -> Array[DMCompiledLine]:
	# Crea children e inicializa su valor con parse_line_tree(tree_line, line).
	var children = parse_line_tree(tree_line, line)
	# Comprueba children.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if children.size() > 0:
		# Guarda en line.next_id el resultado de children.front().id.
		line.next_id = children.front().id
		# The last child should jump to the next line after its parent condition group
		var last_child: DMCompiledLine = children.back()
		# Comprueba last_child.next_id == DMConstants.ID_NULL; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if last_child.next_id == DMConstants.ID_NULL:
			# Guarda en last_child.next_id el resultado de line.next_id_after.
			last_child.next_id = line.next_id_after
			# Comprueba last_child.siblings.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if last_child.siblings.size() > 0:
				# Recorre last_child.siblings y asigna cada elemento a sibling en cada vuelta.
				for sibling in last_child.siblings:
					# Llama al metodo lines.get para realizar esta accion en este punto.
					lines.get(sibling.id).next_id = last_child.next_id

	# Termina el metodo y devuelve children a quien lo llamo.
	return children


#endregion
