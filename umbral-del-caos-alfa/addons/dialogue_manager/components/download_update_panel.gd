# Ejecuta esta instruccion: @tool.
@tool
# Hereda de Control y reutiliza sus propiedades y comportamiento base.
extends Control


# Declara la sefailed1al failed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal failed()
# Declara la seupdated1al updated; otros nodos pueden conectarse para reaccionar cuando se emita.
signal updated(updated_to_version: String)


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")

# Define TEMP_FILE_NAME con el valor fijo "user://temp.zip".
const TEMP_FILE_NAME = "user://temp.zip"


# Obtiene la referencia logo cuando el nodo ya esta listo.
@onready var logo: TextureRect = %Logo
# Obtiene la referencia label cuando el nodo ya esta listo.
@onready var label: Label = $VBox/Label
# Obtiene la referencia http_request cuando el nodo ya esta listo.
@onready var http_request: HTTPRequest = $HTTPRequest
# Obtiene la referencia download_button cuando el nodo ya esta listo.
@onready var download_button: Button = %DownloadButton

# Declara next_version_release para guardar un dato utilizado por este script.
var next_version_release: Dictionary:
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Guarda en next_version_release el resultado de value.
		next_version_release = value
		# Guarda en label.text el resultado de DialogueConstants.translate(&"update.is_available_for_download") % value.tag_name.substr(1).
		label.text = DialogueConstants.translate(&"update.is_available_for_download") % value.tag_name.substr(1)
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve next_version_release a quien lo llamo.
		return next_version_release


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Ejecuta esta instruccion: $VBox/Center/DownloadButton.text = DialogueConstants.translate(&"update.download_update").
	$VBox/Center/DownloadButton.text = DialogueConstants.translate(&"update.download_update")
	# Ejecuta esta instruccion: $VBox/Center2/NotesButton.text = DialogueConstants.translate(&"update.release_notes").
	$VBox/Center2/NotesButton.text = DialogueConstants.translate(&"update.release_notes")


### Signals


# Define el metodo _on_download_button_pressed para agrupar esta accion del script.
func _on_download_button_pressed() -> void:
	# Safeguard the actual dialogue manager repo from accidentally updating itself
	if FileAccess.file_exists("res://tests/test_basic_dialogue.gd"):
		# Llama al metodo prints para realizar esta accion en este punto.
		prints("You can't update the addon from within itself.")
		# Emite la senal failed con estos datos: ninguno.
		failed.emit()
		# Termina el metodo sin devolver un valor.
		return

	# Llama al metodo http_request.request para realizar esta accion en este punto.
	http_request.request(next_version_release.zipball_url)
	# Guarda en download_button.disabled el resultado de true.
	download_button.disabled = true
	# Guarda en download_button.text el resultado de DialogueConstants.translate(&"update.downloading").
	download_button.text = DialogueConstants.translate(&"update.downloading")


# Define el metodo _on_http_request_request_completed para agrupar esta accion del script.
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# Comprueba result != HTTPRequest.RESULT_SUCCESS; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if result != HTTPRequest.RESULT_SUCCESS:
		# Emite la senal failed con estos datos: ninguno.
		failed.emit()
		# Termina el metodo sin devolver un valor.
		return

	# Save the downloaded zip
	var zip_file: FileAccess = FileAccess.open(TEMP_FILE_NAME, FileAccess.WRITE)
	# Llama al metodo zip_file.store_buffer para realizar esta accion en este punto.
	zip_file.store_buffer(body)
	# Llama al metodo zip_file.close para realizar esta accion en este punto.
	zip_file.close()

	# Llama al metodo OS.move_to_trash para realizar esta accion en este punto.
	OS.move_to_trash(ProjectSettings.globalize_path("res://addons/dialogue_manager"))

	# Crea zip_reader e inicializa su valor con ZIPReader.new().
	var zip_reader: ZIPReader = ZIPReader.new()
	# Llama al metodo zip_reader.open para realizar esta accion en este punto.
	zip_reader.open(TEMP_FILE_NAME)
	# Crea files e inicializa su valor con zip_reader.get_files().
	var files: PackedStringArray = zip_reader.get_files()

	# Crea base_path e inicializa su valor con files[1].
	var base_path = files[1]
	# Remove archive folder
	files.remove_at(0)
	# Remove assets folder
	files.remove_at(0)

	# Recorre files y asigna cada elemento a path en cada vuelta.
	for path in files:
		# Crea new_file_path e inicializa su valor con path.replace(base_path, "").
		var new_file_path: String = path.replace(base_path, "")
		# Comprueba path.ends_with("/"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if path.ends_with("/"):
			# Llama al metodo DirAccess.make_dir_recursive_absolute para realizar esta accion en este punto.
			DirAccess.make_dir_recursive_absolute("res://addons/%s" % new_file_path)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Crea file e inicializa su valor con FileAccess.open("res://addons/%s" % new_file_path, FileAccess.WRITE).
			var file: FileAccess = FileAccess.open("res://addons/%s" % new_file_path, FileAccess.WRITE)
			# Llama al metodo file.store_buffer para realizar esta accion en este punto.
			file.store_buffer(zip_reader.read_file(path))

	# Llama al metodo zip_reader.close para realizar esta accion en este punto.
	zip_reader.close()
	# Llama al metodo DirAccess.remove_absolute para realizar esta accion en este punto.
	DirAccess.remove_absolute(TEMP_FILE_NAME)

	# Emite la senal updated con estos datos: next_version_release.tag_name.substr(1).
	updated.emit(next_version_release.tag_name.substr(1))


# Define el metodo _on_notes_button_pressed para agrupar esta accion del script.
func _on_notes_button_pressed() -> void:
	# Llama al metodo OS.shell_open para realizar esta accion en este punto.
	OS.shell_open(next_version_release.html_url)
