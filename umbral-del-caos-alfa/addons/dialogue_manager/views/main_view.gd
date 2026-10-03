# Ejecuta esta instruccion: @tool.
@tool
# Hereda de Control y reutiliza sus propiedades y comportamiento base.
extends Control


# Define OPEN_OPEN con el valor fijo 100.
const OPEN_OPEN = 100
# Define OPEN_QUICK con el valor fijo 101.
const OPEN_QUICK = 101
# Define OPEN_CLEAR con el valor fijo 102.
const OPEN_CLEAR = 102

# Define TRANSLATIONS_GENERATE_LINE_IDS con el valor fijo 100.
const TRANSLATIONS_GENERATE_LINE_IDS = 100
# Define TRANSLATIONS_SAVE_CHARACTERS_TO_CSV con el valor fijo 201.
const TRANSLATIONS_SAVE_CHARACTERS_TO_CSV = 201
# Define TRANSLATIONS_SAVE_TO_CSV con el valor fijo 202.
const TRANSLATIONS_SAVE_TO_CSV = 202
# Define TRANSLATIONS_IMPORT_FROM_CSV con el valor fijo 203.
const TRANSLATIONS_IMPORT_FROM_CSV = 203

# Define ITEM_SAVE con el valor fijo 100.
const ITEM_SAVE = 100
# Define ITEM_SAVE_AS con el valor fijo 101.
const ITEM_SAVE_AS = 101
# Define ITEM_CLOSE con el valor fijo 102.
const ITEM_CLOSE = 102
# Define ITEM_CLOSE_ALL con el valor fijo 103.
const ITEM_CLOSE_ALL = 103
# Define ITEM_CLOSE_OTHERS con el valor fijo 104.
const ITEM_CLOSE_OTHERS = 104
# Define ITEM_COPY_PATH con el valor fijo 200.
const ITEM_COPY_PATH = 200
# Define ITEM_SHOW_IN_FILESYSTEM con el valor fijo 201.
const ITEM_SHOW_IN_FILESYSTEM = 201

# Ejecuta esta instruccion: enum TranslationSource {.
enum TranslationSource {
	# Ejecuta esta instruccion: CharacterNames,.
	CharacterNames,
	# Ejecuta esta instruccion: Lines.
	Lines
}


# Declara la seconfirmation_closed1al confirmation_closed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal confirmation_closed()


# Obtiene la referencia parse_timer cuando el nodo ya esta listo.
@onready var parse_timer: Timer = $ParseTimer

# Dialogs
@onready var new_dialog: FileDialog = $NewDialog
# Obtiene la referencia save_dialog cuando el nodo ya esta listo.
@onready var save_dialog: FileDialog = $SaveDialog
# Obtiene la referencia open_dialog cuando el nodo ya esta listo.
@onready var open_dialog: FileDialog = $OpenDialog
# Obtiene la referencia quick_open_dialog cuando el nodo ya esta listo.
@onready var quick_open_dialog: ConfirmationDialog = $QuickOpenDialog
# Obtiene la referencia quick_open_files_list cuando el nodo ya esta listo.
@onready var quick_open_files_list: VBoxContainer = $QuickOpenDialog/QuickOpenFilesList
# Obtiene la referencia export_dialog cuando el nodo ya esta listo.
@onready var export_dialog: FileDialog = $ExportDialog
# Obtiene la referencia import_dialog cuando el nodo ya esta listo.
@onready var import_dialog: FileDialog = $ImportDialog
# Obtiene la referencia errors_dialog cuando el nodo ya esta listo.
@onready var errors_dialog: AcceptDialog = $ErrorsDialog
# Obtiene la referencia build_error_dialog cuando el nodo ya esta listo.
@onready var build_error_dialog: AcceptDialog = $BuildErrorDialog
# Obtiene la referencia close_confirmation_dialog cuando el nodo ya esta listo.
@onready var close_confirmation_dialog: ConfirmationDialog = $CloseConfirmationDialog
# Obtiene la referencia updated_dialog cuando el nodo ya esta listo.
@onready var updated_dialog: AcceptDialog = $UpdatedDialog
# Obtiene la referencia find_in_files_dialog cuando el nodo ya esta listo.
@onready var find_in_files_dialog: AcceptDialog = $FindInFilesDialog
# Obtiene la referencia find_in_files cuando el nodo ya esta listo.
@onready var find_in_files: Control = $FindInFilesDialog/FindInFiles

# Toolbar
@onready var new_button: Button = %NewButton
# Obtiene la referencia open_button cuando el nodo ya esta listo.
@onready var open_button: MenuButton = %OpenButton
# Obtiene la referencia save_all_button cuando el nodo ya esta listo.
@onready var save_all_button: Button = %SaveAllButton
# Obtiene la referencia find_in_files_button cuando el nodo ya esta listo.
@onready var find_in_files_button: Button = %FindInFilesButton
# Obtiene la referencia test_button cuando el nodo ya esta listo.
@onready var test_button: Button = %TestButton
# Obtiene la referencia test_line_button cuando el nodo ya esta listo.
@onready var test_line_button: Button = %TestLineButton
# Obtiene la referencia search_button cuando el nodo ya esta listo.
@onready var search_button: Button = %SearchButton
# Obtiene la referencia insert_button cuando el nodo ya esta listo.
@onready var insert_button: MenuButton = %InsertButton
# Obtiene la referencia translations_button cuando el nodo ya esta listo.
@onready var translations_button: MenuButton = %TranslationsButton
# Obtiene la referencia support_button cuando el nodo ya esta listo.
@onready var support_button: Button = %SupportButton
# Obtiene la referencia docs_button cuando el nodo ya esta listo.
@onready var docs_button: Button = %DocsButton
# Obtiene la referencia version_label cuando el nodo ya esta listo.
@onready var version_label: Label = %VersionLabel
# Obtiene la referencia update_button cuando el nodo ya esta listo.
@onready var update_button: Button = %UpdateButton

# Obtiene la referencia search_and_replace cuando el nodo ya esta listo.
@onready var search_and_replace := %SearchAndReplace

# Code editor
@onready var content: HSplitContainer = %Content
# Obtiene la referencia files_list cuando el nodo ya esta listo.
@onready var files_list := %FilesList
# Obtiene la referencia files_popup_menu cuando el nodo ya esta listo.
@onready var files_popup_menu: PopupMenu = %FilesPopupMenu
# Obtiene la referencia title_list cuando el nodo ya esta listo.
@onready var title_list := %TitleList
# Obtiene la referencia code_edit cuando el nodo ya esta listo.
@onready var code_edit: DMCodeEdit = %CodeEdit
# Obtiene la referencia errors_panel cuando el nodo ya esta listo.
@onready var errors_panel := %ErrorsPanel

# The currently open file
var current_file_path: String = "":
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_current_file_path):
		# Guarda en current_file_path el resultado de next_current_file_path.
		current_file_path = next_current_file_path
		# Guarda en files_list.current_file_path el resultado de current_file_path.
		files_list.current_file_path = current_file_path
		# Comprueba current_file_path == "" or not open_buffers.has(current_file_path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if current_file_path == "" or not open_buffers.has(current_file_path):
			# Guarda en save_all_button.disabled el resultado de true.
			save_all_button.disabled = true
			# Guarda en test_button.disabled el resultado de true.
			test_button.disabled = true
			# Guarda en test_line_button.disabled el resultado de true.
			test_line_button.disabled = true
			# Guarda en search_button.disabled el resultado de true.
			search_button.disabled = true
			# Guarda en insert_button.disabled el resultado de true.
			insert_button.disabled = true
			# Guarda en translations_button.disabled el resultado de true.
			translations_button.disabled = true
			# Guarda en content.dragger_visibility el resultado de SplitContainer.DRAGGER_HIDDEN.
			content.dragger_visibility = SplitContainer.DRAGGER_HIDDEN
			# Llama al metodo files_list.hide para realizar esta accion en este punto.
			files_list.hide()
			# Llama al metodo title_list.hide para realizar esta accion en este punto.
			title_list.hide()
			# Llama al metodo code_edit.hide para realizar esta accion en este punto.
			code_edit.hide()
			# Llama al metodo errors_panel.hide para realizar esta accion en este punto.
			errors_panel.hide()
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en test_button.disabled el resultado de false.
			test_button.disabled = false
			# Guarda en test_line_button.disabled el resultado de false.
			test_line_button.disabled = false
			# Guarda en search_button.disabled el resultado de false.
			search_button.disabled = false
			# Guarda en insert_button.disabled el resultado de false.
			insert_button.disabled = false
			# Guarda en translations_button.disabled el resultado de false.
			translations_button.disabled = false
			# Guarda en content.dragger_visibility el resultado de SplitContainer.DRAGGER_VISIBLE.
			content.dragger_visibility = SplitContainer.DRAGGER_VISIBLE
			# Llama al metodo files_list.show para realizar esta accion en este punto.
			files_list.show()
			# Llama al metodo title_list.show para realizar esta accion en este punto.
			title_list.show()
			# Llama al metodo code_edit.show para realizar esta accion en este punto.
			code_edit.show()

			# Crea cursor e inicializa su valor con DMSettings.get_caret(current_file_path).
			var cursor: Vector2 = DMSettings.get_caret(current_file_path)
			# Crea scroll_vertical e inicializa su valor con DMSettings.get_scroll(current_file_path).
			var scroll_vertical: int = DMSettings.get_scroll(current_file_path)

			# Guarda en code_edit.text el resultado de open_buffers[current_file_path].text.
			code_edit.text = open_buffers[current_file_path].text
			# Guarda en code_edit.errors el resultado de [].
			code_edit.errors = []
			# Llama al metodo code_edit.clear_undo_history para realizar esta accion en este punto.
			code_edit.clear_undo_history()
			# Llama al metodo code_edit.set_cursor para realizar esta accion en este punto.
			code_edit.set_cursor(cursor)
			# Guarda en code_edit.scroll_vertical el resultado de scroll_vertical.
			code_edit.scroll_vertical = scroll_vertical
			# Llama al metodo code_edit.grab_focus para realizar esta accion en este punto.
			code_edit.grab_focus()

			# Llama al metodo _on_code_edit_text_changed para realizar esta accion en este punto.
			_on_code_edit_text_changed()

			# Guarda en errors_panel.errors el resultado de [].
			errors_panel.errors = []
			# Guarda en code_edit.errors el resultado de [].
			code_edit.errors = []

			# Comprueba search_and_replace.visible; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if search_and_replace.visible:
				# Llama al metodo search_and_replace.search para realizar esta accion en este punto.
				search_and_replace.search()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve current_file_path a quien lo llamo.
		return current_file_path

# A reference to the currently open files and their last saved text
var open_buffers: Dictionary = {}

# Which thing are we exporting translations for?
var translation_source: TranslationSource = TranslationSource.Lines

