# Ejecuta esta instruccion: @tool.
@tool
# Registra DMImportPlugin como nombre de clase global para usarlo en otros scripts.
class_name DMImportPlugin extends EditorImportPlugin


# Declara la secompiled_resource1al compiled_resource; otros nodos pueden conectarse para reaccionar cuando se emita.
signal compiled_resource(resource: Resource)


# Define COMPILER_VERSION con el valor fijo 15.
const COMPILER_VERSION = 15


# Define el metodo _get_importer_name para agrupar esta accion del script.
func _get_importer_name() -> String:
	# Termina el metodo y devuelve "dialogue_manager" a quien lo llamo.
	return "dialogue_manager"


# Define el metodo _get_format_version para agrupar esta accion del script.
func _get_format_version() -> int:
	# Termina el metodo y devuelve COMPILER_VERSION a quien lo llamo.
	return COMPILER_VERSION


# Define el metodo _get_visible_name para agrupar esta accion del script.
func _get_visible_name() -> String:
	# Termina el metodo y devuelve "Dialogue" a quien lo llamo.
	return "Dialogue"


# Define el metodo _get_import_order para agrupar esta accion del script.
func _get_import_order() -> int:
	# Termina el metodo y devuelve -1000 a quien lo llamo.
	return -1000


# Define el metodo _get_priority para agrupar esta accion del script.
func _get_priority() -> float:
	# Termina el metodo y devuelve 1000.0 a quien lo llamo.
	return 1000.0


# Define el metodo _get_resource_type para agrupar esta accion del script.
func _get_resource_type():
	# Termina el metodo y devuelve "Resource" a quien lo llamo.
	return "Resource"


# Define el metodo _get_recognized_extensions para agrupar esta accion del script.
func _get_recognized_extensions() -> PackedStringArray:
	# Termina el metodo y devuelve PackedStringArray(["dialogue"]) a quien lo llamo.
	return PackedStringArray(["dialogue"])


# Define el metodo _get_save_extension para agrupar esta accion del script.
func _get_save_extension():
	# Termina el metodo y devuelve "tres" a quien lo llamo.
	return "tres"


# Define el metodo _get_preset_count para agrupar esta accion del script.
func _get_preset_count() -> int:
	# Termina el metodo y devuelve 0 a quien lo llamo.
	return 0


# Define el metodo _get_preset_name para agrupar esta accion del script.
func _get_preset_name(preset_index: int) -> String:
	# Termina el metodo y devuelve "Unknown" a quien lo llamo.
	return "Unknown"


# Define el metodo _get_import_options para agrupar esta accion del script.
func _get_import_options(path: String, preset_index: int) -> Array:
	# When the options array is empty there is a misleading error on export
	# that actually means nothing so let's just have an invisible option.
	return [{
		# Guarda en name el resultado de "defaults",.
		name = "defaults",
		# Guarda en default_value el resultado de true.
		default_value = true
	# Ejecuta esta instruccion: }].
	}]


# Define el metodo _get_option_visibility para agrupar esta accion del script.
func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	# Termina el metodo y devuelve false a quien lo llamo.
	return false


# Define el metodo _import para agrupar esta accion del script.
func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	# Crea cache e inicializa su valor con Engine.get_meta("DMCache").
	var cache = Engine.get_meta("DMCache")

	# Get the raw file contents
	if not FileAccess.file_exists(source_file): return ERR_FILE_NOT_FOUND

	# Crea file e inicializa su valor con FileAccess.open(source_file, FileAccess.READ).
	var file: FileAccess = FileAccess.open(source_file, FileAccess.READ)
	# Crea raw_text e inicializa su valor con file.get_as_text().
	var raw_text: String = file.get_as_text()

	# Emite la senal cache.file_content_changed con estos datos: source_file, raw_text.
	cache.file_content_changed.emit(source_file, raw_text)

	# Compile the text
	var result: DMCompilerResult = DMCompiler.compile_string(raw_text, source_file)
	# Comprueba result.errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if result.errors.size() > 0:
		# Llama al metodo printerr para realizar esta accion en este punto.
		printerr("%d errors found in %s" % [result.errors.size(), source_file])
		# Llama al metodo cache.add_errors_to_file para realizar esta accion en este punto.
		cache.add_errors_to_file(source_file, result.errors)
		# Termina el metodo y devuelve OK a quien lo llamo.
		return OK

	# Get the current addon version
	var config: ConfigFile = ConfigFile.new()
	# Llama al metodo config.load para realizar esta accion en este punto.
	config.load("res://addons/dialogue_manager/plugin.cfg")
	# Crea version e inicializa su valor con config.get_value("plugin", "version").
	var version: String = config.get_value("plugin", "version")

	# Save the results to a resource
	var resource: DialogueResource = DialogueResource.new()
	# Llama al metodo resource.set_meta para realizar esta accion en este punto.
	resource.set_meta("dialogue_manager_version", version)

	# Guarda en resource.using_states el resultado de result.using_states.
	resource.using_states = result.using_states
	# Guarda en resource.titles el resultado de result.titles.
	resource.titles = result.titles
	# Guarda en resource.first_title el resultado de result.first_title.
	resource.first_title = result.first_title
	# Guarda en resource.character_names el resultado de result.character_names.
	resource.character_names = result.character_names
	# Guarda en resource.lines el resultado de result.lines.
	resource.lines = result.lines
	# Guarda en resource.raw_text el resultado de result.raw_text.
	resource.raw_text = result.raw_text

	# Clear errors and possibly trigger any cascade recompiles
	cache.add_file(source_file, result)

	# Crea err e inicializa su valor con ResourceSaver.save(resource, "%s.%s" % [save_path, _get_save_extension()]).
	var err: Error = ResourceSaver.save(resource, "%s.%s" % [save_path, _get_save_extension()])

	# Emite la senal compiled_resource con estos datos: resource.
	compiled_resource.emit(resource)

	# Recompile any dependencies
	var dependent_paths: PackedStringArray = cache.get_dependent_paths_for_reimport(source_file)
	# Recorre dependent_paths y asigna cada elemento a path en cada vuelta.
	for path in dependent_paths:
		# Llama al metodo append_import_external_resource para realizar esta accion en este punto.
		append_import_external_resource(path)

	# Termina el metodo y devuelve err a quien lo llamo.
	return err
