# Ejecuta esta instruccion: @tool.
@tool
# Hereda de EditorPlugin y reutiliza sus propiedades y comportamiento base.
extends EditorPlugin


# Define MainView con el valor fijo preload("./views/main_view.tscn").
const MainView = preload("./views/main_view.tscn")


# Declara import_plugin para guardar un dato utilizado por este script.
var import_plugin: DMImportPlugin
# Declara export_plugin para guardar un dato utilizado por este script.
var export_plugin: DMExportPlugin
# Declara inspector_plugin para guardar un dato utilizado por este script.
var inspector_plugin: DMInspectorPlugin
# Declara translation_parser_plugin para guardar un dato utilizado por este script.
var translation_parser_plugin: DMTranslationParserPlugin
# Declara main_view para guardar un dato utilizado por este script.
var main_view
# Declara dialogue_cache para guardar un dato utilizado por este script.
var dialogue_cache: DMCache


# Define el metodo _enable_plugin para agrupar esta accion del script.
func _enable_plugin() -> void:
	# Llama al metodo add_autoload_singleton para realizar esta accion en este punto.
	add_autoload_singleton("DialogueManager", get_plugin_path() + "/dialogue_manager.gd")


# Define el metodo _disable_plugin para agrupar esta accion del script.
func _disable_plugin() -> void:
	# Llama al metodo remove_autoload_singleton para realizar esta accion en este punto.
	remove_autoload_singleton("DialogueManager")


