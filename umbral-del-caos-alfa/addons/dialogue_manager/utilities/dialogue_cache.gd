# Registra DMCache como nombre de clase global para usarlo en otros scripts.
class_name DMCache extends Node


# Declara la sefile_content_changed1al file_content_changed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal file_content_changed(path: String, new_content: String)


# Keep track of errors and dependencies
# {
# 	<dialogue file path> = {
# 		path = <dialogue file path>,
# 		dependencies = [<dialogue file path>, <dialogue file path>],
# 		errors = [<error>, <error>]
# 	}
# }
var _cache: Dictionary = {}

# Crea _update_dependency_timer e inicializa su valor con Timer.new().
var _update_dependency_timer: Timer = Timer.new()
# Crea _update_dependency_paths e inicializa su valor con [].
var _update_dependency_paths: PackedStringArray = []

# Crea _files_marked_for_reimport e inicializa su valor con [].
var _files_marked_for_reimport: PackedStringArray = []


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Llama al metodo add_child para realizar esta accion en este punto.
	add_child(_update_dependency_timer)
	# Llama al metodo _update_dependency_timer.timeout.connect para realizar esta accion en este punto.
	_update_dependency_timer.timeout.connect(_on_update_dependency_timeout)

	# Llama al metodo _build_cache para realizar esta accion en este punto.
	_build_cache()


# Define el metodo mark_files_for_reimport para agrupar esta accion del script.
func mark_files_for_reimport(files: PackedStringArray) -> void:
	# Recorre files y asigna cada elemento a file en cada vuelta.
	for file in files:
		# Comprueba not _files_marked_for_reimport.has(file); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not _files_marked_for_reimport.has(file):
			# Llama al metodo _files_marked_for_reimport.append para realizar esta accion en este punto.
			_files_marked_for_reimport.append(file)


# Define el metodo reimport_files para agrupar esta accion del script.
func reimport_files(and_files: PackedStringArray = []) -> void:
	# Recorre and_files y asigna cada elemento a file en cada vuelta.
	for file in and_files:
		# Comprueba not _files_marked_for_reimport.has(file); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not _files_marked_for_reimport.has(file):
			# Llama al metodo _files_marked_for_reimport.append para realizar esta accion en este punto.
			_files_marked_for_reimport.append(file)
	
	# Ejecuta esta instruccion: if _files_marked_for_reimport.is_empty(): return.
	if _files_marked_for_reimport.is_empty(): return

	# Llama al metodo EditorInterface.get_resource_filesystem para realizar esta accion en este punto.
	EditorInterface.get_resource_filesystem().reimport_files(_files_marked_for_reimport)


## Add a dialogue file to the cache.
func add_file(path: String, compile_result: DMCompilerResult = null) -> void:
	# Ejecuta esta instruccion: _cache[path] = {.
	_cache[path] = {
		# Guarda en path el resultado de path,.
		path = path,
		# Guarda en dependencies el resultado de [],.
		dependencies = [],
		# Guarda en errors el resultado de [].
		errors = []
	}

	# Comprueba compile_result != null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if compile_result != null:
		# Ejecuta esta instruccion: _cache[path].dependencies = Array(compile_result.imported_paths).filter(func(d): return d != path).
		_cache[path].dependencies = Array(compile_result.imported_paths).filter(func(d): return d != path)
		# Ejecuta esta instruccion: _cache[path].compiled_at = Time.get_ticks_msec().
		_cache[path].compiled_at = Time.get_ticks_msec()

	# If this is a fresh cache entry, check for dependencies
	if compile_result == null and not _update_dependency_paths.has(path):
		# Llama al metodo queue_updating_dependencies para realizar esta accion en este punto.
		queue_updating_dependencies(path)


## Get the file paths in the cache
func get_files() -> PackedStringArray:
	# Termina el metodo y devuelve _cache.keys() a quien lo llamo.
	return _cache.keys()


## Check if a file is known to the cache
func has_file(path: String) -> bool:
	# Termina el metodo y devuelve _cache.has(path) a quien lo llamo.
	return _cache.has(path)


