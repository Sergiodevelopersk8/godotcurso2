# Ejecuta esta instruccion: @tool.
@tool
# Registra DMSettings como nombre de clase global para usarlo en otros scripts.
class_name DMSettings extends Node


#region Editor



## Wrap lines in the dialogue editor.
const WRAP_LONG_LINES = "editor/wrap_long_lines"
## The template to start new dialogue files with.
const NEW_FILE_TEMPLATE = "editor/new_file_template"

## Show lines without statis IDs as errors.
const MISSING_TRANSLATIONS_ARE_ERRORS = "editor/translations/missing_translations_are_errors"
## Include character names in the list of translatable strings.
const INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST = "editor/translations/include_characters_in_translatable_strings_list"
## The default locale to use when exporting CSVs
const DEFAULT_CSV_LOCALE = "editor/translations/default_csv_locale"
## Any extra CSV locales to append to the exported translation CSV
const EXTRA_CSV_LOCALES = "editor/translations/extra_csv_locales"
## Includes a "_character" column in CSV exports.
const INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS = "editor/translations/include_character_in_translation_exports"
## Includes a "_notes" column in CSV exports
const INCLUDE_NOTES_IN_TRANSLATION_EXPORTS = "editor/translations/include_notes_in_translation_exports"

## A custom test scene to use when testing dialogue.
const CUSTOM_TEST_SCENE_PATH = "editor/advanced/custom_test_scene_path"
## Extra script files to include in the auto-complete-able list
const EXTRA_AUTO_COMPLETE_SCRIPT_SOURCES = "editor/advanced/extra_auto_complete_script_sources"

## The custom balloon for this game.
const BALLOON_PATH = "runtime/balloon_path"
## The names of any autoloads to shortcut into all dialogue files (so you don't have to write `using SomeGlobal` in each file).
const STATE_AUTOLOAD_SHORTCUTS = "runtime/state_autoload_shortcuts"
## Check for possible naming conflicts in state shortcuts.
const WARN_ABOUT_METHOD_PROPERTY_OR_SIGNAL_NAME_CONFLICTS = "runtime/warn_about_method_property_or_signal_name_conflicts"

## Bypass any missing state when running dialogue.
const IGNORE_MISSING_STATE_VALUES = "runtime/advanced/ignore_missing_state_values"
## Whether or not the project is utilising dotnet.
const USES_DOTNET = "runtime/advanced/uses_dotnet"