# Define el metodo _enter_tree para agrupar esta accion del script.
func _enter_tree() -> void:
	# Comprueba Engine.is_editor_hint(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Engine.is_editor_hint():
		# Llama al metodo Engine.set_meta para realizar esta accion en este punto.
		Engine.set_meta("DialogueManagerPlugin", self)

		# Llama al metodo DMSettings.prepare para realizar esta accion en este punto.
		DMSettings.prepare()

		# Guarda en dialogue_cache el resultado de DMCache.new().
		dialogue_cache = DMCache.new()
		# Llama al metodo Engine.set_meta para realizar esta accion en este punto.
		Engine.set_meta("DMCache", dialogue_cache)

		# Guarda en import_plugin el resultado de DMImportPlugin.new().
		import_plugin = DMImportPlugin.new()
		# Llama al metodo add_import_plugin para realizar esta accion en este punto.
		add_import_plugin(import_plugin)

		# Guarda en export_plugin el resultado de DMExportPlugin.new().
		export_plugin = DMExportPlugin.new()
		# Llama al metodo add_export_plugin para realizar esta accion en este punto.
		add_export_plugin(export_plugin)

		# Guarda en inspector_plugin el resultado de DMInspectorPlugin.new().
		inspector_plugin = DMInspectorPlugin.new()
		# Llama al metodo add_inspector_plugin para realizar esta accion en este punto.
		add_inspector_plugin(inspector_plugin)

		# Guarda en translation_parser_plugin el resultado de DMTranslationParserPlugin.new().
		translation_parser_plugin = DMTranslationParserPlugin.new()
		# Llama al metodo add_translation_parser_plugin para realizar esta accion en este punto.
		add_translation_parser_plugin(translation_parser_plugin)

		# Guarda en main_view el resultado de MainView.instantiate().
		main_view = MainView.instantiate()
		# Llama al metodo EditorInterface.get_editor_main_screen para realizar esta accion en este punto.
		EditorInterface.get_editor_main_screen().add_child(main_view)
		# Llama al metodo _make_visible para realizar esta accion en este punto.
		_make_visible(false)
		# Llama al metodo main_view.add_child para realizar esta accion en este punto.
		main_view.add_child(dialogue_cache)

		# Llama al metodo _update_localization para realizar esta accion en este punto.
		_update_localization()

		# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
		EditorInterface.get_file_system_dock().files_moved.connect(_on_files_moved)
		# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
		EditorInterface.get_file_system_dock().file_removed.connect(_on_file_removed)

		# Llama al metodo add_tool_menu_item para realizar esta accion en este punto.
		add_tool_menu_item("Create copy of dialogue example balloon...", _copy_dialogue_balloon)

		# Automatically swap the script on the example balloon depending on if dotnet is being used.
		if not FileAccess.file_exists("res://tests/test_basic_dialogue.gd"):
			# Crea plugin_path e inicializa su valor con get_plugin_path().
			var plugin_path: String = get_plugin_path()
			# Crea balloon_file_names e inicializa su valor con ["example_balloon.tscn", "small_example_balloon.tscn"].
			var balloon_file_names: PackedStringArray = ["example_balloon.tscn", "small_example_balloon.tscn"]
			# Ejecuta esta instruccion: for balloon_file_name: String in balloon_file_names:.
			for balloon_file_name: String in balloon_file_names:
				# Crea balloon_path e inicializa su valor con plugin_path + "/example_balloon/" + balloon_file_name.
				var balloon_path: String = plugin_path + "/example_balloon/" + balloon_file_name
				# Crea balloon_content e inicializa su valor con FileAccess.get_file_as_string(balloon_path).
				var balloon_content: String = FileAccess.get_file_as_string(balloon_path)
				# Comprueba "example_balloon.gd" in balloon_content and DMSettings.check_for_dotnet_solution(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if "example_balloon.gd" in balloon_content and DMSettings.check_for_dotnet_solution():
					balloon_content = balloon_content \
						# Replace script path with the C# one
						.replace("example_balloon.gd", "ExampleBalloon.cs") \
						# Replace script UID with the C# one
						.replace(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/example_balloon.gd")), ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/ExampleBalloon.cs")))
					# Crea balloon_file e inicializa su valor con FileAccess.open(balloon_path, FileAccess.WRITE).
					var balloon_file: FileAccess = FileAccess.open(balloon_path, FileAccess.WRITE)
					# Llama al metodo balloon_file.store_string para realizar esta accion en este punto.
					balloon_file.store_string(balloon_content)
					# Llama al metodo balloon_file.close para realizar esta accion en este punto.
					balloon_file.close()
				# Comprueba "ExampleBalloon.cs" in balloon_content and not DMSettings.check_for_dotnet_solution() si las condiciones anteriores resultaron falsas.
				elif "ExampleBalloon.cs" in balloon_content and not DMSettings.check_for_dotnet_solution():
					balloon_content = balloon_content \
						# Replace script path with the GDScript one
						.replace("ExampleBalloon.cs", "example_balloon.gd") \
						# Replace script UID with the GDScript one
						.replace(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/ExampleBalloon.cs")), ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/example_balloon.gd")))
					# Crea balloon_file e inicializa su valor con FileAccess.open(balloon_path, FileAccess.WRITE).
					var balloon_file: FileAccess = FileAccess.open(balloon_path, FileAccess.WRITE)
					# Llama al metodo balloon_file.store_string para realizar esta accion en este punto.
					balloon_file.store_string(balloon_content)
					# Llama al metodo balloon_file.close para realizar esta accion en este punto.
					balloon_file.close()

		# Automatically make any changes to the known custom balloon if there is one.
		var balloon_path: String = DMSettings.get_setting(DMSettings.BALLOON_PATH, "")
		# Comprueba balloon_path != "" and FileAccess.file_exists(balloon_path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if balloon_path != "" and FileAccess.file_exists(balloon_path):
			# Crea is_small_window e inicializa su valor con ProjectSettings.get_setting("display/window/size/viewport_width") < 400.
			var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
			# Crea example_balloon_file_name e inicializa su valor con "small_example_balloon.tscn" if is_small_window else "example_balloon.tscn".
			var example_balloon_file_name: String = "small_example_balloon.tscn" if is_small_window else "example_balloon.tscn"
			# Crea example_balloon_path e inicializa su valor con get_plugin_path() + "/example_balloon/" + example_balloon_file_name.
			var example_balloon_path: String = get_plugin_path() + "/example_balloon/" + example_balloon_file_name

			# Crea contents e inicializa su valor con FileAccess.get_file_as_string(balloon_path).
			var contents: String = FileAccess.get_file_as_string(balloon_path)
			# Crea has_changed e inicializa su valor con false.
			var has_changed: bool = false

			# Make sure the current balloon has a UID unique from the example balloon's
			var example_balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(example_balloon_path))
			# Crea balloon_uid e inicializa su valor con ResourceUID.id_to_text(ResourceLoader.get_resource_uid(balloon_path)).
			var balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(balloon_path))
			# Comprueba example_balloon_uid == balloon_uid; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if example_balloon_uid == balloon_uid:
				# Crea new_balloon_uid e inicializa su valor con ResourceUID.id_to_text(ResourceUID.create_id()).
				var new_balloon_uid: String = ResourceUID.id_to_text(ResourceUID.create_id())
				# Guarda en contents el resultado de contents.replace(example_balloon_uid, new_balloon_uid).
				contents = contents.replace(example_balloon_uid, new_balloon_uid)
				# Guarda en has_changed el resultado de true.
				has_changed = true

			# Make sure the example balloon copy has the correct renaming of the responses menu
			if "reponses" in contents:
				# Guarda en contents el resultado de contents.replace("reponses", "responses").
				contents = contents.replace("reponses", "responses")
				# Guarda en has_changed el resultado de true.
				has_changed = true

			# Save any changes
			if has_changed:
				# Crea balloon_file e inicializa su valor con FileAccess.open(balloon_path, FileAccess.WRITE).
				var balloon_file: FileAccess = FileAccess.open(balloon_path, FileAccess.WRITE)
				# Llama al metodo balloon_file.store_string para realizar esta accion en este punto.
				balloon_file.store_string(contents)
				# Llama al metodo balloon_file.close para realizar esta accion en este punto.
				balloon_file.close()