# Declara plugin para guardar un dato utilizado por este script.
var plugin: EditorPlugin


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Guarda en plugin el resultado de Engine.get_meta("DialogueManagerPlugin").
	plugin = Engine.get_meta("DialogueManagerPlugin")

	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()

	# Start with nothing open
	self.current_file_path = ""

	# Set up the update checker
	version_label.text = "v%s" % plugin.get_version()
	# Guarda en update_button.on_before_refresh el resultado de func on_before_refresh():.
	update_button.on_before_refresh = func on_before_refresh():
		# Save everything
		DMSettings.set_user_value("just_refreshed", {
			# Guarda en current_file_path el resultado de current_file_path,.
			current_file_path = current_file_path,
			# Guarda en open_buffers el resultado de open_buffers.
			open_buffers = open_buffers
		# Ejecuta esta instruccion: }).
		})
		# Termina el metodo y devuelve true a quien lo llamo.
		return true

	# Did we just load from an addon version refresh?
	var just_refreshed = DMSettings.get_user_value("just_refreshed", null)
	# Comprueba just_refreshed != null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if just_refreshed != null:
		# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
		DMSettings.set_user_value("just_refreshed", null)
		# Llama al metodo call_deferred para realizar esta accion en este punto.
		call_deferred("load_from_version_refresh", just_refreshed)

	# Hook up the search toolbar
	search_and_replace.code_edit = code_edit

	# Connect menu buttons
	insert_button.get_popup().id_pressed.connect(_on_insert_button_menu_id_pressed)
	# Llama al metodo translations_button.get_popup para realizar esta accion en este punto.
	translations_button.get_popup().id_pressed.connect(_on_translations_button_menu_id_pressed)

	# Guarda en code_edit.main_view el resultado de self.
	code_edit.main_view = self
	# Guarda en code_edit.wrap_mode el resultado de TextEdit.LINE_WRAPPING_BOUNDARY if DMSettings.get_setting(DMSettings.WRAP_LONG_LINES, false) else TextEdit.LINE_WRAPPING_NONE.
	code_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY if DMSettings.get_setting(DMSettings.WRAP_LONG_LINES, false) else TextEdit.LINE_WRAPPING_NONE
	# Crea editor_settings e inicializa su valor con EditorInterface.get_editor_settings().
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	# Llama al metodo editor_settings.settings_changed.connect para realizar esta accion en este punto.
	editor_settings.settings_changed.connect(_on_editor_settings_changed)
	# Llama al metodo _on_editor_settings_changed para realizar esta accion en este punto.
	_on_editor_settings_changed()

	# Reopen any files that were open when Godot was closed
	if editor_settings.get_setting("text_editor/behavior/files/restore_scripts_on_load"):
		# Crea reopen_files e inicializa su valor con DMSettings.get_user_value("reopen_files", []).
		var reopen_files: Array = DMSettings.get_user_value("reopen_files", [])
		# Recorre reopen_files y asigna cada elemento a reopen_file en cada vuelta.
		for reopen_file in reopen_files:
			# Llama al metodo open_file para realizar esta accion en este punto.
			open_file(reopen_file)

		# Guarda en self.current_file_path el resultado de DMSettings.get_user_value("most_recent_reopen_file", "").
		self.current_file_path = DMSettings.get_user_value("most_recent_reopen_file", "")

	# Guarda en save_all_button.disabled el resultado de true.
	save_all_button.disabled = true

	# Guarda en close_confirmation_dialog.ok_button_text el resultado de DMConstants.translate(&"confirm_close.save").
	close_confirmation_dialog.ok_button_text = DMConstants.translate(&"confirm_close.save")
	# Llama al metodo close_confirmation_dialog.add_button para realizar esta accion en este punto.
	close_confirmation_dialog.add_button(DMConstants.translate(&"confirm_close.discard"), true, "discard")

	# Guarda en errors_dialog.dialog_text el resultado de DMConstants.translate(&"errors_in_script").
	errors_dialog.dialog_text = DMConstants.translate(&"errors_in_script")

	# Update the buffer if a file was modified externally (retains undo step)
	Engine.get_meta("DMCache").file_content_changed.connect(_on_cache_file_content_changed)

	# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
	EditorInterface.get_file_system_dock().files_moved.connect(_on_files_moved)

	# Llama al metodo code_edit.get_v_scroll_bar para realizar esta accion en este punto.
	code_edit.get_v_scroll_bar().value_changed.connect(_on_code_edit_scroll_changed)


# Define el metodo _exit_tree para agrupar esta accion del script.
func _exit_tree() -> void:
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("reopen_files", open_buffers.keys())
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("most_recent_reopen_file", self.current_file_path)


# Define el metodo _unhandled_input para agrupar esta accion del script.
func _unhandled_input(event: InputEvent) -> void:
	# Ejecuta esta instruccion: if not visible: return.
	if not visible: return

	# Comprueba event is InputEventKey and event.is_pressed(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if event is InputEventKey and event.is_pressed():
		# Crea shortcut e inicializa su valor con plugin.get_editor_shortcut(event).
		var shortcut: String = plugin.get_editor_shortcut(event)
		# Compara shortcut con los casos siguientes y ejecuta el que coincida.
		match shortcut:
			# Asocia la clave "close_file" con  dentro del diccionario.
			"close_file":
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
				# Llama al metodo close_file para realizar esta accion en este punto.
				close_file(current_file_path)
			# Asocia la clave "save" con  dentro del diccionario.
			"save":
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
				# Llama al metodo save_file para realizar esta accion en este punto.
				save_file(current_file_path)
			# Asocia la clave "find_in_files" con  dentro del diccionario.
			"find_in_files":
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
				# Llama al metodo _on_find_in_files_button_pressed para realizar esta accion en este punto.
				_on_find_in_files_button_pressed()
			# Asocia la clave "run_test_scene" con  dentro del diccionario.
			"run_test_scene":
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
				# Llama al metodo _on_test_button_pressed para realizar esta accion en este punto.
				_on_test_button_pressed()


# Define el metodo apply_changes para agrupar esta accion del script.
func apply_changes() -> void:
	# Llama al metodo save_files para realizar esta accion en este punto.
	save_files()


# Load back to the previous buffer regardless of if it was actually saved
func load_from_version_refresh(just_refreshed: Dictionary) -> void:
	# Comprueba just_refreshed.has("current_file_content"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if just_refreshed.has("current_file_content"):
		# We just loaded from a version before multiple buffers
		var file: FileAccess = FileAccess.open(just_refreshed.current_file_path, FileAccess.READ)
		# Crea file_text e inicializa su valor con file.get_as_text().
		var file_text: String = file.get_as_text()
		# Ejecuta esta instruccion: open_buffers[just_refreshed.current_file_path] = {.
		open_buffers[just_refreshed.current_file_path] = {
			# Guarda en pristine_text el resultado de file_text,.
			pristine_text = file_text,
			# Guarda en text el resultado de just_refreshed.current_file_content.
			text = just_refreshed.current_file_content
		}
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en open_buffers el resultado de just_refreshed.open_buffers.
		open_buffers = just_refreshed.open_buffers

	# Comprueba just_refreshed.current_file_path != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if just_refreshed.current_file_path != "":
		# Llama al metodo EditorInterface.edit_resource para realizar esta accion en este punto.
		EditorInterface.edit_resource(load(just_refreshed.current_file_path))
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo EditorInterface.set_main_screen_editor para realizar esta accion en este punto.
		EditorInterface.set_main_screen_editor("Dialogue")

	# Guarda en updated_dialog.dialog_text el resultado de DMConstants.translate(&"update.success").format({ version = update_button.get_version() }).
	updated_dialog.dialog_text = DMConstants.translate(&"update.success").format({ version = update_button.get_version() })
	# Llama al metodo updated_dialog.popup_centered para realizar esta accion en este punto.
	updated_dialog.popup_centered()


# Define el metodo new_file para agrupar esta accion del script.
func new_file(path: String, content: String = "") -> void:
	# Comprueba open_buffers.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if open_buffers.has(path):
		# Llama al metodo remove_file_from_open_buffers para realizar esta accion en este punto.
		remove_file_from_open_buffers(path)

	# Crea file e inicializa su valor con FileAccess.open(path, FileAccess.WRITE).
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	# Comprueba content == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if content == "":
		# Llama al metodo file.store_string para realizar esta accion en este punto.
		file.store_string(DMSettings.get_setting(DMSettings.NEW_FILE_TEMPLATE, ""))
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo file.store_string para realizar esta accion en este punto.
		file.store_string(content)

	# Llama al metodo EditorInterface.get_resource_filesystem para realizar esta accion en este punto.
	EditorInterface.get_resource_filesystem().scan()


# Open a dialogue resource for editing
func open_resource(resource: DialogueResource) -> void:
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(resource.resource_path)


# Define el metodo open_file para agrupar esta accion del script.
func open_file(path: String) -> void:
	# Ejecuta esta instruccion: if not FileAccess.file_exists(path): return.
	if not FileAccess.file_exists(path): return

	# Comprueba not open_buffers.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not open_buffers.has(path):
		# Crea file e inicializa su valor con FileAccess.open(path, FileAccess.READ).
		var file: FileAccess = FileAccess.open(path, FileAccess.READ)
		# Crea text e inicializa su valor con file.get_as_text().
		var text = file.get_as_text()

		# Ejecuta esta instruccion: open_buffers[path] = {.
		open_buffers[path] = {
			# Guarda en cursor el resultado de Vector2.ZERO,.
			cursor = Vector2.ZERO,
			# Guarda en text el resultado de text,.
			text = text,
			# Guarda en pristine_text el resultado de text.
			pristine_text = text
		}

	# Llama al metodo DMSettings.add_recent_file para realizar esta accion en este punto.
	DMSettings.add_recent_file(path)
	# Llama al metodo build_open_menu para realizar esta accion en este punto.
	build_open_menu()

	# Guarda en files_list.files el resultado de open_buffers.keys().
	files_list.files = open_buffers.keys()
	# Llama al metodo files_list.select_file para realizar esta accion en este punto.
	files_list.select_file(path)

	# Guarda en self.current_file_path el resultado de path.
	self.current_file_path = path


# Define el metodo show_file_in_filesystem para agrupar esta accion del script.
func show_file_in_filesystem(path: String) -> void:
	# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
	EditorInterface.get_file_system_dock().navigate_to_path(path)


# Save any open files
func save_files() -> void:
	# Guarda en save_all_button.disabled el resultado de true.
	save_all_button.disabled = true

	# Crea saved_files e inicializa su valor con [].
	var saved_files: PackedStringArray = []
	# Recorre open_buffers y asigna cada elemento a path en cada vuelta.
	for path in open_buffers:
		# Comprueba open_buffers[path].text != open_buffers[path].pristine_text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if open_buffers[path].text != open_buffers[path].pristine_text:
			# Llama al metodo saved_files.append para realizar esta accion en este punto.
			saved_files.append(path)
		# Llama al metodo save_file para realizar esta accion en este punto.
		save_file(path, false)

	# Comprueba saved_files.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if saved_files.size() > 0:
		# Llama al metodo Engine.get_meta para realizar esta accion en este punto.
		Engine.get_meta("DMCache").mark_files_for_reimport(saved_files)


# Save a file
func save_file(path: String, rescan_file_system: bool = true) -> void:
	# Crea buffer e inicializa su valor con open_buffers[path].
	var buffer = open_buffers[path]

	# Llama al metodo files_list.mark_file_as_unsaved para realizar esta accion en este punto.
	files_list.mark_file_as_unsaved(path, false)
	# Guarda en save_all_button.disabled el resultado de files_list.unsaved_files.size() == 0.
	save_all_button.disabled = files_list.unsaved_files.size() == 0

	# Don't bother saving if there is nothing to save
	if buffer.text == buffer.pristine_text:
		# Termina el metodo sin devolver un valor.
		return

	# Guarda en buffer.pristine_text el resultado de buffer.text.
	buffer.pristine_text = buffer.text

	# Save the current text
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	# Llama al metodo file.store_string para realizar esta accion en este punto.
	file.store_string(buffer.text)
	# Llama al metodo file.close para realizar esta accion en este punto.
	file.close()

	# Comprueba rescan_file_system; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if rescan_file_system:
		# Llama al metodo EditorInterface.get_resource_filesystem para realizar esta accion en este punto.
		EditorInterface.get_resource_filesystem().scan()


