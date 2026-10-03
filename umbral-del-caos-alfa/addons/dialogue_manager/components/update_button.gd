# Ejecuta esta instruccion: @tool.
@tool
# Hereda de Button y reutiliza sus propiedades y comportamiento base.
extends Button

# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")
# Define DialogueSettings con el valor fijo preload("../settings.gd").
const DialogueSettings = preload("../settings.gd")

# Define REMOTE_RELEASES_URL con el valor fijo "https://api.github.com/repos/nathanhoad/godot_dialogue_manager/releases".
const REMOTE_RELEASES_URL = "https://api.github.com/repos/nathanhoad/godot_dialogue_manager/releases"


# Obtiene la referencia http_request cuando el nodo ya esta listo.
@onready var http_request: HTTPRequest = $HTTPRequest
# Obtiene la referencia download_dialog cuando el nodo ya esta listo.
@onready var download_dialog: AcceptDialog = $DownloadDialog
# Obtiene la referencia download_update_panel cuando el nodo ya esta listo.
@onready var download_update_panel = $DownloadDialog/DownloadUpdatePanel
# Obtiene la referencia needs_reload_dialog cuando el nodo ya esta listo.
@onready var needs_reload_dialog: AcceptDialog = $NeedsReloadDialog
# Obtiene la referencia update_failed_dialog cuando el nodo ya esta listo.
@onready var update_failed_dialog: AcceptDialog = $UpdateFailedDialog
# Obtiene la referencia timer cuando el nodo ya esta listo.
@onready var timer: Timer = $Timer

# Crea needs_reload e inicializa su valor con false.
var needs_reload: bool = false

# A lambda that gets called just before refreshing the plugin. Return false to stop the reload.
var on_before_refresh: Callable = func(): return true


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Llama al metodo hide para realizar esta accion en este punto.
	hide()
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()

	# Check for updates on GitHub
	check_for_update()

	# Check again every few hours
	timer.start(60 * 60 * 12)


# Convert a version number to an actually comparable number
func version_to_number(version: String) -> int:
	# Crea bits e inicializa su valor con version.split(".").
	var bits = version.split(".")
	# Termina el metodo y devuelve bits[0].to_int() * 1000000 + bits[1].to_int() * 1000 + bits[2].to_int() a quien lo llamo.
	return bits[0].to_int() * 1000000 + bits[1].to_int() * 1000 + bits[2].to_int()


# Define el metodo apply_theme para agrupar esta accion del script.
func apply_theme() -> void:
	# Crea color e inicializa su valor con get_theme_color("success_color", "Editor").
	var color: Color = get_theme_color("success_color", "Editor")

	# Comprueba needs_reload; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if needs_reload:
		# Guarda en color el resultado de get_theme_color("error_color", "Editor").
		color = get_theme_color("error_color", "Editor")
		# Guarda en icon el resultado de get_theme_icon("Reload", "EditorIcons").
		icon = get_theme_icon("Reload", "EditorIcons")
		# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
		add_theme_color_override("icon_normal_color", color)
		# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
		add_theme_color_override("icon_focus_color", color)
		# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
		add_theme_color_override("icon_hover_color", color)

	# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
	add_theme_color_override("font_color", color)
	# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
	add_theme_color_override("font_focus_color", color)
	# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
	add_theme_color_override("font_hover_color", color)


# Define el metodo check_for_update para agrupar esta accion del script.
func check_for_update() -> void:
	# Comprueba DialogueSettings.get_user_value("check_for_updates", true); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if DialogueSettings.get_user_value("check_for_updates", true):
		# Llama al metodo http_request.request para realizar esta accion en este punto.
		http_request.request(REMOTE_RELEASES_URL)


### Signals