# Define el metodo _exit_tree para agrupar esta accion del script.
func _exit_tree() -> void:
	# Llama al metodo remove_import_plugin para realizar esta accion en este punto.
	remove_import_plugin(import_plugin)
	# Guarda en import_plugin el resultado de null.
	import_plugin = null

	# Llama al metodo remove_export_plugin para realizar esta accion en este punto.
	remove_export_plugin(export_plugin)
	# Guarda en export_plugin el resultado de null.
	export_plugin = null

	# Llama al metodo remove_inspector_plugin para realizar esta accion en este punto.
	remove_inspector_plugin(inspector_plugin)
	# Guarda en inspector_plugin el resultado de null.
	inspector_plugin = null

	# Llama al metodo remove_translation_parser_plugin para realizar esta accion en este punto.
	remove_translation_parser_plugin(translation_parser_plugin)
	# Guarda en translation_parser_plugin el resultado de null.
	translation_parser_plugin = null

	# Comprueba is_instance_valid(main_view); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(main_view):
		# Llama al metodo main_view.queue_free para realizar esta accion en este punto.
		main_view.queue_free()

	# Llama al metodo Engine.remove_meta para realizar esta accion en este punto.
	Engine.remove_meta("DialogueManagerPlugin")
	# Llama al metodo Engine.remove_meta para realizar esta accion en este punto.
	Engine.remove_meta("DMCache")

	# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
	EditorInterface.get_file_system_dock().files_moved.disconnect(_on_files_moved)
	# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
	EditorInterface.get_file_system_dock().file_removed.disconnect(_on_file_removed)

	# Llama al metodo remove_tool_menu_item para realizar esta accion en este punto.
	remove_tool_menu_item("Create copy of dialogue example balloon...")


# Define el metodo _has_main_screen para agrupar esta accion del script.
func _has_main_screen() -> bool:
	# Termina el metodo y devuelve true a quien lo llamo.
	return true


# Define el metodo _make_visible para agrupar esta accion del script.
func _make_visible(next_visible: bool) -> void:
	# Comprueba is_instance_valid(main_view); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(main_view):
		# Guarda en main_view.visible el resultado de next_visible.
		main_view.visible = next_visible


# Define el metodo _get_plugin_name para agrupar esta accion del script.
func _get_plugin_name() -> String:
	# Termina el metodo y devuelve "Dialogue" a quien lo llamo.
	return "Dialogue"


# Define el metodo _get_plugin_icon para agrupar esta accion del script.
func _get_plugin_icon() -> Texture2D:
	# Termina el metodo y devuelve load(get_plugin_path() + "/assets/icon.svg") a quien lo llamo.
	return load(get_plugin_path() + "/assets/icon.svg")