# Define el metodo close_file para agrupar esta accion del script.
func close_file(path: String) -> void:
	# Ejecuta esta instruccion: if not path in open_buffers.keys(): return.
	if not path in open_buffers.keys(): return

	# Crea buffer e inicializa su valor con open_buffers[path].
	var buffer = open_buffers[path]

	# Comprueba buffer.text == buffer.pristine_text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if buffer.text == buffer.pristine_text:
		# Llama al metodo remove_file_from_open_buffers para realizar esta accion en este punto.
		remove_file_from_open_buffers(path)
		# Espera a que termine get_tree().process_frame antes de continuar.
		await get_tree().process_frame
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en close_confirmation_dialog.dialog_text el resultado de DMConstants.translate(&"confirm_close").format({ path = path.get_file() }).
		close_confirmation_dialog.dialog_text = DMConstants.translate(&"confirm_close").format({ path = path.get_file() })
		# Llama al metodo close_confirmation_dialog.popup_centered para realizar esta accion en este punto.
		close_confirmation_dialog.popup_centered()
		# Espera a que termine confirmation_closed antes de continuar.
		await confirmation_closed


# Define el metodo remove_file_from_open_buffers para agrupar esta accion del script.
func remove_file_from_open_buffers(path: String) -> void:
	# Ejecuta esta instruccion: if not path in open_buffers.keys(): return.
	if not path in open_buffers.keys(): return

	# Crea current_index e inicializa su valor con open_buffers.keys().find(current_file_path).
	var current_index = open_buffers.keys().find(current_file_path)

	# Llama al metodo open_buffers.erase para realizar esta accion en este punto.
	open_buffers.erase(path)
	# Comprueba open_buffers.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if open_buffers.size() == 0:
		# Guarda en self.current_file_path el resultado de "".
		self.current_file_path = ""
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en current_index el resultado de clamp(current_index, 0, open_buffers.size() - 1).
		current_index = clamp(current_index, 0, open_buffers.size() - 1)
		# Guarda en self.current_file_path el resultado de open_buffers.keys()[current_index].
		self.current_file_path = open_buffers.keys()[current_index]

	# Guarda en files_list.files el resultado de open_buffers.keys().
	files_list.files = open_buffers.keys()


# Apply theme colors and icons to the UI
func apply_theme() -> void:
	# Comprueba is_instance_valid(plugin) and is_instance_valid(code_edit); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(plugin) and is_instance_valid(code_edit):
		# Crea scale e inicializa su valor con EditorInterface.get_editor_scale().
		var scale: float = EditorInterface.get_editor_scale()
		# Crea editor_settings e inicializa su valor con EditorInterface.get_editor_settings().
		var editor_settings = EditorInterface.get_editor_settings()
		# Guarda en code_edit.theme_overrides el resultado de {.
		code_edit.theme_overrides = {
			# Guarda en scale el resultado de scale,.
			scale = scale,

			# Guarda en background_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/background_color"),.
			background_color = editor_settings.get_setting("text_editor/theme/highlighting/background_color"),
			# Guarda en current_line_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/current_line_color"),.
			current_line_color = editor_settings.get_setting("text_editor/theme/highlighting/current_line_color"),
			# Guarda en error_line_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/mark_color"),.
			error_line_color = editor_settings.get_setting("text_editor/theme/highlighting/mark_color"),

			# Guarda en critical_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/comment_markers/critical_color"),.
			critical_color = editor_settings.get_setting("text_editor/theme/highlighting/comment_markers/critical_color"),
			# Guarda en notice_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/comment_markers/notice_color"),.
			notice_color = editor_settings.get_setting("text_editor/theme/highlighting/comment_markers/notice_color"),

			# Guarda en titles_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/control_flow_keyword_color"),.
			titles_color = editor_settings.get_setting("text_editor/theme/highlighting/control_flow_keyword_color"),
			# Guarda en text_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/text_color"),.
			text_color = editor_settings.get_setting("text_editor/theme/highlighting/text_color"),
			# Guarda en conditions_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/keyword_color"),.
			conditions_color = editor_settings.get_setting("text_editor/theme/highlighting/keyword_color"),
			# Guarda en mutations_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/function_color"),.
			mutations_color = editor_settings.get_setting("text_editor/theme/highlighting/function_color"),
			# Guarda en members_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/member_variable_color"),.
			members_color = editor_settings.get_setting("text_editor/theme/highlighting/member_variable_color"),
			# Guarda en strings_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/string_color"),.
			strings_color = editor_settings.get_setting("text_editor/theme/highlighting/string_color"),
			# Guarda en numbers_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/number_color"),.
			numbers_color = editor_settings.get_setting("text_editor/theme/highlighting/number_color"),
			# Guarda en symbols_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/symbol_color"),.
			symbols_color = editor_settings.get_setting("text_editor/theme/highlighting/symbol_color"),
			# Guarda en comments_color el resultado de editor_settings.get_setting("text_editor/theme/highlighting/comment_color"),.
			comments_color = editor_settings.get_setting("text_editor/theme/highlighting/comment_color"),
			# Guarda en jumps_color el resultado de Color(editor_settings.get_setting("text_editor/theme/highlighting/control_flow_keyword_color"), 0.7),.
			jumps_color = Color(editor_settings.get_setting("text_editor/theme/highlighting/control_flow_keyword_color"), 0.7),

			# Guarda en font_size el resultado de editor_settings.get_setting("interface/editor/code_font_size").
			font_size = editor_settings.get_setting("interface/editor/code_font_size")
		}

		# Guarda en new_button.icon el resultado de get_theme_icon("New", "EditorIcons").
		new_button.icon = get_theme_icon("New", "EditorIcons")
		# Guarda en new_button.tooltip_text el resultado de DMConstants.translate(&"start_a_new_file").
		new_button.tooltip_text = DMConstants.translate(&"start_a_new_file")

		# Guarda en open_button.icon el resultado de get_theme_icon("Load", "EditorIcons").
		open_button.icon = get_theme_icon("Load", "EditorIcons")
		# Guarda en open_button.tooltip_text el resultado de DMConstants.translate(&"open_a_file").
		open_button.tooltip_text = DMConstants.translate(&"open_a_file")

		# Guarda en save_all_button.icon el resultado de get_theme_icon("Save", "EditorIcons").
		save_all_button.icon = get_theme_icon("Save", "EditorIcons")
		# Guarda en save_all_button.text el resultado de DMConstants.translate(&"all").
		save_all_button.text = DMConstants.translate(&"all")
		# Guarda en save_all_button.tooltip_text el resultado de DMConstants.translate(&"start_all_files").
		save_all_button.tooltip_text = DMConstants.translate(&"start_all_files")

		# Guarda en find_in_files_button.icon el resultado de get_theme_icon("ViewportZoom", "EditorIcons").
		find_in_files_button.icon = get_theme_icon("ViewportZoom", "EditorIcons")
		# Guarda en find_in_files_button.tooltip_text el resultado de DMConstants.translate(&"find_in_files").
		find_in_files_button.tooltip_text = DMConstants.translate(&"find_in_files")

		# Guarda en test_button.icon el resultado de get_theme_icon("DebugNext", "EditorIcons").
		test_button.icon = get_theme_icon("DebugNext", "EditorIcons")
		# Guarda en test_button.tooltip_text el resultado de DMConstants.translate(&"test_dialogue").
		test_button.tooltip_text = DMConstants.translate(&"test_dialogue")

		# Guarda en test_line_button.icon el resultado de get_theme_icon("DebugStep", "EditorIcons").
		test_line_button.icon = get_theme_icon("DebugStep", "EditorIcons")
		# Guarda en test_line_button.tooltip_text el resultado de DMConstants.translate(&"test_dialogue_from_line").
		test_line_button.tooltip_text = DMConstants.translate(&"test_dialogue_from_line")

		# Guarda en search_button.icon el resultado de get_theme_icon("Search", "EditorIcons").
		search_button.icon = get_theme_icon("Search", "EditorIcons")
		# Guarda en search_button.tooltip_text el resultado de DMConstants.translate(&"search_for_text").
		search_button.tooltip_text = DMConstants.translate(&"search_for_text")

		# Guarda en insert_button.icon el resultado de get_theme_icon("RichTextEffect", "EditorIcons").
		insert_button.icon = get_theme_icon("RichTextEffect", "EditorIcons")
		# Guarda en insert_button.text el resultado de DMConstants.translate(&"insert").
		insert_button.text = DMConstants.translate(&"insert")

		# Guarda en translations_button.icon el resultado de get_theme_icon("Translation", "EditorIcons").
		translations_button.icon = get_theme_icon("Translation", "EditorIcons")
		# Guarda en translations_button.text el resultado de DMConstants.translate(&"translations").
		translations_button.text = DMConstants.translate(&"translations")

		# Guarda en support_button.icon el resultado de get_theme_icon("Heart", "EditorIcons").
		support_button.icon = get_theme_icon("Heart", "EditorIcons")
		# Guarda en support_button.text el resultado de DMConstants.translate(&"sponsor").
		support_button.text = DMConstants.translate(&"sponsor")
		# Guarda en support_button.tooltip_text el resultado de DMConstants.translate(&"show_support").
		support_button.tooltip_text = DMConstants.translate(&"show_support")

		# Guarda en docs_button.icon el resultado de get_theme_icon("Help", "EditorIcons").
		docs_button.icon = get_theme_icon("Help", "EditorIcons")
		# Guarda en docs_button.text el resultado de DMConstants.translate(&"docs").
		docs_button.text = DMConstants.translate(&"docs")

		# Llama al metodo update_button.apply_theme para realizar esta accion en este punto.
		update_button.apply_theme()

		# Set up the effect menu
		var popup: PopupMenu = insert_button.get_popup()
		# Llama al metodo popup.clear para realizar esta accion en este punto.
		popup.clear()
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.wave_bbcode"), 0)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.shake_bbcode"), 1)
		# Llama al metodo popup.add_separator para realizar esta accion en este punto.
		popup.add_separator()
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("Time", "EditorIcons"), DMConstants.translate(&"insert.typing_pause"), 3)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("ViewportSpeed", "EditorIcons"), DMConstants.translate(&"insert.typing_speed_change"), 4)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("DebugNext", "EditorIcons"), DMConstants.translate(&"insert.auto_advance"), 5)
		# Llama al metodo popup.add_separator para realizar esta accion en este punto.
		popup.add_separator(DMConstants.translate(&"insert.templates"))
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.title"), 6)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.dialogue"), 7)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.response"), 8)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.random_lines"), 9)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.random_text"), 10)
		# Llama al metodo popup.add_separator para realizar esta accion en este punto.
		popup.add_separator(DMConstants.translate(&"insert.actions"))
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.jump"), 11)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("RichTextEffect", "EditorIcons"), DMConstants.translate(&"insert.end_dialogue"), 12)

		# Set up the translations menu
		popup = translations_button.get_popup()
		# Llama al metodo popup.clear para realizar esta accion en este punto.
		popup.clear()
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("Translation", "EditorIcons"), DMConstants.translate(&"generate_line_ids"), TRANSLATIONS_GENERATE_LINE_IDS)
		# Llama al metodo popup.add_separator para realizar esta accion en este punto.
		popup.add_separator()
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("FileList", "EditorIcons"), DMConstants.translate(&"save_characters_to_csv"), TRANSLATIONS_SAVE_CHARACTERS_TO_CSV)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("FileList", "EditorIcons"), DMConstants.translate(&"save_to_csv"), TRANSLATIONS_SAVE_TO_CSV)
		# Llama al metodo popup.add_icon_item para realizar esta accion en este punto.
		popup.add_icon_item(get_theme_icon("AssetLib", "EditorIcons"), DMConstants.translate(&"import_from_csv"), TRANSLATIONS_IMPORT_FROM_CSV)

		# Dialog sizes
		new_dialog.min_size = Vector2(600, 500) * scale
		# Guarda en save_dialog.min_size el resultado de Vector2(600, 500) * scale.
		save_dialog.min_size = Vector2(600, 500) * scale
		# Guarda en open_dialog.min_size el resultado de Vector2(600, 500) * scale.
		open_dialog.min_size = Vector2(600, 500) * scale
		# Guarda en quick_open_dialog.min_size el resultado de Vector2(400, 600) * scale.
		quick_open_dialog.min_size = Vector2(400, 600) * scale
		# Guarda en export_dialog.min_size el resultado de Vector2(600, 500) * scale.
		export_dialog.min_size = Vector2(600, 500) * scale
		# Guarda en import_dialog.min_size el resultado de Vector2(600, 500) * scale.
		import_dialog.min_size = Vector2(600, 500) * scale
		# Guarda en find_in_files_dialog.min_size el resultado de Vector2(800, 600) * scale.
		find_in_files_dialog.min_size = Vector2(800, 600) * scale