# Ejecuta esta instruccion: static var SETTINGS_CONFIGURATION = {.
static var SETTINGS_CONFIGURATION = {
	# Asocia la clave WRAP_LONG_LINES con { dentro del diccionario.
	WRAP_LONG_LINES: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave NEW_FILE_TEMPLATE con { dentro del diccionario.
	NEW_FILE_TEMPLATE: {
		# Guarda en value el resultado de "~ start\nNathan: [[Hi|Hello|Howdy]], this is some dialogue.\nNathan: Here are some choices.\n- First one\n\tNathan: You picked the first one.\n- Second one\n\tNathan: You picked the second one.\n- Start again => start\n- End the conversation => END\nNathan: For more information see the online documentation.\n=> END",.
		value = "~ start\nNathan: [[Hi|Hello|Howdy]], this is some dialogue.\nNathan: Here are some choices.\n- First one\n\tNathan: You picked the first one.\n- Second one\n\tNathan: You picked the second one.\n- Start again => start\n- End the conversation => END\nNathan: For more information see the online documentation.\n=> END",
		# Guarda en type el resultado de TYPE_STRING,.
		type = TYPE_STRING,
		# Guarda en hint el resultado de PROPERTY_HINT_MULTILINE_TEXT,.
		hint = PROPERTY_HINT_MULTILINE_TEXT,
	# Ejecuta esta instruccion: },.
	},

	# Asocia la clave MISSING_TRANSLATIONS_ARE_ERRORS con { dentro del diccionario.
	MISSING_TRANSLATIONS_ARE_ERRORS: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST con { dentro del diccionario.
	INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST: {
		# Guarda en value el resultado de true,.
		value = true,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave DEFAULT_CSV_LOCALE con { dentro del diccionario.
	DEFAULT_CSV_LOCALE: {
		# Guarda en value el resultado de "en",.
		value = "en",
		# Guarda en type el resultado de TYPE_STRING,.
		type = TYPE_STRING,
		# Guarda en hint el resultado de PROPERTY_HINT_LOCALE_ID,.
		hint = PROPERTY_HINT_LOCALE_ID,
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave EXTRA_CSV_LOCALES con { dentro del diccionario.
	EXTRA_CSV_LOCALES: {
		# Guarda en value el resultado de [],.
		value = [],
		# Guarda en type el resultado de TYPE_PACKED_STRING_ARRAY,.
		type = TYPE_PACKED_STRING_ARRAY,
		# Guarda en hint el resultado de PROPERTY_HINT_TYPE_STRING,.
		hint = PROPERTY_HINT_TYPE_STRING,
		# Guarda en hint_string el resultado de "%d:" % [TYPE_STRING],.
		hint_string = "%d:" % [TYPE_STRING],
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS con { dentro del diccionario.
	INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave INCLUDE_NOTES_IN_TRANSLATION_EXPORTS con { dentro del diccionario.
	INCLUDE_NOTES_IN_TRANSLATION_EXPORTS: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},

	# Asocia la clave CUSTOM_TEST_SCENE_PATH con { dentro del diccionario.
	CUSTOM_TEST_SCENE_PATH: {
		# Guarda en value el resultado de preload("./test_scene.tscn").resource_path,.
		value = preload("./test_scene.tscn").resource_path,
		# Guarda en type el resultado de TYPE_STRING,.
		type = TYPE_STRING,
		# Guarda en hint el resultado de PROPERTY_HINT_FILE,.
		hint = PROPERTY_HINT_FILE,
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave EXTRA_AUTO_COMPLETE_SCRIPT_SOURCES con { dentro del diccionario.
	EXTRA_AUTO_COMPLETE_SCRIPT_SOURCES: {
		# Guarda en value el resultado de [],.
		value = [],
		# Guarda en type el resultado de TYPE_PACKED_STRING_ARRAY,.
		type = TYPE_PACKED_STRING_ARRAY,
		# Guarda en hint el resultado de PROPERTY_HINT_TYPE_STRING,.
		hint = PROPERTY_HINT_TYPE_STRING,
		# Guarda en hint_string el resultado de "%d/%d:*.*" % [TYPE_STRING, PROPERTY_HINT_FILE],.
		hint_string = "%d/%d:*.*" % [TYPE_STRING, PROPERTY_HINT_FILE],
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},

	# Asocia la clave BALLOON_PATH con { dentro del diccionario.
	BALLOON_PATH: {
		# Guarda en value el resultado de "",.
		value = "",
		# Guarda en type el resultado de TYPE_STRING,.
		type = TYPE_STRING,
		# Guarda en hint el resultado de PROPERTY_HINT_FILE,.
		hint = PROPERTY_HINT_FILE,
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave STATE_AUTOLOAD_SHORTCUTS con { dentro del diccionario.
	STATE_AUTOLOAD_SHORTCUTS: {
		# Guarda en value el resultado de [],.
		value = [],
		# Guarda en type el resultado de TYPE_PACKED_STRING_ARRAY,.
		type = TYPE_PACKED_STRING_ARRAY,
		# Guarda en hint el resultado de PROPERTY_HINT_TYPE_STRING,.
		hint = PROPERTY_HINT_TYPE_STRING,
		# Guarda en hint_string el resultado de "%d:" % [TYPE_STRING],.
		hint_string = "%d:" % [TYPE_STRING],
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave WARN_ABOUT_METHOD_PROPERTY_OR_SIGNAL_NAME_CONFLICTS con { dentro del diccionario.
	WARN_ABOUT_METHOD_PROPERTY_OR_SIGNAL_NAME_CONFLICTS: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},

	# Asocia la clave IGNORE_MISSING_STATE_VALUES con { dentro del diccionario.
	IGNORE_MISSING_STATE_VALUES: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
		# Guarda en is_advanced el resultado de true.
		is_advanced = true
	# Ejecuta esta instruccion: },.
	},
	# Asocia la clave USES_DOTNET con { dentro del diccionario.
	USES_DOTNET: {
		# Guarda en value el resultado de false,.
		value = false,
		# Guarda en type el resultado de TYPE_BOOL,.
		type = TYPE_BOOL,
		# Guarda en is_hidden el resultado de true.
		is_hidden = true
	}
}


# Ejecuta esta instruccion: static func prepare() -> void:.
static func prepare() -> void:
	# Crea should_save_settings e inicializa su valor con false.
	var should_save_settings: bool = false

	# Remap any old settings into their new keys
	var legacy_map: Dictionary = {
		# Guarda en states el resultado de STATE_AUTOLOAD_SHORTCUTS,.
		states = STATE_AUTOLOAD_SHORTCUTS,
		# Guarda en missing_translations_are_errors el resultado de MISSING_TRANSLATIONS_ARE_ERRORS,.
		missing_translations_are_errors = MISSING_TRANSLATIONS_ARE_ERRORS,
		# Guarda en export_characters_in_translation el resultado de INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST,.
		export_characters_in_translation = INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST,
		# Guarda en wrap_lines el resultado de WRAP_LONG_LINES,.
		wrap_lines = WRAP_LONG_LINES,
		# Guarda en new_with_template el resultado de null,.
		new_with_template = null,
		# Guarda en new_template el resultado de NEW_FILE_TEMPLATE,.
		new_template = NEW_FILE_TEMPLATE,
		# Guarda en include_all_responses el resultado de null,.
		include_all_responses = null,
		# Guarda en ignore_missing_state_values el resultado de IGNORE_MISSING_STATE_VALUES,.
		ignore_missing_state_values = IGNORE_MISSING_STATE_VALUES,
		# Guarda en custom_test_scene_path el resultado de CUSTOM_TEST_SCENE_PATH,.
		custom_test_scene_path = CUSTOM_TEST_SCENE_PATH,
		# Guarda en default_csv_locale el resultado de DEFAULT_CSV_LOCALE,.
		default_csv_locale = DEFAULT_CSV_LOCALE,
		# Guarda en balloon_path el resultado de BALLOON_PATH,.
		balloon_path = BALLOON_PATH,
		# Guarda en create_lines_for_responses_with_characters el resultado de null,.
		create_lines_for_responses_with_characters = null,
		# Guarda en include_character_in_translation_exports el resultado de INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS,.
		include_character_in_translation_exports = INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS,
		# Guarda en include_notes_in_translation_exports el resultado de INCLUDE_NOTES_IN_TRANSLATION_EXPORTS,.
		include_notes_in_translation_exports = INCLUDE_NOTES_IN_TRANSLATION_EXPORTS,
		# Guarda en uses_dotnet el resultado de USES_DOTNET,.
		uses_dotnet = USES_DOTNET,
		# Guarda en try_suppressing_startup_unsaved_indicator el resultado de null.
		try_suppressing_startup_unsaved_indicator = null
	}

	# Ejecuta esta instruccion: for legacy_key: String in legacy_map:.
	for legacy_key: String in legacy_map:
		# Comprueba ProjectSettings.has_setting("dialogue_manager/general/%s" % legacy_key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if ProjectSettings.has_setting("dialogue_manager/general/%s" % legacy_key):
			# Guarda en should_save_settings el resultado de true.
			should_save_settings = true
			# Remove the old setting
			var value = ProjectSettings.get_setting("dialogue_manager/general/%s" % legacy_key)
			# Llama al metodo ProjectSettings.set_setting para realizar esta accion en este punto.
			ProjectSettings.set_setting("dialogue_manager/general/%s" % legacy_key, null)
			# Comprueba legacy_map.get(legacy_key) != null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if legacy_map.get(legacy_key) != null:
				# Llama al metodo prints para realizar esta accion en este punto.
				prints("Migrating Dialogue Manager setting %s to %s with value %s" % [legacy_key, legacy_map.get(legacy_key), str(value)])
				# Llama al metodo ProjectSettings.set_setting para realizar esta accion en este punto.
				ProjectSettings.set_setting("dialogue_manager/%s" % [legacy_map.get(legacy_key)], value)

	# Set up initial settings
	for key: String in SETTINGS_CONFIGURATION:
		# Crea setting_config e inicializa su valor con SETTINGS_CONFIGURATION[key].
		var setting_config: Dictionary = SETTINGS_CONFIGURATION[key]
		# Crea setting_name e inicializa su valor con "dialogue_manager/%s" % key.
		var setting_name: String = "dialogue_manager/%s" % key
		# Comprueba not ProjectSettings.has_setting(setting_name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not ProjectSettings.has_setting(setting_name):
			# Llama al metodo ProjectSettings.set_setting para realizar esta accion en este punto.
			ProjectSettings.set_setting(setting_name, setting_config.value)
		# Llama al metodo ProjectSettings.set_initial_value para realizar esta accion en este punto.
		ProjectSettings.set_initial_value(setting_name, setting_config.value)
		# Llama al metodo ProjectSettings.add_property_info para realizar esta accion en este punto.
		ProjectSettings.add_property_info({
			# Ejecuta esta instruccion: "name" = setting_name,.
			"name" = setting_name,
			# Ejecuta esta instruccion: "type" = setting_config.type,.
			"type" = setting_config.type,
			# Ejecuta esta instruccion: "hint" = setting_config.get("hint", PROPERTY_HINT_NONE),.
			"hint" = setting_config.get("hint", PROPERTY_HINT_NONE),
			# Ejecuta esta instruccion: "hint_string" = setting_config.get("hint_string", "").
			"hint_string" = setting_config.get("hint_string", "")
		# Ejecuta esta instruccion: }).
		})
		# Llama al metodo ProjectSettings.set_as_basic para realizar esta accion en este punto.
		ProjectSettings.set_as_basic(setting_name, not setting_config.has("is_advanced"))
		# Llama al metodo ProjectSettings.set_as_internal para realizar esta accion en este punto.
		ProjectSettings.set_as_internal(setting_name, setting_config.has("is_hidden"))

	# Comprueba should_save_settings; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if should_save_settings:
		# Llama al metodo ProjectSettings.save para realizar esta accion en este punto.
		ProjectSettings.save()


# Ejecuta esta instruccion: static func set_setting(key: String, value) -> void:.
static func set_setting(key: String, value) -> void:
	# Comprueba get_setting(key, value) != value; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if get_setting(key, value) != value:
		# Llama al metodo ProjectSettings.set_setting para realizar esta accion en este punto.
		ProjectSettings.set_setting("dialogue_manager/%s" % key, value)
		# Llama al metodo ProjectSettings.set_initial_value para realizar esta accion en este punto.
		ProjectSettings.set_initial_value("dialogue_manager/%s" % key, SETTINGS_CONFIGURATION[key].value)
		# Llama al metodo ProjectSettings.save para realizar esta accion en este punto.
		ProjectSettings.save()


# Ejecuta esta instruccion: static func get_setting(key: String, default):.
static func get_setting(key: String, default):
	# Comprueba ProjectSettings.has_setting("dialogue_manager/%s" % key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if ProjectSettings.has_setting("dialogue_manager/%s" % key):
		# Termina el metodo y devuelve ProjectSettings.get_setting("dialogue_manager/%s" % key) a quien lo llamo.
		return ProjectSettings.get_setting("dialogue_manager/%s" % key)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve default a quien lo llamo.
		return default


# Ejecuta esta instruccion: static func get_settings(only_keys: PackedStringArray = []) -> Dictionary:.
static func get_settings(only_keys: PackedStringArray = []) -> Dictionary:
	# Crea settings e inicializa su valor con {}.
	var settings: Dictionary = {}
	# Recorre SETTINGS_CONFIGURATION.keys() y asigna cada elemento a key en cada vuelta.
	for key in SETTINGS_CONFIGURATION.keys():
		# Comprueba only_keys.is_empty() or key in only_keys; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if only_keys.is_empty() or key in only_keys:
			# Ejecuta esta instruccion: settings[key] = get_setting(key, SETTINGS_CONFIGURATION[key].value).
			settings[key] = get_setting(key, SETTINGS_CONFIGURATION[key].value)
	# Termina el metodo y devuelve settings a quien lo llamo.
	return settings


#endregion

#region User


# Ejecuta esta instruccion: static func get_user_config() -> Dictionary:.
static func get_user_config() -> Dictionary:
	# Crea user_config e inicializa su valor con {.
	var user_config: Dictionary = {
		# Guarda en check_for_updates el resultado de true,.
		check_for_updates = true,
		# Guarda en just_refreshed el resultado de null,.
		just_refreshed = null,
		# Guarda en recent_files el resultado de [],.
		recent_files = [],
		# Guarda en reopen_files el resultado de [],.
		reopen_files = [],
		# Guarda en most_recent_reopen_file el resultado de "",.
		most_recent_reopen_file = "",
		# Guarda en file_meta el resultado de {},.
		file_meta = {},
		# Guarda en run_title el resultado de "",.
		run_title = "",
		# Guarda en run_resource_path el resultado de "",.
		run_resource_path = "",
		# Guarda en is_running_test_scene el resultado de false,.
		is_running_test_scene = false,
		# Guarda en has_dotnet_solution el resultado de false,.
		has_dotnet_solution = false,
		# Guarda en open_in_external_editor el resultado de false.
		open_in_external_editor = false
	}

	# Comprueba FileAccess.file_exists(DMConstants.USER_CONFIG_PATH); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if FileAccess.file_exists(DMConstants.USER_CONFIG_PATH):
		# Crea file e inicializa su valor con FileAccess.open(DMConstants.USER_CONFIG_PATH, FileAccess.READ).
		var file: FileAccess = FileAccess.open(DMConstants.USER_CONFIG_PATH, FileAccess.READ)
		# Llama al metodo user_config.merge para realizar esta accion en este punto.
		user_config.merge(JSON.parse_string(file.get_as_text()), true)

	# Termina el metodo y devuelve user_config a quien lo llamo.
	return user_config


# Ejecuta esta instruccion: static func save_user_config(user_config: Dictionary) -> void:.
static func save_user_config(user_config: Dictionary) -> void:
	# Crea file e inicializa su valor con FileAccess.open(DMConstants.USER_CONFIG_PATH, FileAccess.WRITE).
	var file: FileAccess = FileAccess.open(DMConstants.USER_CONFIG_PATH, FileAccess.WRITE)
	# Llama al metodo file.store_string para realizar esta accion en este punto.
	file.store_string(JSON.stringify(user_config))


# Ejecuta esta instruccion: static func set_user_value(key: String, value) -> void:.
static func set_user_value(key: String, value) -> void:
	# Crea user_config e inicializa su valor con get_user_config().
	var user_config: Dictionary = get_user_config()
	# Ejecuta esta instruccion: user_config[key] = value.
	user_config[key] = value
	# Llama al metodo save_user_config para realizar esta accion en este punto.
	save_user_config(user_config)


# Ejecuta esta instruccion: static func get_user_value(key: String, default = null) -> Variant:.
static func get_user_value(key: String, default = null) -> Variant:
	# Termina el metodo y devuelve get_user_config().get(key, default) a quien lo llamo.
	return get_user_config().get(key, default)


# Ejecuta esta instruccion: static func forget_path(path: String) -> void:.
static func forget_path(path: String) -> void:
	# Llama al metodo remove_recent_file para realizar esta accion en este punto.
	remove_recent_file(path)
	# Crea file_meta e inicializa su valor con get_user_value("file_meta", {}).
	var file_meta: Dictionary = get_user_value("file_meta", {})
	# Llama al metodo file_meta.erase para realizar esta accion en este punto.
	file_meta.erase(path)
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("file_meta", file_meta)


# Ejecuta esta instruccion: static func add_recent_file(path: String) -> void:.
static func add_recent_file(path: String) -> void:
	# Crea recent_files e inicializa su valor con get_user_value("recent_files", []).
	var recent_files: Array = get_user_value("recent_files", [])
	# Comprueba path in recent_files; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if path in recent_files:
		# Llama al metodo recent_files.erase para realizar esta accion en este punto.
		recent_files.erase(path)
	# Llama al metodo recent_files.insert para realizar esta accion en este punto.
	recent_files.insert(0, path)
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("recent_files", recent_files)


# Ejecuta esta instruccion: static func move_recent_file(from_path: String, to_path: String) -> void:.
static func move_recent_file(from_path: String, to_path: String) -> void:
	# Crea recent_files e inicializa su valor con get_user_value("recent_files", []).
	var recent_files: Array = get_user_value("recent_files", [])
	# Recorre range(0, recent_files.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, recent_files.size()):
		# Comprueba recent_files[i] == from_path; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if recent_files[i] == from_path:
			# Ejecuta esta instruccion: recent_files[i] = to_path.
			recent_files[i] = to_path
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("recent_files", recent_files)


# Ejecuta esta instruccion: static func remove_recent_file(path: String) -> void:.
static func remove_recent_file(path: String) -> void:
	# Crea recent_files e inicializa su valor con get_user_value("recent_files", []).
	var recent_files: Array = get_user_value("recent_files", [])
	# Comprueba path in recent_files; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if path in recent_files:
		# Llama al metodo recent_files.erase para realizar esta accion en este punto.
		recent_files.erase(path)
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("recent_files", recent_files)


# Ejecuta esta instruccion: static func get_recent_files() -> Array:.
static func get_recent_files() -> Array:
	# Termina el metodo y devuelve get_user_value("recent_files", []) a quien lo llamo.
	return get_user_value("recent_files", [])


# Ejecuta esta instruccion: static func clear_recent_files() -> void:.
static func clear_recent_files() -> void:
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("recent_files", [])
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("carets", {})


# Ejecuta esta instruccion: static func set_caret(path: String, cursor: Vector2) -> void:.
static func set_caret(path: String, cursor: Vector2) -> void:
	# Crea file_meta e inicializa su valor con get_user_value("file_meta", {}).
	var file_meta: Dictionary = get_user_value("file_meta", {})
	# Ejecuta esta instruccion: file_meta[path] = file_meta.get(path, {}).merged({ cursor = "%d,%d" % [cursor.x, cursor.y] }, true).
	file_meta[path] = file_meta.get(path, {}).merged({ cursor = "%d,%d" % [cursor.x, cursor.y] }, true)
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("file_meta", file_meta)


# Ejecuta esta instruccion: static func get_caret(path: String) -> Vector2:.
static func get_caret(path: String) -> Vector2:
	# Crea file_meta e inicializa su valor con get_user_value("file_meta", {}).
	var file_meta: Dictionary = get_user_value("file_meta", {})
	# Comprueba file_meta.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if file_meta.has(path):
		# Crea cursor e inicializa su valor con file_meta.get(path).get("cursor", "0,0").split(",").
		var cursor: PackedStringArray = file_meta.get(path).get("cursor", "0,0").split(",")
		# Termina el metodo y devuelve Vector2(cursor[0].to_int(), cursor[1].to_int()) a quien lo llamo.
		return Vector2(cursor[0].to_int(), cursor[1].to_int())
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve Vector2.ZERO a quien lo llamo.
		return Vector2.ZERO


# Ejecuta esta instruccion: static func set_scroll(path: String, scroll_vertical: int) -> void:.
static func set_scroll(path: String, scroll_vertical: int) -> void:
	# Crea file_meta e inicializa su valor con get_user_value("file_meta", {}).
	var file_meta: Dictionary = get_user_value("file_meta", {})
	# Ejecuta esta instruccion: file_meta[path] = file_meta.get(path, {}).merged({ scroll_vertical = scroll_vertical }, true).
	file_meta[path] = file_meta.get(path, {}).merged({ scroll_vertical = scroll_vertical }, true)
	# Llama al metodo set_user_value para realizar esta accion en este punto.
	set_user_value("file_meta", file_meta)


# Ejecuta esta instruccion: static func get_scroll(path: String) -> int:.
static func get_scroll(path: String) -> int:
	# Crea file_meta e inicializa su valor con get_user_value("file_meta", {}).
	var file_meta: Dictionary = get_user_value("file_meta", {})
	# Comprueba file_meta.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if file_meta.has(path):
		# Termina el metodo y devuelve file_meta.get(path).get("scroll_vertical", 0) a quien lo llamo.
		return file_meta.get(path).get("scroll_vertical", 0)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve 0 a quien lo llamo.
		return 0


# Ejecuta esta instruccion: static func check_for_dotnet_solution() -> bool:.
static func check_for_dotnet_solution() -> bool:
	# Comprueba Engine.is_editor_hint(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Engine.is_editor_hint():
		# Crea has_dotnet_solution e inicializa su valor con false.
		var has_dotnet_solution: bool = false
		# Comprueba ProjectSettings.has_setting("dotnet/project/solution_directory"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if ProjectSettings.has_setting("dotnet/project/solution_directory"):
			# Crea directory e inicializa su valor con ProjectSettings.get("dotnet/project/solution_directory").
			var directory: String = ProjectSettings.get("dotnet/project/solution_directory")
			# Crea file_name e inicializa su valor con ProjectSettings.get("dotnet/project/assembly_name").
			var file_name: String = ProjectSettings.get("dotnet/project/assembly_name")
			# Guarda en has_dotnet_solution el resultado de FileAccess.file_exists("res://%s/%s.sln" % [directory, file_name]).
			has_dotnet_solution = FileAccess.file_exists("res://%s/%s.sln" % [directory, file_name])
		# Llama al metodo set_setting para realizar esta accion en este punto.
		set_setting(DMSettings.USES_DOTNET, has_dotnet_solution)
		# Termina el metodo y devuelve has_dotnet_solution a quien lo llamo.
		return has_dotnet_solution

	# Termina el metodo y devuelve get_setting(DMSettings.USES_DOTNET, false) a quien lo llamo.
	return get_setting(DMSettings.USES_DOTNET, false)


#endregion