# Define el metodo _handles para agrupar esta accion del script.
func _handles(object) -> bool:
	# Crea editor_settings e inicializa su valor con EditorInterface.get_editor_settings().
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	# Crea external_editor e inicializa su valor con editor_settings.get_setting("text_editor/external/exec_path").
	var external_editor: String = editor_settings.get_setting("text_editor/external/exec_path")
	# Crea use_external_editor e inicializa su valor con editor_settings.get_setting("text_editor/external/use_external_editor") and external_editor != "".
	var use_external_editor: bool = editor_settings.get_setting("text_editor/external/use_external_editor") and external_editor != ""
	# Comprueba object is DialogueResource and use_external_editor and DMSettings.get_user_value("open_in_external_editor", false); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if object is DialogueResource and use_external_editor and DMSettings.get_user_value("open_in_external_editor", false):
		# Crea project_path e inicializa su valor con ProjectSettings.globalize_path("res://").
		var project_path: String = ProjectSettings.globalize_path("res://")
		# Crea file_path e inicializa su valor con ProjectSettings.globalize_path(object.resource_path).
		var file_path: String = ProjectSettings.globalize_path(object.resource_path)
		# Llama al metodo OS.create_process para realizar esta accion en este punto.
		OS.create_process(external_editor, [project_path, file_path])
		# Termina el metodo y devuelve false a quien lo llamo.
		return false

	# Termina el metodo y devuelve object is DialogueResource a quien lo llamo.
	return object is DialogueResource


# Define el metodo _edit para agrupar esta accion del script.
func _edit(object) -> void:
	# Comprueba is_instance_valid(main_view) and is_instance_valid(object); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(main_view) and is_instance_valid(object):
		# Llama al metodo main_view.open_resource para realizar esta accion en este punto.
		main_view.open_resource(object)


# Define el metodo _apply_changes para agrupar esta accion del script.
func _apply_changes() -> void:
	# Comprueba is_instance_valid(main_view); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(main_view):
		# Llama al metodo main_view.apply_changes para realizar esta accion en este punto.
		main_view.apply_changes()
		# Llama al metodo _update_localization para realizar esta accion en este punto.
		_update_localization()


# Define el metodo _save_external_data para agrupar esta accion del script.
func _save_external_data() -> void:
	# Comprueba dialogue_cache != null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if dialogue_cache != null:
		# Llama al metodo dialogue_cache.reimport_files para realizar esta accion en este punto.
		dialogue_cache.reimport_files()


# Define el metodo _build para agrupar esta accion del script.
func _build() -> bool:
	# If this is the dotnet Godot then we need to check if the solution file exists
	DMSettings.check_for_dotnet_solution()

	# Ignore errors in other files if we are just running the test scene
	if DMSettings.get_user_value("is_running_test_scene", true): return true

	# Comprueba dialogue_cache != null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if dialogue_cache != null:
		# Llama al metodo dialogue_cache.reimport_files para realizar esta accion en este punto.
		dialogue_cache.reimport_files()

		# Crea files_with_errors e inicializa su valor con dialogue_cache.get_files_with_errors().
		var files_with_errors = dialogue_cache.get_files_with_errors()
		# Comprueba files_with_errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if files_with_errors.size() > 0:
			# Recorre files_with_errors y asigna cada elemento a dialogue_file en cada vuelta.
			for dialogue_file in files_with_errors:
				# Llama al metodo push_error para realizar esta accion en este punto.
				push_error("You have %d error(s) in %s" % [dialogue_file.errors.size(), dialogue_file.path])
			# Llama al metodo EditorInterface.edit_resource para realizar esta accion en este punto.
			EditorInterface.edit_resource(load(files_with_errors[0].path))
			# Llama al metodo main_view.show_build_error_dialog para realizar esta accion en este punto.
			main_view.show_build_error_dialog()
			# Termina el metodo y devuelve false a quien lo llamo.
			return false

	# Termina el metodo y devuelve true a quien lo llamo.
	return true