### Helpers


# Refresh the open menu with the latest files
func build_open_menu() -> void:
	# Crea menu e inicializa su valor con open_button.get_popup().
	var menu = open_button.get_popup()
	# Llama al metodo menu.clear para realizar esta accion en este punto.
	menu.clear()
	# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
	menu.add_icon_item(get_theme_icon("Load", "EditorIcons"), DMConstants.translate(&"open.open"), OPEN_OPEN)
	# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
	menu.add_icon_item(get_theme_icon("Load", "EditorIcons"), DMConstants.translate(&"open.quick_open"), OPEN_QUICK)
	# Llama al metodo menu.add_separator para realizar esta accion en este punto.
	menu.add_separator()

	# Crea recent_files e inicializa su valor con DMSettings.get_recent_files().
	var recent_files = DMSettings.get_recent_files()
	# Comprueba recent_files.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if recent_files.size() == 0:
		# Llama al metodo menu.add_item para realizar esta accion en este punto.
		menu.add_item(DMConstants.translate(&"open.no_recent_files"))
		# Llama al metodo menu.set_item_disabled para realizar esta accion en este punto.
		menu.set_item_disabled(2, true)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Recorre recent_files y asigna cada elemento a path en cada vuelta.
		for path in recent_files:
			# Comprueba FileAccess.file_exists(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if FileAccess.file_exists(path):
				# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
				menu.add_icon_item(get_theme_icon("File", "EditorIcons"), path)

	# Llama al metodo menu.add_separator para realizar esta accion en este punto.
	menu.add_separator()
	# Llama al metodo menu.add_item para realizar esta accion en este punto.
	menu.add_item(DMConstants.translate(&"open.clear_recent_files"), OPEN_CLEAR)
	# Comprueba menu.id_pressed.is_connected(_on_open_menu_id_pressed); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if menu.id_pressed.is_connected(_on_open_menu_id_pressed):
		# Llama al metodo menu.id_pressed.disconnect para realizar esta accion en este punto.
		menu.id_pressed.disconnect(_on_open_menu_id_pressed)
	# Llama al metodo menu.id_pressed.connect para realizar esta accion en este punto.
	menu.id_pressed.connect(_on_open_menu_id_pressed)


# Get the last place a CSV, etc was exported
func get_last_export_path(extension: String) -> String:
	# Crea filename e inicializa su valor con current_file_path.get_file().replace(".dialogue", "." + extension).
	var filename = current_file_path.get_file().replace(".dialogue", "." + extension)
	# Termina el metodo y devuelve DMSettings.get_user_value("last_export_path", current_file_path.get_base_dir()) + "/" + filename a quien lo llamo.
	return DMSettings.get_user_value("last_export_path", current_file_path.get_base_dir()) + "/" + filename


# Check the current text for errors
func compile() -> void:
	# Skip if nothing to parse
	if current_file_path == "": return

	# Crea result e inicializa su valor con DMCompiler.compile_string(code_edit.text, current_file_path).
	var result: DMCompilerResult = DMCompiler.compile_string(code_edit.text, current_file_path)
	# Guarda en code_edit.errors el resultado de result.errors.
	code_edit.errors = result.errors
	# Guarda en errors_panel.errors el resultado de result.errors.
	errors_panel.errors = result.errors
	# Guarda en title_list.titles el resultado de code_edit.get_titles().
	title_list.titles = code_edit.get_titles()


# Define el metodo show_build_error_dialog para agrupar esta accion del script.
func show_build_error_dialog() -> void:
	# Guarda en build_error_dialog.dialog_text el resultado de DMConstants.translate(&"errors_with_build").
	build_error_dialog.dialog_text = DMConstants.translate(&"errors_with_build")
	# Llama al metodo build_error_dialog.popup_centered para realizar esta accion en este punto.
	build_error_dialog.popup_centered()


# Generate translation line IDs for any line that doesn't already have one
func generate_translations_keys() -> void:
	# Llama al metodo randomize para realizar esta accion en este punto.
	randomize()
	# Llama al metodo seed para realizar esta accion en este punto.
	seed(Time.get_unix_time_from_system())

	# Crea cursor e inicializa su valor con code_edit.get_cursor().
	var cursor: Vector2 = code_edit.get_cursor()
	# Crea lines e inicializa su valor con code_edit.text.split("\n").
	var lines: PackedStringArray = code_edit.text.split("\n")

	# Crea key_regex e inicializa su valor con RegEx.new().
	var key_regex = RegEx.new()
	# Llama al metodo key_regex.compile para realizar esta accion en este punto.
	key_regex.compile("\\[ID:(?<key>.*?)\\]")

	# Crea compiled_lines e inicializa su valor con DMCompiler.compile_string(code_edit.text, "").lines.
	var compiled_lines: Dictionary = DMCompiler.compile_string(code_edit.text, "").lines

	# Make list of known keys
	var known_keys = {}
	# Recorre range(0, lines.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, lines.size()):
		# Crea line e inicializa su valor con lines[i].
		var line = lines[i]
		# Crea found e inicializa su valor con key_regex.search(line).
		var found = key_regex.search(line)
		# Comprueba found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if found:
			# Crea text e inicializa su valor con "".
			var text = ""
			# Crea l e inicializa su valor con line.replace(found.strings[0], "").strip_edges().strip_edges().
			var l = line.replace(found.strings[0], "").strip_edges().strip_edges()
			# Comprueba l.begins_with("- "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if l.begins_with("- "):
				# Guarda en text el resultado de DMCompiler.extract_translatable_string(l).
				text = DMCompiler.extract_translatable_string(l)
			# Comprueba ":" in l si las condiciones anteriores resultaron falsas.
			elif ":" in l:
				# Guarda en text el resultado de l.split(":")[1].
				text = l.split(":")[1]
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en text el resultado de l.
				text = l
			# Ejecuta esta instruccion: known_keys[found.strings[found.names.get("key")]] = text.
			known_keys[found.strings[found.names.get("key")]] = text

	# Add in any that are missing
	for i in lines.size():
		# Crea line e inicializa su valor con lines[i].
		var line = lines[i]
		# Crea l e inicializa su valor con line.strip_edges().
		var l = line.strip_edges()

		# Ejecuta esta instruccion: if not [DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE].has(DMCompiler.get_line_type(l)): continue.
		if not [DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE].has(DMCompiler.get_line_type(l)): continue
		# Ejecuta esta instruccion: if not compiled_lines.has(str(i)): continue.
		if not compiled_lines.has(str(i)): continue

		# Ejecuta esta instruccion: if "[ID:" in line: continue.
		if "[ID:" in line: continue

		# Crea text e inicializa su valor con "".
		var text = ""
		# Comprueba l.begins_with("- "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if l.begins_with("- "):
			# Guarda en text el resultado de DMCompiler.extract_translatable_string(l).
			text = DMCompiler.extract_translatable_string(l)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en text el resultado de l.substr(l.find(":") + 1).
			text = l.substr(l.find(":") + 1)

		# Crea key e inicializa su valor con "".
		var key: String = ""
		# Comprueba known_keys.values().has(text); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if known_keys.values().has(text):
			# Guarda en key el resultado de known_keys.find_key(text).
			key = known_keys.find_key(text)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Crea regex e inicializa su valor con DMCompilerRegEx.new().
			var regex: DMCompilerRegEx = DMCompilerRegEx.new()
			# Guarda en key el resultado de regex.ALPHA_NUMERIC.sub(text.strip_edges(), "_", true).substr(0, 30).
			key = regex.ALPHA_NUMERIC.sub(text.strip_edges(), "_", true).substr(0, 30)
			# Comprueba key.begins_with("_"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if key.begins_with("_"):
				# Guarda en key el resultado de key.substr(1).
				key = key.substr(1)
			# Comprueba key.ends_with("_"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if key.ends_with("_"):
				# Guarda en key el resultado de key.substr(0, key.length() - 1).
				key = key.substr(0, key.length() - 1)

			# Make sure key is unique
			var hashed_key: String = key + "_" + str(randi() % 1000000).sha1_text().substr(0, 6)
			# Repite este bloque mientras hashed_key in known_keys and text != known_keys.get(hashed_key) sea verdadero.
			while hashed_key in known_keys and text != known_keys.get(hashed_key):
				# Guarda en hashed_key el resultado de key + "_" + str(randi() % 1000000).sha1_text().substr(0, 6).
				hashed_key = key + "_" + str(randi() % 1000000).sha1_text().substr(0, 6)
			# Guarda en key el resultado de hashed_key.to_upper().
			key = hashed_key.to_upper()

		# Guarda en line el resultado de line.replace("\\n", "!NEWLINE!").
		line = line.replace("\\n", "!NEWLINE!")
		# Guarda en text el resultado de text.replace("\n", "!NEWLINE!").
		text = text.replace("\n", "!NEWLINE!")
		# Ejecuta esta instruccion: lines[i] = line.replace(text, text + " [ID:%s]" % [key]).replace("!NEWLINE!", "\\n").
		lines[i] = line.replace(text, text + " [ID:%s]" % [key]).replace("!NEWLINE!", "\\n")

		# Ejecuta esta instruccion: known_keys[key] = text.
		known_keys[key] = text

	# Guarda en code_edit.text el resultado de "\n".join(lines).
	code_edit.text = "\n".join(lines)
	# Llama al metodo code_edit.set_cursor para realizar esta accion en este punto.
	code_edit.set_cursor(cursor)
	# Llama al metodo _on_code_edit_text_changed para realizar esta accion en este punto.
	_on_code_edit_text_changed()