# Define el metodo _on_http_request_request_completed para agrupar esta accion del script.
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# Ejecuta esta instruccion: if result != HTTPRequest.RESULT_SUCCESS: return.
	if result != HTTPRequest.RESULT_SUCCESS: return

	# Crea current_version e inicializa su valor con Engine.get_meta("DialogueManagerPlugin").get_version().
	var current_version: String = Engine.get_meta("DialogueManagerPlugin").get_version()

	# Work out the next version from the releases information on GitHub
	var response = JSON.parse_string(body.get_string_from_utf8())
	# Ejecuta esta instruccion: if typeof(response) != TYPE_ARRAY: return.
	if typeof(response) != TYPE_ARRAY: return

	# GitHub releases are in order of creation, not order of version
	var versions = (response as Array).filter(func(release):
		# Crea version e inicializa su valor con release.tag_name.substr(1).
		var version: String = release.tag_name.substr(1)
		# Crea major_version e inicializa su valor con version.split(".")[0].to_int().
		var major_version: int = version.split(".")[0].to_int()
		# Crea current_major_version e inicializa su valor con current_version.split(".")[0].to_int().
		var current_major_version: int = current_version.split(".")[0].to_int()
		# Termina el metodo y devuelve major_version == current_major_version and version_to_number(version) > version_to_number(current_version) a quien lo llamo.
		return major_version == current_major_version and version_to_number(version) > version_to_number(current_version)
	)
	# Comprueba versions.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if versions.size() > 0:
		# Guarda en download_update_panel.next_version_release el resultado de versions[0].
		download_update_panel.next_version_release = versions[0]
		# Guarda en text el resultado de DialogueConstants.translate(&"update.available").format({ version = versions[0].tag_name.substr(1) }).
		text = DialogueConstants.translate(&"update.available").format({ version = versions[0].tag_name.substr(1) })
		# Llama al metodo show para realizar esta accion en este punto.
		show()


# Define el metodo _on_update_button_pressed para agrupar esta accion del script.
func _on_update_button_pressed() -> void:
	# Comprueba needs_reload; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if needs_reload:
		# Crea will_refresh e inicializa su valor con on_before_refresh.call().
		var will_refresh = on_before_refresh.call()
		# Comprueba will_refresh; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if will_refresh:
			# Llama al metodo EditorInterface.restart_editor para realizar esta accion en este punto.
			EditorInterface.restart_editor(true)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Crea scale e inicializa su valor con EditorInterface.get_editor_scale().
		var scale: float = EditorInterface.get_editor_scale()
		# Guarda en download_dialog.min_size el resultado de Vector2(300, 250) * scale.
		download_dialog.min_size = Vector2(300, 250) * scale
		# Llama al metodo download_dialog.popup_centered para realizar esta accion en este punto.
		download_dialog.popup_centered()


# Define el metodo _on_download_dialog_close_requested para agrupar esta accion del script.
func _on_download_dialog_close_requested() -> void:
	# Llama al metodo download_dialog.hide para realizar esta accion en este punto.
	download_dialog.hide()


# Define el metodo _on_download_update_panel_updated para agrupar esta accion del script.
func _on_download_update_panel_updated(updated_to_version: String) -> void:
	# Llama al metodo download_dialog.hide para realizar esta accion en este punto.
	download_dialog.hide()

	# Guarda en needs_reload_dialog.dialog_text el resultado de DialogueConstants.translate(&"update.needs_reload").
	needs_reload_dialog.dialog_text = DialogueConstants.translate(&"update.needs_reload")
	# Guarda en needs_reload_dialog.ok_button_text el resultado de DialogueConstants.translate(&"update.reload_ok_button").
	needs_reload_dialog.ok_button_text = DialogueConstants.translate(&"update.reload_ok_button")
	# Guarda en needs_reload_dialog.cancel_button_text el resultado de DialogueConstants.translate(&"update.reload_cancel_button").
	needs_reload_dialog.cancel_button_text = DialogueConstants.translate(&"update.reload_cancel_button")
	# Llama al metodo needs_reload_dialog.popup_centered para realizar esta accion en este punto.
	needs_reload_dialog.popup_centered()

	# Guarda en needs_reload el resultado de true.
	needs_reload = true
	# Guarda en text el resultado de DialogueConstants.translate(&"update.reload_project").
	text = DialogueConstants.translate(&"update.reload_project")
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()


# Define el metodo _on_download_update_panel_failed para agrupar esta accion del script.
func _on_download_update_panel_failed() -> void:
	# Llama al metodo download_dialog.hide para realizar esta accion en este punto.
	download_dialog.hide()
	# Guarda en update_failed_dialog.dialog_text el resultado de DialogueConstants.translate(&"update.failed").
	update_failed_dialog.dialog_text = DialogueConstants.translate(&"update.failed")
	# Llama al metodo update_failed_dialog.popup_centered para realizar esta accion en este punto.
	update_failed_dialog.popup_centered()


# Define el metodo _on_needs_reload_dialog_confirmed para agrupar esta accion del script.
func _on_needs_reload_dialog_confirmed() -> void:
	# Llama al metodo EditorInterface.restart_editor para realizar esta accion en este punto.
	EditorInterface.restart_editor(true)


# Define el metodo _on_timer_timeout para agrupar esta accion del script.
func _on_timer_timeout() -> void:
	# Comprueba not needs_reload; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not needs_reload:
		# Llama al metodo check_for_update para realizar esta accion en este punto.
		check_for_update()