## Get the shortcuts used by the plugin
func get_editor_shortcuts() -> Dictionary:
	# Crea shortcuts e inicializa su valor con {.
	var shortcuts: Dictionary = {
		# Guarda en toggle_comment el resultado de [.
		toggle_comment = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+K"),
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+Slash")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en delete_line el resultado de [.
		delete_line = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+Shift+K")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en move_up el resultado de [.
		move_up = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Alt+Up")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en move_down el resultado de [.
		move_down = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Alt+Down")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en save el resultado de [.
		save = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+Alt+S")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en close_file el resultado de [.
		close_file = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+W")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en find_in_files el resultado de [.
		find_in_files = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+Shift+F")
		# Ejecuta esta instruccion: ],.
		],

		# Guarda en run_test_scene el resultado de [.
		run_test_scene = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+F5")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en text_size_increase el resultado de [.
		text_size_increase = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+Equal")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en text_size_decrease el resultado de [.
		text_size_decrease = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+Minus")
		# Ejecuta esta instruccion: ],.
		],
		# Guarda en text_size_reset el resultado de [.
		text_size_reset = [
			# Llama al metodo _create_event para realizar esta accion en este punto.
			_create_event("Ctrl+0")
		]
	}

	# Crea paths e inicializa su valor con EditorInterface.get_editor_paths().
	var paths = EditorInterface.get_editor_paths()
	# Declara settings para guardar un dato utilizado por este script.
	var settings
	# Comprueba FileAccess.file_exists(paths.get_config_dir() + "/editor_settings-4.3.tres"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if FileAccess.file_exists(paths.get_config_dir() + "/editor_settings-4.3.tres"):
		# Guarda en settings el resultado de load(paths.get_config_dir() + "/editor_settings-4.3.tres").
		settings = load(paths.get_config_dir() + "/editor_settings-4.3.tres")
	# Comprueba FileAccess.file_exists(paths.get_config_dir() + "/editor_settings-4.tres") si las condiciones anteriores resultaron falsas.
	elif FileAccess.file_exists(paths.get_config_dir() + "/editor_settings-4.tres"):
		# Guarda en settings el resultado de load(paths.get_config_dir() + "/editor_settings-4.tres").
		settings = load(paths.get_config_dir() + "/editor_settings-4.tres")
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve shortcuts a quien lo llamo.
		return shortcuts

	# Recorre settings.get("shortcuts") y asigna cada elemento a s en cada vuelta.
	for s in settings.get("shortcuts"):
		# Recorre shortcuts y asigna cada elemento a key en cada vuelta.
		for key in shortcuts:
			# Comprueba s.name == "script_text_editor/%s" % key or s.name == "script_editor/%s" % key; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if s.name == "script_text_editor/%s" % key or s.name == "script_editor/%s" % key:
				# Ejecuta esta instruccion: shortcuts[key] = [].
				shortcuts[key] = []
				# Recorre s.shortcuts y asigna cada elemento a event en cada vuelta.
				for event in s.shortcuts:
					# Comprueba event is InputEventKey; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if event is InputEventKey:
						# Ejecuta esta instruccion: shortcuts[key].append(event).
						shortcuts[key].append(event)

	# Termina el metodo y devuelve shortcuts a quien lo llamo.
	return shortcuts


# Define el metodo _create_event para agrupar esta accion del script.
func _create_event(string: String) -> InputEventKey:
	# Crea event e inicializa su valor con InputEventKey.new().
	var event: InputEventKey = InputEventKey.new()
	# Crea bits e inicializa su valor con string.split("+").
	var bits = string.split("+")
	# Guarda en event.keycode el resultado de OS.find_keycode_from_string(bits[bits.size() - 1]).
	event.keycode = OS.find_keycode_from_string(bits[bits.size() - 1])
	# Guarda en event.shift_pressed el resultado de bits.has("Shift").
	event.shift_pressed = bits.has("Shift")
	# Guarda en event.alt_pressed el resultado de bits.has("Alt").
	event.alt_pressed = bits.has("Alt")
	# Comprueba bits.has("Ctrl") or bits.has("Command"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if bits.has("Ctrl") or bits.has("Command"):
		# Guarda en event.command_or_control_autoremap el resultado de true.
		event.command_or_control_autoremap = true
	# Termina el metodo y devuelve event a quien lo llamo.
	return event


## Get the editor shortcut that matches an event
func get_editor_shortcut(event: InputEventKey) -> String:
	# Crea shortcuts e inicializa su valor con get_editor_shortcuts().
	var shortcuts: Dictionary = get_editor_shortcuts()
	# Recorre shortcuts y asigna cada elemento a key en cada vuelta.
	for key in shortcuts:
		# Recorre shortcuts.get(key, []) y asigna cada elemento a shortcut en cada vuelta.
		for shortcut in shortcuts.get(key, []):
			# Comprueba event.as_text().split(" ")[0] == shortcut.as_text().split(" ")[0]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if event.as_text().split(" ")[0] == shortcut.as_text().split(" ")[0]:
				# Termina el metodo y devuelve key a quien lo llamo.
				return key
	# Termina el metodo y devuelve "" a quien lo llamo.
	return ""