# Add a translation file to the project settings
func add_path_to_project_translations(path: String) -> void:
	# Crea translations e inicializa su valor con ProjectSettings.get_setting("internationalization/locale/translations").
	var translations: PackedStringArray = ProjectSettings.get_setting("internationalization/locale/translations")
	# Comprueba not path in translations; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not path in translations:
		# Llama al metodo translations.append para realizar esta accion en este punto.
		translations.append(path)
		# Llama al metodo ProjectSettings.save para realizar esta accion en este punto.
		ProjectSettings.save()


# Export dialogue and responses to CSV
func export_translations_to_csv(path: String) -> void:
	# Crea default_locale e inicializa su valor con DMSettings.get_setting(DMSettings.DEFAULT_CSV_LOCALE, "en").
	var default_locale: String = DMSettings.get_setting(DMSettings.DEFAULT_CSV_LOCALE, "en")

	# Declara file para guardar un dato utilizado por este script.
	var file: FileAccess

	# If the file exists, open it first and work out which keys are already in it
	var existing_csv: Dictionary = {}
	# Crea column_count e inicializa su valor con 2.
	var column_count: int = 2
	# Crea default_locale_column e inicializa su valor con 1.
	var default_locale_column: int = 1
	# Crea character_column e inicializa su valor con -1.
	var character_column: int = -1
	# Crea notes_column e inicializa su valor con -1.
	var notes_column: int = -1
	# Comprueba FileAccess.file_exists(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if FileAccess.file_exists(path):
		# Guarda en file el resultado de FileAccess.open(path, FileAccess.READ).
		file = FileAccess.open(path, FileAccess.READ)
		# Crea is_first_line e inicializa su valor con true.
		var is_first_line = true
		# Declara line para guardar un dato utilizado por este script.
		var line: Array
		# Repite este bloque mientras !file.eof_reached() sea verdadero.
		while !file.eof_reached():
			# Guarda en line el resultado de file.get_csv_line().
			line = file.get_csv_line()
			# Comprueba is_first_line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if is_first_line:
				# Guarda en is_first_line el resultado de false.
				is_first_line = false
				# Guarda en column_count el resultado de line.size().
				column_count = line.size()
				# Recorre range(1, line.size()) y asigna cada elemento a i en cada vuelta.
				for i in range(1, line.size()):
					# Comprueba line[i] == default_locale; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if line[i] == default_locale:
						# Guarda en default_locale_column el resultado de i.
						default_locale_column = i
					# Comprueba line[i] == "_character" si las condiciones anteriores resultaron falsas.
					elif line[i] == "_character":
						# Guarda en character_column el resultado de i.
						character_column = i
					# Comprueba line[i] == "_notes" si las condiciones anteriores resultaron falsas.
					elif line[i] == "_notes":
						# Guarda en notes_column el resultado de i.
						notes_column = i

			# Make sure the line isn't empty before adding it
			if line.size() > 0 and line[0].strip_edges() != "":
				# Ejecuta esta instruccion: existing_csv[line[0]] = line.
				existing_csv[line[0]] = line

		# The character column wasn't found in the existing file but the setting is turned on
		if character_column == -1 and DMSettings.get_setting(DMSettings.INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS, false):
			# Guarda en character_column el resultado de column_count.
			character_column = column_count
			# Suma a column_count el valor 1 respecto de su valor anterior.
			column_count += 1
			# Ejecuta esta instruccion: existing_csv["keys"].append("_character").
			existing_csv["keys"].append("_character")

		# The notes column wasn't found in the existing file but the setting is turned on
		if notes_column == -1 and DMSettings.get_setting(DMSettings.INCLUDE_NOTES_IN_TRANSLATION_EXPORTS, false):
			# Guarda en notes_column el resultado de column_count.
			notes_column = column_count
			# Suma a column_count el valor 1 respecto de su valor anterior.
			column_count += 1
			# Ejecuta esta instruccion: existing_csv["keys"].append("_notes").
			existing_csv["keys"].append("_notes")

	# Start a new file
	file = FileAccess.open(path, FileAccess.WRITE)

	# Comprueba not FileAccess.file_exists(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not FileAccess.file_exists(path):
		# Crea headings e inicializa su valor con ["keys", default_locale] + DMSettings.get_setting(DMSettings.EXTRA_CSV_LOCALES, []).
		var headings: PackedStringArray = ["keys", default_locale] + DMSettings.get_setting(DMSettings.EXTRA_CSV_LOCALES, [])
		# Comprueba DMSettings.get_setting(DMSettings.INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS, false); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if DMSettings.get_setting(DMSettings.INCLUDE_CHARACTER_IN_TRANSLATION_EXPORTS, false):
			# Guarda en character_column el resultado de headings.size().
			character_column = headings.size()
			# Llama al metodo headings.append para realizar esta accion en este punto.
			headings.append("_character")
		# Comprueba DMSettings.get_setting(DMSettings.INCLUDE_NOTES_IN_TRANSLATION_EXPORTS, false); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if DMSettings.get_setting(DMSettings.INCLUDE_NOTES_IN_TRANSLATION_EXPORTS, false):
			# Guarda en notes_column el resultado de headings.size().
			notes_column = headings.size()
			# Llama al metodo headings.append para realizar esta accion en este punto.
			headings.append("_notes")
		# Llama al metodo file.store_csv_line para realizar esta accion en este punto.
		file.store_csv_line(headings)
		# Guarda en column_count el resultado de headings.size().
		column_count = headings.size()

	# Write our translations to file
	var known_keys: PackedStringArray = []

	# Crea dialogue e inicializa su valor con DMCompiler.compile_string(code_edit.text, current_file_path).lines.
	var dialogue = DMCompiler.compile_string(code_edit.text, current_file_path).lines

	# Make a list of stuff that needs to go into the file
	var lines_to_save = []
	# Recorre dialogue.keys() y asigna cada elemento a key en cada vuelta.
	for key in dialogue.keys():
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

		# Crea line_to_save e inicializa su valor con [].
		var line_to_save: PackedStringArray = []
		# Comprueba existing_csv.has(translation_key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if existing_csv.has(translation_key):
			# Guarda en line_to_save el resultado de existing_csv.get(translation_key).
			line_to_save = existing_csv.get(translation_key)
			# Llama al metodo line_to_save.resize para realizar esta accion en este punto.
			line_to_save.resize(column_count)
			# Llama al metodo existing_csv.erase para realizar esta accion en este punto.
			existing_csv.erase(translation_key)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo line_to_save.resize para realizar esta accion en este punto.
			line_to_save.resize(column_count)
			# Ejecuta esta instruccion: line_to_save[0] = translation_key.
			line_to_save[0] = translation_key

		# Ejecuta esta instruccion: line_to_save[default_locale_column] = line.text.
		line_to_save[default_locale_column] = line.text
		# Comprueba character_column > -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if character_column > -1:
			# Ejecuta esta instruccion: line_to_save[character_column] = "(response)" if line.type == DMConstants.TYPE_RESPONSE else line.character.
			line_to_save[character_column] = "(response)" if line.type == DMConstants.TYPE_RESPONSE else line.character
		# Comprueba notes_column > -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if notes_column > -1:
			# Ejecuta esta instruccion: line_to_save[notes_column] = line.notes.
			line_to_save[notes_column] = line.notes

		# Llama al metodo lines_to_save.append para realizar esta accion en este punto.
		lines_to_save.append(line_to_save)

	# Store lines in the file, starting with anything that already exists that hasn't been touched
	for line in existing_csv.values():
		# Llama al metodo file.store_csv_line para realizar esta accion en este punto.
		file.store_csv_line(line)
	# Recorre lines_to_save y asigna cada elemento a line en cada vuelta.
	for line in lines_to_save:
		# Llama al metodo file.store_csv_line para realizar esta accion en este punto.
		file.store_csv_line(line)

	# Llama al metodo file.close para realizar esta accion en este punto.
	file.close()

	# Llama al metodo EditorInterface.get_resource_filesystem para realizar esta accion en este punto.
	EditorInterface.get_resource_filesystem().scan()
	# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
	EditorInterface.get_file_system_dock().call_deferred("navigate_to_path", path)

	# Add it to the project l10n settings if it's not already there
	var language_code: RegExMatch = RegEx.create_from_string("^[a-z]{2,3}").search(default_locale)
	# Crea translation_path e inicializa su valor con path.replace(".csv", ".%s.translation" % language_code.get_string()).
	var translation_path: String = path.replace(".csv", ".%s.translation" % language_code.get_string())
	# Llama al metodo call_deferred para realizar esta accion en este punto.
	call_deferred("add_path_to_project_translations", translation_path)


# Define el metodo export_character_names_to_csv para agrupar esta accion del script.
func export_character_names_to_csv(path: String) -> void:
	# Declara file para guardar un dato utilizado por este script.
	var file: FileAccess

	# If the file exists, open it first and work out which keys are already in it
	var existing_csv = {}
	# Crea commas e inicializa su valor con [].
	var commas = []
	# Comprueba FileAccess.file_exists(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if FileAccess.file_exists(path):
		# Guarda en file el resultado de FileAccess.open(path, FileAccess.READ).
		file = FileAccess.open(path, FileAccess.READ)
		# Crea is_first_line e inicializa su valor con true.
		var is_first_line = true
		# Declara line para guardar un dato utilizado por este script.
		var line: Array
		# Repite este bloque mientras !file.eof_reached() sea verdadero.
		while !file.eof_reached():
			# Guarda en line el resultado de file.get_csv_line().
			line = file.get_csv_line()
			# Comprueba is_first_line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if is_first_line:
				# Guarda en is_first_line el resultado de false.
				is_first_line = false
				# Recorre range(2, line.size()) y asigna cada elemento a i en cada vuelta.
				for i in range(2, line.size()):
					# Llama al metodo commas.append para realizar esta accion en este punto.
					commas.append("")
			# Make sure the line isn't empty before adding it
			if line.size() > 0 and line[0].strip_edges() != "":
				# Ejecuta esta instruccion: existing_csv[line[0]] = line.
				existing_csv[line[0]] = line

	# Start a new file
	file = FileAccess.open(path, FileAccess.WRITE)

	# Comprueba not file.file_exists(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not file.file_exists(path):
		# Llama al metodo file.store_csv_line para realizar esta accion en este punto.
		file.store_csv_line(["keys", DMSettings.get_setting(DMSettings.DEFAULT_CSV_LOCALE, "en")])

	# Write our translations to file
	var known_keys: PackedStringArray = []

	# Crea character_names e inicializa su valor con DMCompiler.compile_string(code_edit.text, current_file_path).character_names.
	var character_names: PackedStringArray = DMCompiler.compile_string(code_edit.text, current_file_path).character_names

	# Make a list of stuff that needs to go into the file
	var lines_to_save = []
	# Recorre character_names y asigna cada elemento a character_name en cada vuelta.
	for character_name in character_names:
		# Ejecuta esta instruccion: if character_name in known_keys: continue.
		if character_name in known_keys: continue

		# Llama al metodo known_keys.append para realizar esta accion en este punto.
		known_keys.append(character_name)

		# Comprueba existing_csv.has(character_name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if existing_csv.has(character_name):
			# Crea existing_line e inicializa su valor con existing_csv.get(character_name).
			var existing_line = existing_csv.get(character_name)
			# Ejecuta esta instruccion: existing_line[1] = character_name.
			existing_line[1] = character_name
			# Llama al metodo lines_to_save.append para realizar esta accion en este punto.
			lines_to_save.append(existing_line)
			# Llama al metodo existing_csv.erase para realizar esta accion en este punto.
			existing_csv.erase(character_name)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo lines_to_save.append para realizar esta accion en este punto.
			lines_to_save.append(PackedStringArray([character_name, character_name] + commas))

	# Store lines in the file, starting with anything that already exists that hasn't been touched
	for line in existing_csv.values():
		# Llama al metodo file.store_csv_line para realizar esta accion en este punto.
		file.store_csv_line(line)
	# Recorre lines_to_save y asigna cada elemento a line en cada vuelta.
	for line in lines_to_save:
		# Llama al metodo file.store_csv_line para realizar esta accion en este punto.
		file.store_csv_line(line)

	# Llama al metodo file.close para realizar esta accion en este punto.
	file.close()

	# Llama al metodo EditorInterface.get_resource_filesystem para realizar esta accion en este punto.
	EditorInterface.get_resource_filesystem().scan()
	# Llama al metodo EditorInterface.get_file_system_dock para realizar esta accion en este punto.
	EditorInterface.get_file_system_dock().call_deferred("navigate_to_path", path)

	# Add it to the project l10n settings if it's not already there
	var translation_path: String = path.replace(".csv", ".en.translation")
	# Llama al metodo call_deferred para realizar esta accion en este punto.
	call_deferred("add_path_to_project_translations", translation_path)


