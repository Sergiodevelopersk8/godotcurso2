## A compiler of Dialogue Manager dialogue.
class_name DMCompiler extends RefCounted


## Compile a dialogue script.
static func compile_string(text: String, path: String) -> DMCompilerResult:
	# Crea compilation e inicializa su valor con DMCompilation.new().
	var compilation: DMCompilation = DMCompilation.new()
	# Llama al metodo compilation.compile para realizar esta accion en este punto.
	compilation.compile(text, path)

	# Crea result e inicializa su valor con DMCompilerResult.new().
	var result: DMCompilerResult = DMCompilerResult.new()
	# Guarda en result.imported_paths el resultado de compilation.imported_paths.
	result.imported_paths = compilation.imported_paths
	# Guarda en result.using_states el resultado de compilation.using_states.
	result.using_states = compilation.using_states
	# Guarda en result.character_names el resultado de compilation.character_names.
	result.character_names = compilation.character_names
	# Guarda en result.titles el resultado de compilation.titles.
	result.titles = compilation.titles
	# Guarda en result.first_title el resultado de compilation.first_title.
	result.first_title = compilation.first_title
	# Guarda en result.errors el resultado de compilation.errors.
	result.errors = compilation.errors
	# Guarda en result.lines el resultado de compilation.data.
	result.lines = compilation.data
	# Guarda en result.raw_text el resultado de text.
	result.raw_text = text

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


## Get the line type of a string. The returned string will match one of the [code]TYPE_[/code] constants of [DMConstants].
static func get_line_type(text: String) -> String:
	# Crea compilation e inicializa su valor con DMCompilation.new().
	var compilation: DMCompilation = DMCompilation.new()
	# Termina el metodo y devuelve compilation.get_line_type(text) a quien lo llamo.
	return compilation.get_line_type(text)


## Get the static line ID (eg. [code][ID:SOMETHING][/code]) of some text.
static func get_static_line_id(text: String) -> String:
	# Crea compilation e inicializa su valor con DMCompilation.new().
	var compilation: DMCompilation = DMCompilation.new()
	# Termina el metodo y devuelve compilation.extract_static_line_id(text) a quien lo llamo.
	return compilation.extract_static_line_id(text)


## Get the translatable part of a line.
static func extract_translatable_string(text: String) -> String:
	# Crea compilation e inicializa su valor con DMCompilation.new().
	var compilation: DMCompilation = DMCompilation.new()

	# Crea tree_line e inicializa su valor con DMTreeLine.new("").
	var tree_line = DMTreeLine.new("")
	# Guarda en tree_line.text el resultado de text.
	tree_line.text = text
	# Crea line e inicializa su valor con DMCompiledLine.new("", compilation.get_line_type(text)).
	var line: DMCompiledLine = DMCompiledLine.new("", compilation.get_line_type(text))
	# Llama al metodo compilation.parse_character_and_dialogue para realizar esta accion en este punto.
	compilation.parse_character_and_dialogue(tree_line, line, [tree_line], 0, null)

	# Termina el metodo y devuelve line.text a quien lo llamo.
	return line.text


## Get the known titles in a dialogue script.
static func get_titles_in_text(text: String, path: String) -> Dictionary:
	# Crea compilation e inicializa su valor con DMCompilation.new().
	var compilation: DMCompilation = DMCompilation.new()
	# Llama al metodo compilation.build_line_tree para realizar esta accion en este punto.
	compilation.build_line_tree(compilation.inject_imported_files(text, path))
	# Termina el metodo y devuelve compilation.titles a quien lo llamo.
	return compilation.titles