## Get the current version
func get_version() -> String:
	# Crea config e inicializa su valor con ConfigFile.new().
	var config: ConfigFile = ConfigFile.new()
	# Llama al metodo config.load para realizar esta accion en este punto.
	config.load(get_plugin_path() + "/plugin.cfg")
	# Termina el metodo y devuelve config.get_value("plugin", "version") a quien lo llamo.
	return config.get_value("plugin", "version")


## Get the current path of the plugin
func get_plugin_path() -> String:
	# Termina el metodo y devuelve get_script().resource_path.get_base_dir() a quien lo llamo.
	return get_script().resource_path.get_base_dir()


## Update references to a moved file
func update_import_paths(from_path: String, to_path: String) -> void:
	# Llama al metodo dialogue_cache.move_file_path para realizar esta accion en este punto.
	dialogue_cache.move_file_path(from_path, to_path)

	# Reopen the file if it's already open
	if main_view.current_file_path == from_path:
		# Comprueba to_path == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if to_path == "":
			# Llama al metodo main_view.close_file para realizar esta accion en este punto.
			main_view.close_file(from_path)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en main_view.current_file_path el resultado de "".
			main_view.current_file_path = ""
			# Llama al metodo main_view.open_file para realizar esta accion en este punto.
			main_view.open_file(to_path)

	# Update any other files that import the moved file
	var dependents = dialogue_cache.get_files_with_dependency(from_path)
	# Recorre dependents y asigna cada elemento a dependent en cada vuelta.
	for dependent in dependents:
		# Llama al metodo dependent.dependencies.remove_at para realizar esta accion en este punto.
		dependent.dependencies.remove_at(dependent.dependencies.find(from_path))
		# Llama al metodo dependent.dependencies.append para realizar esta accion en este punto.
		dependent.dependencies.append(to_path)

		# Update the live buffer
		if main_view.current_file_path == dependent.path:
			# Guarda en main_view.code_edit.text el resultado de main_view.code_edit.text.replace(from_path, to_path).
			main_view.code_edit.text = main_view.code_edit.text.replace(from_path, to_path)
			# Ejecuta esta instruccion: main_view.open_buffers[main_view.current_file_path].pristine_text = main_view.code_edit.text.
			main_view.open_buffers[main_view.current_file_path].pristine_text = main_view.code_edit.text

		# Open the file and update the path
		var file: FileAccess = FileAccess.open(dependent.path, FileAccess.READ)
		# Crea text e inicializa su valor con file.get_as_text().replace(from_path, to_path).
		var text = file.get_as_text().replace(from_path, to_path)
		# Llama al metodo file.close para realizar esta accion en este punto.
		file.close()

		# Guarda en file el resultado de FileAccess.open(dependent.path, FileAccess.WRITE).
		file = FileAccess.open(dependent.path, FileAccess.WRITE)
		# Llama al metodo file.store_string para realizar esta accion en este punto.
		file.store_string(text)
		# Llama al metodo file.close para realizar esta accion en este punto.
		file.close()


# Define el metodo _update_localization para agrupar esta accion del script.
func _update_localization() -> void:
	# Crea dialogue_files e inicializa su valor con dialogue_cache.get_files().
	var dialogue_files = dialogue_cache.get_files()

	# Add any new files to POT generation
	var files_for_pot: PackedStringArray = ProjectSettings.get_setting("internationalization/locale/translations_pot_files", [])
	# Crea files_for_pot_changed e inicializa su valor con false.
	var files_for_pot_changed: bool = false
	# Recorre dialogue_files y asigna cada elemento a path en cada vuelta.
	for path in dialogue_files:
		# Comprueba not files_for_pot.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not files_for_pot.has(path):
			# Llama al metodo files_for_pot.append para realizar esta accion en este punto.
			files_for_pot.append(path)
			# Guarda en files_for_pot_changed el resultado de true.
			files_for_pot_changed = true

	# Remove any POT references that don't exist any more
	for i in range(files_for_pot.size() - 1, -1, -1):
		# Crea file_for_pot e inicializa su valor con files_for_pot[i].
		var file_for_pot: String = files_for_pot[i]
		# Comprueba file_for_pot.get_extension() == "dialogue" and not dialogue_files.has(file_for_pot); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if file_for_pot.get_extension() == "dialogue" and not dialogue_files.has(file_for_pot):
			# Llama al metodo files_for_pot.remove_at para realizar esta accion en este punto.
			files_for_pot.remove_at(i)
			# Guarda en files_for_pot_changed el resultado de true.
			files_for_pot_changed = true

	# Update project settings if POT changed
	if files_for_pot_changed:
		# Llama al metodo ProjectSettings.set_setting para realizar esta accion en este punto.
		ProjectSettings.set_setting("internationalization/locale/translations_pot_files", files_for_pot)
		# Llama al metodo ProjectSettings.save para realizar esta accion en este punto.
		ProjectSettings.save()