# Import changes back from an exported CSV by matching translation keys
func import_translations_from_csv(path: String) -> void:
	# Crea cursor e inicializa su valor con code_edit.get_cursor().
	var cursor: Vector2 = code_edit.get_cursor()

	# Ejecuta esta instruccion: if not FileAccess.file_exists(path): return.
	if not FileAccess.file_exists(path): return

	# Open the CSV file and build a dictionary of the known keys
	var keys: Dictionary = {}
	# Crea file e inicializa su valor con FileAccess.open(path, FileAccess.READ).
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	# Declara csv_line para guardar un dato utilizado por este script.
	var csv_line: Array
	# Repite este bloque mientras !file.eof_reached() sea verdadero.
	while !file.eof_reached():
		# Guarda en csv_line el resultado de file.get_csv_line().
		csv_line = file.get_csv_line()
		# Comprueba csv_line.size() > 1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if csv_line.size() > 1:
			# Ejecuta esta instruccion: keys[csv_line[0]] = csv_line[1].
			keys[csv_line[0]] = csv_line[1]

	# Now look over each line in the dialogue and replace the content for matched keys
	var lines: PackedStringArray = code_edit.text.split("\n")
	# Crea start_index e inicializa su valor con 0.
	var start_index: int = 0
	# Crea end_index e inicializa su valor con 0.
	var end_index: int = 0
	# Recorre range(0, lines.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, lines.size()):
		# Crea line e inicializa su valor con lines[i].
		var line: String = lines[i]
		# Crea translation_key e inicializa su valor con DMCompiler.get_static_line_id(line).
		var translation_key: String = DMCompiler.get_static_line_id(line)
		# Comprueba keys.has(translation_key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if keys.has(translation_key):
			# Comprueba DMCompiler.get_line_type(line) == DMConstants.TYPE_DIALOGUE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if DMCompiler.get_line_type(line) == DMConstants.TYPE_DIALOGUE:
				# Guarda en start_index el resultado de 0.
				start_index = 0
				# See if we need to skip over a character name
				line = line.replace("\\:", "!ESCAPED_COLON!")
				# Comprueba ": " in line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if ": " in line:
					# Guarda en start_index el resultado de line.find(": ") + 2.
					start_index = line.find(": ") + 2
				# Ejecuta esta instruccion: lines[i] = (line.substr(0, start_index) + keys.get(translation_key) + " [ID:" + translation_key + "]").replace("!ESCAPED_COLON!", ":").
				lines[i] = (line.substr(0, start_index) + keys.get(translation_key) + " [ID:" + translation_key + "]").replace("!ESCAPED_COLON!", ":")

			# Comprueba DMCompiler.get_line_type(line) == DMConstants.TYPE_RESPONSE si las condiciones anteriores resultaron falsas.
			elif DMCompiler.get_line_type(line) == DMConstants.TYPE_RESPONSE:
				# Guarda en start_index el resultado de line.find("- ") + 2.
				start_index = line.find("- ") + 2
				# See if we need to skip over a character name
				line = line.replace("\\:", "!ESCAPED_COLON!")
				# Comprueba ": " in line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if ": " in line:
					# Guarda en start_index el resultado de line.find(": ") + 2.
					start_index = line.find(": ") + 2
				# Guarda en end_index el resultado de line.length().
				end_index = line.length()
				# Comprueba " =>" in line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if " =>" in line:
					# Guarda en end_index el resultado de line.find(" =>").
					end_index = line.find(" =>")
				# Comprueba " [if " in line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if " [if " in line:
					# Guarda en end_index el resultado de line.find(" [if ").
					end_index = line.find(" [if ")
				# Ejecuta esta instruccion: lines[i] = (line.substr(0, start_index) + keys.get(translation_key) + " [ID:" + translation_key + "]" + line.substr(end_index)).replace("!ESCAPED_COLON!", ":").
				lines[i] = (line.substr(0, start_index) + keys.get(translation_key) + " [ID:" + translation_key + "]" + line.substr(end_index)).replace("!ESCAPED_COLON!", ":")

	# Guarda en code_edit.text el resultado de "\n".join(lines).
	code_edit.text = "\n".join(lines)
	# Llama al metodo code_edit.set_cursor para realizar esta accion en este punto.
	code_edit.set_cursor(cursor)


# Define el metodo show_search_form para agrupar esta accion del script.
func show_search_form(is_enabled: bool) -> void:
	# Comprueba code_edit.last_selected_text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if code_edit.last_selected_text:
		# Guarda en search_and_replace.input.text el resultado de code_edit.last_selected_text.
		search_and_replace.input.text = code_edit.last_selected_text

	# Guarda en search_and_replace.visible el resultado de is_enabled.
	search_and_replace.visible = is_enabled
	# Llama al metodo search_button.set_pressed_no_signal para realizar esta accion en este punto.
	search_button.set_pressed_no_signal(is_enabled)
	# Llama al metodo search_and_replace.focus_line_edit para realizar esta accion en este punto.
	search_and_replace.focus_line_edit()


### Signals


# Define el metodo _on_files_moved para agrupar esta accion del script.
func _on_files_moved(old_file: String, new_file: String) -> void:
	# Comprueba open_buffers.has(old_file); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if open_buffers.has(old_file):
		# Ejecuta esta instruccion: open_buffers[new_file] = open_buffers[old_file].
		open_buffers[new_file] = open_buffers[old_file]
		# Llama al metodo open_buffers.erase para realizar esta accion en este punto.
		open_buffers.erase(old_file)
		# Ejecuta esta instruccion: open_buffers[new_file].
		open_buffers[new_file]


# Define el metodo _on_cache_file_content_changed para agrupar esta accion del script.
func _on_cache_file_content_changed(path: String, new_content: String) -> void:
	# Comprueba open_buffers.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if open_buffers.has(path):
		# Crea buffer e inicializa su valor con open_buffers[path].
		var buffer = open_buffers[path]
		# Comprueba buffer.text == buffer.pristine_text and buffer.text != new_content; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if buffer.text == buffer.pristine_text and buffer.text != new_content:
			# Guarda en buffer.text el resultado de new_content.
			buffer.text = new_content
			# Guarda en code_edit.text el resultado de new_content.
			code_edit.text = new_content
			# Guarda en title_list.titles el resultado de code_edit.get_titles().
			title_list.titles = code_edit.get_titles()
		# Guarda en buffer.pristine_text el resultado de new_content.
		buffer.pristine_text = new_content


# Define el metodo _on_editor_settings_changed para agrupar esta accion del script.
func _on_editor_settings_changed() -> void:
	# Crea editor_settings e inicializa su valor con EditorInterface.get_editor_settings().
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	# Guarda en code_edit.minimap_draw el resultado de editor_settings.get_setting("text_editor/appearance/minimap/show_minimap").
	code_edit.minimap_draw = editor_settings.get_setting("text_editor/appearance/minimap/show_minimap")
	# Guarda en code_edit.minimap_width el resultado de editor_settings.get_setting("text_editor/appearance/minimap/minimap_width").
	code_edit.minimap_width = editor_settings.get_setting("text_editor/appearance/minimap/minimap_width")
	# Guarda en code_edit.scroll_smooth el resultado de editor_settings.get_setting("text_editor/behavior/navigation/smooth_scrolling").
	code_edit.scroll_smooth = editor_settings.get_setting("text_editor/behavior/navigation/smooth_scrolling")


# Define el metodo _on_open_menu_id_pressed para agrupar esta accion del script.
func _on_open_menu_id_pressed(id: int) -> void:
	# Compara id con los casos siguientes y ejecuta el que coincida.
	match id:
		# Asocia la clave OPEN_OPEN con  dentro del diccionario.
		OPEN_OPEN:
			# Llama al metodo open_dialog.popup_centered para realizar esta accion en este punto.
			open_dialog.popup_centered()
		# Asocia la clave OPEN_QUICK con  dentro del diccionario.
		OPEN_QUICK:
			# Guarda en quick_open_files_list.files el resultado de Engine.get_meta("DMCache").get_files().
			quick_open_files_list.files = Engine.get_meta("DMCache").get_files()
			# Llama al metodo quick_open_dialog.popup_centered para realizar esta accion en este punto.
			quick_open_dialog.popup_centered()
			# Llama al metodo quick_open_files_list.focus_filter para realizar esta accion en este punto.
			quick_open_files_list.focus_filter()
		# Asocia la clave OPEN_CLEAR con  dentro del diccionario.
		OPEN_CLEAR:
			# Llama al metodo DMSettings.clear_recent_files para realizar esta accion en este punto.
			DMSettings.clear_recent_files()
			# Llama al metodo build_open_menu para realizar esta accion en este punto.
			build_open_menu()
		# Asocia la clave _ con  dentro del diccionario.
		_:
			# Crea menu e inicializa su valor con open_button.get_popup().
			var menu = open_button.get_popup()
			# Crea item e inicializa su valor con menu.get_item_text(menu.get_item_index(id)).
			var item = menu.get_item_text(menu.get_item_index(id))
			# Llama al metodo open_file para realizar esta accion en este punto.
			open_file(item)


# Define el metodo _on_files_list_file_selected para agrupar esta accion del script.
func _on_files_list_file_selected(file_path: String) -> void:
	# Guarda en self.current_file_path el resultado de file_path.
	self.current_file_path = file_path