## Remember any errors in a dialogue file
func add_errors_to_file(path: String, errors: Array[Dictionary]) -> void:
	# Comprueba _cache.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if _cache.has(path):
		# Ejecuta esta instruccion: _cache[path].errors = errors.
		_cache[path].errors = errors
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Ejecuta esta instruccion: _cache[path] = {.
		_cache[path] = {
			# Guarda en path el resultado de path,.
			path = path,
			# Guarda en resource_path el resultado de "",.
			resource_path = "",
			# Guarda en dependencies el resultado de [],.
			dependencies = [],
			# Guarda en errors el resultado de errors.
			errors = errors
		}


## Get a list of files that have errors
func get_files_with_errors() -> Array[Dictionary]:
	# Crea files_with_errors e inicializa su valor con [].
	var files_with_errors: Array[Dictionary] = []
	# Recorre _cache.values() y asigna cada elemento a dialogue_file en cada vuelta.
	for dialogue_file in _cache.values():
		# Comprueba dialogue_file and dialogue_file.errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if dialogue_file and dialogue_file.errors.size() > 0:
			# Llama al metodo files_with_errors.append para realizar esta accion en este punto.
			files_with_errors.append(dialogue_file)
	# Termina el metodo y devuelve files_with_errors a quien lo llamo.
	return files_with_errors


## Queue a file to have its dependencies checked
func queue_updating_dependencies(of_path: String) -> void:
	# Llama al metodo _update_dependency_timer.stop para realizar esta accion en este punto.
	_update_dependency_timer.stop()
	# Comprueba not _update_dependency_paths.has(of_path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not _update_dependency_paths.has(of_path):
		# Llama al metodo _update_dependency_paths.append para realizar esta accion en este punto.
		_update_dependency_paths.append(of_path)
	# Llama al metodo _update_dependency_timer.start para realizar esta accion en este punto.
	_update_dependency_timer.start(0.5)


## Update any references to a file path that has moved
func move_file_path(from_path: String, to_path: String) -> void:
	# Ejecuta esta instruccion: if not _cache.has(from_path): return.
	if not _cache.has(from_path): return

	# Comprueba to_path != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if to_path != "":
		# Ejecuta esta instruccion: _cache[to_path] = _cache[from_path].duplicate().
		_cache[to_path] = _cache[from_path].duplicate()
	# Llama al metodo _cache.erase para realizar esta accion en este punto.
	_cache.erase(from_path)


## Get every dialogue file that imports on a file of a given path
func get_files_with_dependency(imported_path: String) -> Array:
	# Termina el metodo y devuelve _cache.values().filter(func(d): return d.dependencies.has(imported_path)) a quien lo llamo.
	return _cache.values().filter(func(d): return d.dependencies.has(imported_path))


## Get any paths that are dependent on a given path
func get_dependent_paths_for_reimport(on_path: String) -> PackedStringArray:
	return get_files_with_dependency(on_path) \
		.filter(func(d): return Time.get_ticks_msec() - d.get("compiled_at", 0) > 3000) \
		.map(func(d): return d.path)


# Build the initial cache for dialogue files
func _build_cache() -> void:
	# Crea current_files e inicializa su valor con _get_dialogue_files_in_filesystem().
	var current_files: PackedStringArray = _get_dialogue_files_in_filesystem()
	# Recorre current_files y asigna cada elemento a file en cada vuelta.
	for file in current_files:
		# Llama al metodo add_file para realizar esta accion en este punto.
		add_file(file)


# Recursively find any dialogue files in a directory
func _get_dialogue_files_in_filesystem(path: String = "res://") -> PackedStringArray:
	# Crea files e inicializa su valor con [].
	var files: PackedStringArray = []

	# Comprueba DirAccess.dir_exists_absolute(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if DirAccess.dir_exists_absolute(path):
		# Crea dir e inicializa su valor con DirAccess.open(path).
		var dir = DirAccess.open(path)
		# Llama al metodo dir.list_dir_begin para realizar esta accion en este punto.
		dir.list_dir_begin()
		# Crea file_name e inicializa su valor con dir.get_next().
		var file_name = dir.get_next()
		# Repite este bloque mientras file_name != "" sea verdadero.
		while file_name != "":
			# Crea file_path e inicializa su valor con (path + "/" + file_name).simplify_path().
			var file_path: String = (path + "/" + file_name).simplify_path()
			# Comprueba dir.current_is_dir(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if dir.current_is_dir():
				# Comprueba not file_name in [".godot", ".tmp"]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if not file_name in [".godot", ".tmp"]:
					# Llama al metodo files.append_array para realizar esta accion en este punto.
					files.append_array(_get_dialogue_files_in_filesystem(file_path))
			# Comprueba file_name.get_extension() == "dialogue" si las condiciones anteriores resultaron falsas.
			elif file_name.get_extension() == "dialogue":
				# Llama al metodo files.append para realizar esta accion en este punto.
				files.append(file_path)
			# Guarda en file_name el resultado de dir.get_next().
			file_name = dir.get_next()

	# Termina el metodo y devuelve files a quien lo llamo.
	return files


#region Signals


# Define el metodo _on_update_dependency_timeout para agrupar esta accion del script.
func _on_update_dependency_timeout() -> void:
	# Llama al metodo _update_dependency_timer.stop para realizar esta accion en este punto.
	_update_dependency_timer.stop()
	# Crea import_regex e inicializa su valor con RegEx.create_from_string("import \"(?<path>.*?)\"").
	var import_regex: RegEx = RegEx.create_from_string("import \"(?<path>.*?)\"")
	# Declara file para guardar un dato utilizado por este script.
	var file: FileAccess
	# Declara found_imports para guardar un dato utilizado por este script.
	var found_imports: Array[RegExMatch]
	# Recorre _update_dependency_paths y asigna cada elemento a path en cada vuelta.
	for path in _update_dependency_paths:
		# Open the file and check for any "import" lines
		file = FileAccess.open(path, FileAccess.READ)
		# Guarda en found_imports el resultado de import_regex.search_all(file.get_as_text()).
		found_imports = import_regex.search_all(file.get_as_text())
		# Crea dependencies e inicializa su valor con [].
		var dependencies: PackedStringArray = []
		# Recorre found_imports y asigna cada elemento a found en cada vuelta.
		for found in found_imports:
			# Llama al metodo dependencies.append para realizar esta accion en este punto.
			dependencies.append(found.strings[found.names.path])
		# Ejecuta esta instruccion: _cache[path].dependencies = dependencies.
		_cache[path].dependencies = dependencies
	# Llama al metodo _update_dependency_paths.clear para realizar esta accion en este punto.
	_update_dependency_paths.clear()


#endregion