### Callbacks


# Define el metodo _copy_dialogue_balloon para agrupar esta accion del script.
func _copy_dialogue_balloon() -> void:
	# Crea scale e inicializa su valor con EditorInterface.get_editor_scale().
	var scale: float = EditorInterface.get_editor_scale()
	# Crea directory_dialog e inicializa su valor con FileDialog.new().
	var directory_dialog: FileDialog = FileDialog.new()
	# Crea label e inicializa su valor con Label.new().
	var label: Label = Label.new()
	# Guarda en label.text el resultado de "Dialogue balloon files will be copied into chosen directory.".
	label.text = "Dialogue balloon files will be copied into chosen directory."
	# Llama al metodo directory_dialog.get_vbox para realizar esta accion en este punto.
	directory_dialog.get_vbox().add_child(label)
	# Guarda en directory_dialog.file_mode el resultado de FileDialog.FILE_MODE_OPEN_DIR.
	directory_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	# Guarda en directory_dialog.min_size el resultado de Vector2(600, 500) * scale.
	directory_dialog.min_size = Vector2(600, 500) * scale
	# Llama al metodo directory_dialog.dir_selected.connect para realizar esta accion en este punto.
	directory_dialog.dir_selected.connect(func(path):
		# Crea plugin_path e inicializa su valor con get_plugin_path().
		var plugin_path: String = get_plugin_path()
		# Crea is_dotnet e inicializa su valor con DMSettings.check_for_dotnet_solution().
		var is_dotnet: bool = DMSettings.check_for_dotnet_solution()

		# Crea balloon_path e inicializa su valor con path + ("/Balloon.tscn" if is_dotnet else "/balloon.tscn").
		var balloon_path: String = path + ("/Balloon.tscn" if is_dotnet else "/balloon.tscn")
		# Crea balloon_script_path e inicializa su valor con path + ("/DialogueBalloon.cs" if is_dotnet else "/balloon.gd").
		var balloon_script_path: String = path + ("/DialogueBalloon.cs" if is_dotnet else "/balloon.gd")

		# Copy the balloon scene file and change the script reference
		var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
		# Crea example_balloon_file_name e inicializa su valor con "small_example_balloon.tscn" if is_small_window else "example_balloon.tscn".
		var example_balloon_file_name: String = "small_example_balloon.tscn" if is_small_window else "example_balloon.tscn"
		# Crea example_balloon_path e inicializa su valor con plugin_path + "/example_balloon/" + example_balloon_file_name.
		var example_balloon_path: String = plugin_path + "/example_balloon/" + example_balloon_file_name
		# Crea example_balloon_script_file_name e inicializa su valor con "ExampleBalloon.cs" if is_dotnet else "example_balloon.gd".
		var example_balloon_script_file_name: String = "ExampleBalloon.cs" if is_dotnet else "example_balloon.gd"
		# Crea example_balloon_script_uid e inicializa su valor con ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/example_balloon.gd")).
		var example_balloon_script_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/example_balloon.gd"))
		# Crea example_balloon_uid e inicializa su valor con ResourceUID.id_to_text(ResourceLoader.get_resource_uid(example_balloon_path)).
		var example_balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(example_balloon_path))

		# Copy the script file
		var file: FileAccess = FileAccess.open(plugin_path + "/example_balloon/" + example_balloon_script_file_name, FileAccess.READ)
		# Crea file_contents e inicializa su valor con file.get_as_text().
		var file_contents: String = file.get_as_text()
		# Comprueba is_dotnet; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if is_dotnet:
			# Guarda en file_contents el resultado de file_contents.replace("class ExampleBalloon", "class DialogueBalloon").
			file_contents = file_contents.replace("class ExampleBalloon", "class DialogueBalloon")
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en file_contents el resultado de file_contents.replace("class_name DialogueManagerExampleBalloon ", "").
			file_contents = file_contents.replace("class_name DialogueManagerExampleBalloon ", "")
		# Guarda en file el resultado de FileAccess.open(balloon_script_path, FileAccess.WRITE).
		file = FileAccess.open(balloon_script_path, FileAccess.WRITE)
		# Llama al metodo file.store_string para realizar esta accion en este punto.
		file.store_string(file_contents)
		# Llama al metodo file.close para realizar esta accion en este punto.
		file.close()
		# Crea new_balloon_script_uid_raw e inicializa su valor con ResourceUID.create_id().
		var new_balloon_script_uid_raw: int = ResourceUID.create_id()
		# Llama al metodo ResourceUID.add_id para realizar esta accion en este punto.
		ResourceUID.add_id(new_balloon_script_uid_raw, balloon_script_path)
		# Crea new_balloon_script_uid e inicializa su valor con ResourceUID.id_to_text(new_balloon_script_uid_raw).
		var new_balloon_script_uid: String = ResourceUID.id_to_text(new_balloon_script_uid_raw)

		# Save the new balloon
		file_contents = FileAccess.get_file_as_string(example_balloon_path)
		# Comprueba "example_balloon.gd" in file_contents; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if "example_balloon.gd" in file_contents:
			# Guarda en file_contents el resultado de file_contents.replace(plugin_path + "/example_balloon/example_balloon.gd", balloon_script_path).
			file_contents = file_contents.replace(plugin_path + "/example_balloon/example_balloon.gd", balloon_script_path)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en file_contents el resultado de file_contents.replace(plugin_path + "/example_balloon/ExampleBalloon.cs", balloon_script_path).
			file_contents = file_contents.replace(plugin_path + "/example_balloon/ExampleBalloon.cs", balloon_script_path)
		# Crea new_balloon_uid e inicializa su valor con ResourceUID.id_to_text(ResourceUID.create_id()).
		var new_balloon_uid: String = ResourceUID.id_to_text(ResourceUID.create_id())
		# Guarda en file_contents el resultado de file_contents.replace(example_balloon_uid, new_balloon_uid).replace(example_balloon_script_uid, new_balloon_script_uid).
		file_contents = file_contents.replace(example_balloon_uid, new_balloon_uid).replace(example_balloon_script_uid, new_balloon_script_uid)
		# Guarda en file el resultado de FileAccess.open(balloon_path, FileAccess.WRITE).
		file = FileAccess.open(balloon_path, FileAccess.WRITE)
		# Llama al metodo file.store_string para realizar esta accion en este punto.
		file.store_string(file_contents)
		# Llama al metodo file.close para realizar esta accion en este punto.
		file.close()

		# Llama al metodo EditorInterface.get_resource_filesystem para realizar esta accion en este punto.
		EditorInterface.get_resource_filesystem().scan()
		# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
		EditorInterface.get_file_system_dock().call_deferred("navigate_to_path", balloon_path)

		# Llama al metodo DMSettings.set_setting para realizar esta accion en este punto.
		DMSettings.set_setting(DMSettings.BALLOON_PATH, balloon_path)

		# Llama al metodo directory_dialog.queue_free para realizar esta accion en este punto.
		directory_dialog.queue_free()
	)
	# Llama al metodo EditorInterface.get_base_control para realizar esta accion en este punto.
	EditorInterface.get_base_control().add_child(directory_dialog)
	# Llama al metodo directory_dialog.popup_centered para realizar esta accion en este punto.
	directory_dialog.popup_centered()


### Signals


# Define el metodo _on_files_moved para agrupar esta accion del script.
func _on_files_moved(old_file: String, new_file: String) -> void:
	# Llama al metodo update_import_paths para realizar esta accion en este punto.
	update_import_paths(old_file, new_file)
	# Llama al metodo DMSettings.move_recent_file para realizar esta accion en este punto.
	DMSettings.move_recent_file(old_file, new_file)


# Define el metodo _on_file_removed para agrupar esta accion del script.
func _on_file_removed(file: String) -> void:
	# Llama al metodo update_import_paths para realizar esta accion en este punto.
	update_import_paths(file, "")
	# Comprueba is_instance_valid(main_view); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(main_view):
		# Llama al metodo main_view.close_file para realizar esta accion en este punto.
		main_view.close_file(file)
	# Llama al metodo _update_localization para realizar esta accion en este punto.
	_update_localization()