# Define el metodo _on_insert_button_menu_id_pressed para agrupar esta accion del script.
func _on_insert_button_menu_id_pressed(id: int) -> void:
	# Compara id con los casos siguientes y ejecuta el que coincida.
	match id:
		# Asocia la clave 0 con  dentro del diccionario.
		0:
			# Llama al metodo code_edit.insert_bbcode para realizar esta accion en este punto.
			code_edit.insert_bbcode("[wave amp=25 freq=5]", "[/wave]")
		# Asocia la clave 1 con  dentro del diccionario.
		1:
			# Llama al metodo code_edit.insert_bbcode para realizar esta accion en este punto.
			code_edit.insert_bbcode("[shake rate=20 level=10]", "[/shake]")
		# Asocia la clave 3 con  dentro del diccionario.
		3:
			# Llama al metodo code_edit.insert_bbcode para realizar esta accion en este punto.
			code_edit.insert_bbcode("[wait=1]")
		# Asocia la clave 4 con  dentro del diccionario.
		4:
			# Llama al metodo code_edit.insert_bbcode para realizar esta accion en este punto.
			code_edit.insert_bbcode("[speed=0.2]")
		# Asocia la clave 5 con  dentro del diccionario.
		5:
			# Llama al metodo code_edit.insert_bbcode para realizar esta accion en este punto.
			code_edit.insert_bbcode("[next=auto]")
		# Asocia la clave 6 con  dentro del diccionario.
		6:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("~ title")
		# Asocia la clave 7 con  dentro del diccionario.
		7:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("Nathan: This is Some Dialogue")
		# Asocia la clave 8 con  dentro del diccionario.
		8:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("Nathan: Choose a Response...\n- Option 1\n\tNathan: You chose option 1\n- Option 2\n\tNathan: You chose option 2")
		# Asocia la clave 9 con  dentro del diccionario.
		9:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("% Nathan: This is random line 1.\n% Nathan: This is random line 2.\n%1 Nathan: This is weighted random line 3.")
		# Asocia la clave 10 con  dentro del diccionario.
		10:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("Nathan: [[Hi|Hello|Howdy]]")
		# Asocia la clave 11 con  dentro del diccionario.
		11:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("=> title")
		# Asocia la clave 12 con  dentro del diccionario.
		12:
			# Llama al metodo code_edit.insert_text_at_cursor para realizar esta accion en este punto.
			code_edit.insert_text_at_cursor("=> END")


# Define el metodo _on_translations_button_menu_id_pressed para agrupar esta accion del script.
func _on_translations_button_menu_id_pressed(id: int) -> void:
	# Compara id con los casos siguientes y ejecuta el que coincida.
	match id:
		# Asocia la clave TRANSLATIONS_GENERATE_LINE_IDS con  dentro del diccionario.
		TRANSLATIONS_GENERATE_LINE_IDS:
			# Llama al metodo generate_translations_keys para realizar esta accion en este punto.
			generate_translations_keys()

		# Asocia la clave TRANSLATIONS_SAVE_CHARACTERS_TO_CSV con  dentro del diccionario.
		TRANSLATIONS_SAVE_CHARACTERS_TO_CSV:
			# Guarda en translation_source el resultado de TranslationSource.CharacterNames.
			translation_source = TranslationSource.CharacterNames
			# Guarda en export_dialog.filters el resultado de PackedStringArray(["*.csv ; Translation CSV"]).
			export_dialog.filters = PackedStringArray(["*.csv ; Translation CSV"])
			# Guarda en export_dialog.current_path el resultado de get_last_export_path("csv").
			export_dialog.current_path = get_last_export_path("csv")
			# Llama al metodo export_dialog.popup_centered para realizar esta accion en este punto.
			export_dialog.popup_centered()

		# Asocia la clave TRANSLATIONS_SAVE_TO_CSV con  dentro del diccionario.
		TRANSLATIONS_SAVE_TO_CSV:
			# Guarda en translation_source el resultado de TranslationSource.Lines.
			translation_source = TranslationSource.Lines
			# Guarda en export_dialog.filters el resultado de PackedStringArray(["*.csv ; Translation CSV"]).
			export_dialog.filters = PackedStringArray(["*.csv ; Translation CSV"])
			# Guarda en export_dialog.current_path el resultado de get_last_export_path("csv").
			export_dialog.current_path = get_last_export_path("csv")
			# Llama al metodo export_dialog.popup_centered para realizar esta accion en este punto.
			export_dialog.popup_centered()

		# Asocia la clave TRANSLATIONS_IMPORT_FROM_CSV con  dentro del diccionario.
		TRANSLATIONS_IMPORT_FROM_CSV:
			# Guarda en import_dialog.current_path el resultado de get_last_export_path("csv").
			import_dialog.current_path = get_last_export_path("csv")
			# Llama al metodo import_dialog.popup_centered para realizar esta accion en este punto.
			import_dialog.popup_centered()


# Define el metodo _on_export_dialog_file_selected para agrupar esta accion del script.
func _on_export_dialog_file_selected(path: String) -> void:
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("last_export_path", path.get_base_dir())
	# Compara path.get_extension() con los casos siguientes y ejecuta el que coincida.
	match path.get_extension():
		# Asocia la clave "csv" con  dentro del diccionario.
		"csv":
			# Compara translation_source con los casos siguientes y ejecuta el que coincida.
			match translation_source:
				# Ejecuta esta instruccion: TranslationSource.CharacterNames:.
				TranslationSource.CharacterNames:
					# Llama al metodo export_character_names_to_csv para realizar esta accion en este punto.
					export_character_names_to_csv(path)
				# Ejecuta esta instruccion: TranslationSource.Lines:.
				TranslationSource.Lines:
					# Llama al metodo export_translations_to_csv para realizar esta accion en este punto.
					export_translations_to_csv(path)


# Define el metodo _on_import_dialog_file_selected para agrupar esta accion del script.
func _on_import_dialog_file_selected(path: String) -> void:
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("last_export_path", path.get_base_dir())
	# Llama al metodo import_translations_from_csv para realizar esta accion en este punto.
	import_translations_from_csv(path)


# Define el metodo _on_main_view_theme_changed para agrupar esta accion del script.
func _on_main_view_theme_changed():
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()


# Define el metodo _on_main_view_visibility_changed para agrupar esta accion del script.
func _on_main_view_visibility_changed() -> void:
	# Comprueba visible and is_instance_valid(code_edit); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if visible and is_instance_valid(code_edit):
		# Llama al metodo code_edit.grab_focus para realizar esta accion en este punto.
		code_edit.grab_focus()


# Define el metodo _on_new_button_pressed para agrupar esta accion del script.
func _on_new_button_pressed() -> void:
	# Guarda en new_dialog.current_file el resultado de "dialogue".
	new_dialog.current_file = "dialogue"
	# Llama al metodo new_dialog.popup_centered para realizar esta accion en este punto.
	new_dialog.popup_centered()


# Define el metodo _on_new_dialog_confirmed para agrupar esta accion del script.
func _on_new_dialog_confirmed() -> void:
	# Comprueba new_dialog.current_file.get_basename() == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if new_dialog.current_file.get_basename() == "":
		# Crea path e inicializa su valor con "res://untitled.dialogue".
		var path = "res://untitled.dialogue"
		# Llama al metodo new_file para realizar esta accion en este punto.
		new_file(path)
		# Llama al metodo open_file para realizar esta accion en este punto.
		open_file(path)


# Define el metodo _on_new_dialog_file_selected para agrupar esta accion del script.
func _on_new_dialog_file_selected(path: String) -> void:
	# Llama al metodo new_file para realizar esta accion en este punto.
	new_file(path)
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(path)


# Define el metodo _on_save_dialog_file_selected para agrupar esta accion del script.
func _on_save_dialog_file_selected(path: String) -> void:
	# Ejecuta esta instruccion: if path == "": path = "res://untitled.dialogue".
	if path == "": path = "res://untitled.dialogue"

	# Llama al metodo new_file para realizar esta accion en este punto.
	new_file(path, code_edit.text)
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(path)


# Define el metodo _on_open_button_about_to_popup para agrupar esta accion del script.
func _on_open_button_about_to_popup() -> void:
	# Llama al metodo build_open_menu para realizar esta accion en este punto.
	build_open_menu()


# Define el metodo _on_open_dialog_file_selected para agrupar esta accion del script.
func _on_open_dialog_file_selected(path: String) -> void:
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(path)


# Define el metodo _on_quick_open_files_list_file_double_clicked para agrupar esta accion del script.
func _on_quick_open_files_list_file_double_clicked(file_path: String) -> void:
	# Llama al metodo quick_open_dialog.hide para realizar esta accion en este punto.
	quick_open_dialog.hide()
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(file_path)


# Define el metodo _on_quick_open_dialog_confirmed para agrupar esta accion del script.
func _on_quick_open_dialog_confirmed() -> void:
	# Comprueba quick_open_files_list.current_file_path; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if quick_open_files_list.current_file_path:
		# Llama al metodo open_file para realizar esta accion en este punto.
		open_file(quick_open_files_list.current_file_path)


# Define el metodo _on_save_all_button_pressed para agrupar esta accion del script.
func _on_save_all_button_pressed() -> void:
	# Llama al metodo save_files para realizar esta accion en este punto.
	save_files()


# Define el metodo _on_find_in_files_button_pressed para agrupar esta accion del script.
func _on_find_in_files_button_pressed() -> void:
	# Llama al metodo find_in_files_dialog.popup_centered para realizar esta accion en este punto.
	find_in_files_dialog.popup_centered()
	# Llama al metodo find_in_files.prepare para realizar esta accion en este punto.
	find_in_files.prepare()


# Define el metodo _on_code_edit_text_changed para agrupar esta accion del script.
func _on_code_edit_text_changed() -> void:
	# Crea buffer e inicializa su valor con open_buffers[current_file_path].
	var buffer = open_buffers[current_file_path]
	# Guarda en buffer.text el resultado de code_edit.text.
	buffer.text = code_edit.text

	# Llama al metodo files_list.mark_file_as_unsaved para realizar esta accion en este punto.
	files_list.mark_file_as_unsaved(current_file_path, buffer.text != buffer.pristine_text)
	# Guarda en save_all_button.disabled el resultado de open_buffers.values().filter(func(d): return d.text != d.pristine_text).size() == 0.
	save_all_button.disabled = open_buffers.values().filter(func(d): return d.text != d.pristine_text).size() == 0

	# Llama al metodo parse_timer.start para realizar esta accion en este punto.
	parse_timer.start(1)


# Define el metodo _on_code_edit_scroll_changed para agrupar esta accion del script.
func _on_code_edit_scroll_changed(value: int) -> void:
	# Llama al metodo DMSettings.set_scroll para realizar esta accion en este punto.
	DMSettings.set_scroll(current_file_path, code_edit.scroll_vertical)


# Define el metodo _on_code_edit_active_title_change para agrupar esta accion del script.
func _on_code_edit_active_title_change(title: String) -> void:
	# Llama al metodo title_list.select_title para realizar esta accion en este punto.
	title_list.select_title(title)


# Define el metodo _on_code_edit_caret_changed para agrupar esta accion del script.
func _on_code_edit_caret_changed() -> void:
	# Llama al metodo DMSettings.set_caret para realizar esta accion en este punto.
	DMSettings.set_caret(current_file_path, code_edit.get_cursor())


# Define el metodo _on_code_edit_error_clicked para agrupar esta accion del script.
func _on_code_edit_error_clicked(line_number: int) -> void:
	# Llama al metodo errors_panel.show_error_for_line_number para realizar esta accion en este punto.
	errors_panel.show_error_for_line_number(line_number)


# Define el metodo _on_title_list_title_selected para agrupar esta accion del script.
func _on_title_list_title_selected(title: String) -> void:
	# Llama al metodo code_edit.go_to_title para realizar esta accion en este punto.
	code_edit.go_to_title(title)
	# Llama al metodo code_edit.grab_focus para realizar esta accion en este punto.
	code_edit.grab_focus()


# Define el metodo _on_parse_timer_timeout para agrupar esta accion del script.
func _on_parse_timer_timeout() -> void:
	# Llama al metodo parse_timer.stop para realizar esta accion en este punto.
	parse_timer.stop()
	# Llama al metodo compile para realizar esta accion en este punto.
	compile()


# Define el metodo _on_errors_panel_error_pressed para agrupar esta accion del script.
func _on_errors_panel_error_pressed(line_number: int, column_number: int) -> void:
	# Llama al metodo code_edit.set_caret_line para realizar esta accion en este punto.
	code_edit.set_caret_line(line_number - 1)
	# Llama al metodo code_edit.set_caret_column para realizar esta accion en este punto.
	code_edit.set_caret_column(column_number)
	# Llama al metodo code_edit.grab_focus para realizar esta accion en este punto.
	code_edit.grab_focus()


# Define el metodo _on_search_button_toggled para agrupar esta accion del script.
func _on_search_button_toggled(button_pressed: bool) -> void:
	# Llama al metodo show_search_form para realizar esta accion en este punto.
	show_search_form(button_pressed)


# Define el metodo _on_search_and_replace_open_requested para agrupar esta accion del script.
func _on_search_and_replace_open_requested() -> void:
	# Llama al metodo show_search_form para realizar esta accion en este punto.
	show_search_form(true)


# Define el metodo _on_search_and_replace_close_requested para agrupar esta accion del script.
func _on_search_and_replace_close_requested() -> void:
	# Llama al metodo search_button.set_pressed_no_signal para realizar esta accion en este punto.
	search_button.set_pressed_no_signal(false)
	# Guarda en search_and_replace.visible el resultado de false.
	search_and_replace.visible = false
	# Llama al metodo code_edit.grab_focus para realizar esta accion en este punto.
	code_edit.grab_focus()


# Define el metodo _on_test_button_pressed para agrupar esta accion del script.
func _on_test_button_pressed() -> void:
	# Llama al metodo save_file para realizar esta accion en este punto.
	save_file(current_file_path, false)
	# Llama al metodo Engine.get_meta para realizar esta accion en este punto.
	Engine.get_meta("DMCache").reimport_files([current_file_path])

	# Comprueba errors_panel.errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if errors_panel.errors.size() > 0:
		# Llama al metodo errors_dialog.popup_centered para realizar esta accion en este punto.
		errors_dialog.popup_centered()
		# Termina el metodo sin devolver un valor.
		return

	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("run_title", "")
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("is_running_test_scene", true)
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("run_resource_path", current_file_path)
	# Crea test_scene_path e inicializa su valor con DMSettings.get_setting(DMSettings.CUSTOM_TEST_SCENE_PATH, "res://addons/dialogue_manager/test_scene.tscn").
	var test_scene_path: String = DMSettings.get_setting(DMSettings.CUSTOM_TEST_SCENE_PATH, "res://addons/dialogue_manager/test_scene.tscn")
	# Llama al metodo EditorInterface.play_custom_scene para realizar esta accion en este punto.
	EditorInterface.play_custom_scene(test_scene_path)


# Define el metodo _on_test_line_button_pressed para agrupar esta accion del script.
func _on_test_line_button_pressed() -> void:
	# Llama al metodo save_file para realizar esta accion en este punto.
	save_file(current_file_path)

	# Comprueba errors_panel.errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if errors_panel.errors.size() > 0:
		# Llama al metodo errors_dialog.popup_centered para realizar esta accion en este punto.
		errors_dialog.popup_centered()
		# Termina el metodo sin devolver un valor.
		return

	# Find next non-empty line
	var line_to_run: int = 0
	# Recorre range(code_edit.get_cursor().y, code_edit.get_line_count()) y asigna cada elemento a i en cada vuelta.
	for i in range(code_edit.get_cursor().y, code_edit.get_line_count()):
		# Comprueba not code_edit.get_line(i).is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not code_edit.get_line(i).is_empty():
			# Guarda en line_to_run el resultado de i.
			line_to_run = i
			# Termina inmediatamente el bucle actual.
			break;
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("run_title", str(line_to_run))
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("is_running_test_scene", true)
	# Llama al metodo DMSettings.set_user_value para realizar esta accion en este punto.
	DMSettings.set_user_value("run_resource_path", current_file_path)
	# Crea test_scene_path e inicializa su valor con DMSettings.get_setting(DMSettings.CUSTOM_TEST_SCENE_PATH, "res://addons/dialogue_manager/test_scene.tscn").
	var test_scene_path: String = DMSettings.get_setting(DMSettings.CUSTOM_TEST_SCENE_PATH, "res://addons/dialogue_manager/test_scene.tscn")
	# Llama al metodo EditorInterface.play_custom_scene para realizar esta accion en este punto.
	EditorInterface.play_custom_scene(test_scene_path)


# Define el metodo _on_support_button_pressed para agrupar esta accion del script.
func _on_support_button_pressed() -> void:
	# Llama al metodo OS.shell_open para realizar esta accion en este punto.
	OS.shell_open("https://patreon.com/nathanhoad")


# Define el metodo _on_docs_button_pressed para agrupar esta accion del script.
func _on_docs_button_pressed() -> void:
	# Llama al metodo OS.shell_open para realizar esta accion en este punto.
	OS.shell_open("https://github.com/nathanhoad/godot_dialogue_manager")


# Define el metodo _on_files_list_file_popup_menu_requested para agrupar esta accion del script.
func _on_files_list_file_popup_menu_requested(at_position: Vector2) -> void:
	# Guarda en files_popup_menu.position el resultado de Vector2(get_viewport().position) + files_list.global_position + at_position.
	files_popup_menu.position = Vector2(get_viewport().position) + files_list.global_position + at_position
	# Llama al metodo files_popup_menu.popup para realizar esta accion en este punto.
	files_popup_menu.popup()


# Define el metodo _on_files_list_file_middle_clicked para agrupar esta accion del script.
func _on_files_list_file_middle_clicked(path: String):
	# Llama al metodo close_file para realizar esta accion en este punto.
	close_file(path)


# Define el metodo _on_files_popup_menu_about_to_popup para agrupar esta accion del script.
func _on_files_popup_menu_about_to_popup() -> void:
	# Llama al metodo files_popup_menu.clear para realizar esta accion en este punto.
	files_popup_menu.clear()

	# Crea shortcuts e inicializa su valor con plugin.get_editor_shortcuts().
	var shortcuts: Dictionary = plugin.get_editor_shortcuts()

	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.save"), ITEM_SAVE, OS.find_keycode_from_string(shortcuts.get("save")[0].as_text_keycode()))
	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.save_as"), ITEM_SAVE_AS)
	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.close"), ITEM_CLOSE, OS.find_keycode_from_string(shortcuts.get("close_file")[0].as_text_keycode()))
	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.close_all"), ITEM_CLOSE_ALL)
	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.close_other_files"), ITEM_CLOSE_OTHERS)
	# Llama al metodo files_popup_menu.add_separator para realizar esta accion en este punto.
	files_popup_menu.add_separator()
	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.copy_file_path"), ITEM_COPY_PATH)
	# Llama al metodo files_popup_menu.add_item para realizar esta accion en este punto.
	files_popup_menu.add_item(DMConstants.translate(&"buffer.show_in_filesystem"), ITEM_SHOW_IN_FILESYSTEM)


# Define el metodo _on_files_popup_menu_id_pressed para agrupar esta accion del script.
func _on_files_popup_menu_id_pressed(id: int) -> void:
	# Compara id con los casos siguientes y ejecuta el que coincida.
	match id:
		# Asocia la clave ITEM_SAVE con  dentro del diccionario.
		ITEM_SAVE:
			# Llama al metodo save_file para realizar esta accion en este punto.
			save_file(current_file_path)
		# Asocia la clave ITEM_SAVE_AS con  dentro del diccionario.
		ITEM_SAVE_AS:
			# Llama al metodo save_dialog.popup_centered para realizar esta accion en este punto.
			save_dialog.popup_centered()
		# Asocia la clave ITEM_CLOSE con  dentro del diccionario.
		ITEM_CLOSE:
			# Llama al metodo close_file para realizar esta accion en este punto.
			close_file(current_file_path)
		# Asocia la clave ITEM_CLOSE_ALL con  dentro del diccionario.
		ITEM_CLOSE_ALL:
			# Recorre open_buffers.keys() y asigna cada elemento a path en cada vuelta.
			for path in open_buffers.keys():
				# Llama al metodo close_file para realizar esta accion en este punto.
				close_file(path)
		# Asocia la clave ITEM_CLOSE_OTHERS con  dentro del diccionario.
		ITEM_CLOSE_OTHERS:
			# Crea current_current_file_path e inicializa su valor con current_file_path.
			var current_current_file_path: String = current_file_path
			# Recorre open_buffers.keys() y asigna cada elemento a path en cada vuelta.
			for path in open_buffers.keys():
				# Comprueba path != current_current_file_path; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if path != current_current_file_path:
					# Espera a que termine close_file(path) antes de continuar.
					await close_file(path)

		# Asocia la clave ITEM_COPY_PATH con  dentro del diccionario.
		ITEM_COPY_PATH:
			# Llama al metodo DisplayServer.clipboard_set para realizar esta accion en este punto.
			DisplayServer.clipboard_set(current_file_path)
		# Asocia la clave ITEM_SHOW_IN_FILESYSTEM con  dentro del diccionario.
		ITEM_SHOW_IN_FILESYSTEM:
			# Llama al metodo show_file_in_filesystem para realizar esta accion en este punto.
			show_file_in_filesystem(current_file_path)


# Define el metodo _on_code_edit_external_file_requested para agrupar esta accion del script.
func _on_code_edit_external_file_requested(path: String, title: String) -> void:
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(path)
	# Comprueba title != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if title != "":
		# Llama al metodo code_edit.go_to_title para realizar esta accion en este punto.
		code_edit.go_to_title(title)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo code_edit.set_caret_line para realizar esta accion en este punto.
		code_edit.set_caret_line(0)


# Define el metodo _on_close_confirmation_dialog_confirmed para agrupar esta accion del script.
func _on_close_confirmation_dialog_confirmed() -> void:
	# Llama al metodo save_file para realizar esta accion en este punto.
	save_file(current_file_path)
	# Llama al metodo remove_file_from_open_buffers para realizar esta accion en este punto.
	remove_file_from_open_buffers(current_file_path)
	# Emite la senal confirmation_closed con estos datos: ninguno.
	confirmation_closed.emit()


# Define el metodo _on_close_confirmation_dialog_custom_action para agrupar esta accion del script.
func _on_close_confirmation_dialog_custom_action(action: StringName) -> void:
	# Comprueba action == "discard"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if action == "discard":
		# Llama al metodo remove_file_from_open_buffers para realizar esta accion en este punto.
		remove_file_from_open_buffers(current_file_path)
	# Llama al metodo close_confirmation_dialog.hide para realizar esta accion en este punto.
	close_confirmation_dialog.hide()
	# Emite la senal confirmation_closed con estos datos: ninguno.
	confirmation_closed.emit()


# Define el metodo _on_find_in_files_result_selected para agrupar esta accion del script.
func _on_find_in_files_result_selected(path: String, cursor: Vector2, length: int) -> void:
	# Llama al metodo open_file para realizar esta accion en este punto.
	open_file(path)
	# Llama al metodo code_edit.select para realizar esta accion en este punto.
	code_edit.select(cursor.y, cursor.x, cursor.y, cursor.x + length)
	# Llama al metodo code_edit.set_line_as_center_visible para realizar esta accion en este punto.
	code_edit.set_line_as_center_visible(cursor.y)
