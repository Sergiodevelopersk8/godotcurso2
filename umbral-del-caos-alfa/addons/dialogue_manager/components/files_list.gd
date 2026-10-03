# Ejecuta esta instruccion: @tool.
@tool
# Hereda de VBoxContainer y reutiliza sus propiedades y comportamiento base.
extends VBoxContainer


# Declara la sefile_selected1al file_selected; otros nodos pueden conectarse para reaccionar cuando se emita.
signal file_selected(file_path: String)
# Declara la sefile_popup_menu_requested1al file_popup_menu_requested; otros nodos pueden conectarse para reaccionar cuando se emita.
signal file_popup_menu_requested(at_position: Vector2)
# Declara la sefile_double_clicked1al file_double_clicked; otros nodos pueden conectarse para reaccionar cuando se emita.
signal file_double_clicked(file_path: String)
# Declara la sefile_middle_clicked1al file_middle_clicked; otros nodos pueden conectarse para reaccionar cuando se emita.
signal file_middle_clicked(file_path: String)


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")

# Define MODIFIED_SUFFIX con el valor fijo "(*)".
const MODIFIED_SUFFIX = "(*)"


# Expone icon en el Inspector para configurarlo desde la escena.
@export var icon: Texture2D

# Obtiene la referencia filter_edit cuando el nodo ya esta listo.
@onready var filter_edit: LineEdit = $FilterEdit
# Obtiene la referencia list cuando el nodo ya esta listo.
@onready var list: ItemList = $List

# Crea file_map e inicializa su valor con {}.
var file_map: Dictionary = {}

# Crea current_file_path e inicializa su valor con "".
var current_file_path: String = ""
# Crea last_selected_file_path e inicializa su valor con "".
var last_selected_file_path: String = ""

# Crea files e inicializa su valor con []:.
var files: PackedStringArray = []:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_files):
		# Guarda en files el resultado de next_files.
		files = next_files
		# Llama al metodo files.sort para realizar esta accion en este punto.
		files.sort()
		# Llama al metodo update_file_map para realizar esta accion en este punto.
		update_file_map()
		# Llama al metodo apply_filter para realizar esta accion en este punto.
		apply_filter()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve files a quien lo llamo.
		return files

# Crea unsaved_files e inicializa su valor con [].
var unsaved_files: Array[String] = []

# Crea filter e inicializa su valor con "":.
var filter: String = "":
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_filter):
		# Guarda en filter el resultado de next_filter.
		filter = next_filter
		# Llama al metodo apply_filter para realizar esta accion en este punto.
		apply_filter()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve filter a quien lo llamo.
		return filter


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()

	# Guarda en filter_edit.placeholder_text el resultado de DialogueConstants.translate(&"files_list.filter").
	filter_edit.placeholder_text = DialogueConstants.translate(&"files_list.filter")


# Define el metodo focus_filter para agrupar esta accion del script.
func focus_filter() -> void:
	# Llama al metodo filter_edit.grab_focus para realizar esta accion en este punto.
	filter_edit.grab_focus()


# Define el metodo select_file para agrupar esta accion del script.
func select_file(file: String) -> void:
	# Llama al metodo list.deselect_all para realizar esta accion en este punto.
	list.deselect_all()
	# Recorre range(0, list.get_item_count()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, list.get_item_count()):
		# Crea item_text e inicializa su valor con list.get_item_text(i).replace(MODIFIED_SUFFIX, "").
		var item_text = list.get_item_text(i).replace(MODIFIED_SUFFIX, "")
		# Comprueba item_text == get_nice_file(file, item_text.count("/") + 1); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if item_text == get_nice_file(file, item_text.count("/") + 1):
			# Llama al metodo list.select para realizar esta accion en este punto.
			list.select(i)
			# Guarda en last_selected_file_path el resultado de file.
			last_selected_file_path = file


# Define el metodo mark_file_as_unsaved para agrupar esta accion del script.
func mark_file_as_unsaved(file: String, is_unsaved: bool) -> void:
	# Comprueba not file in unsaved_files and is_unsaved; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not file in unsaved_files and is_unsaved:
		# Llama al metodo unsaved_files.append para realizar esta accion en este punto.
		unsaved_files.append(file)
	# Comprueba file in unsaved_files and not is_unsaved si las condiciones anteriores resultaron falsas.
	elif file in unsaved_files and not is_unsaved:
		# Llama al metodo unsaved_files.erase para realizar esta accion en este punto.
		unsaved_files.erase(file)
	# Llama al metodo apply_filter para realizar esta accion en este punto.
	apply_filter()


# Define el metodo update_file_map para agrupar esta accion del script.
func update_file_map() -> void:
	# Guarda en file_map el resultado de {}.
	file_map = {}
	# Recorre files y asigna cada elemento a file en cada vuelta.
	for file in files:
		# Crea nice_file e inicializa su valor con get_nice_file(file).
		var nice_file: String = get_nice_file(file)

		# See if a value with just the file name is already in the map
		for key in file_map.keys():
			# Comprueba file_map[key] == nice_file; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if file_map[key] == nice_file:
				# Crea bit_count e inicializa su valor con nice_file.count("/") + 2.
				var bit_count = nice_file.count("/") + 2

				# Crea existing_nice_file e inicializa su valor con get_nice_file(key, bit_count).
				var existing_nice_file = get_nice_file(key, bit_count)
				# Guarda en nice_file el resultado de get_nice_file(file, bit_count).
				nice_file = get_nice_file(file, bit_count)

				# Repite este bloque mientras nice_file == existing_nice_file sea verdadero.
				while nice_file == existing_nice_file:
					# Suma a bit_count el valor 1 respecto de su valor anterior.
					bit_count += 1
					# Guarda en existing_nice_file el resultado de get_nice_file(key, bit_count).
					existing_nice_file = get_nice_file(key, bit_count)
					# Guarda en nice_file el resultado de get_nice_file(file, bit_count).
					nice_file = get_nice_file(file, bit_count)

				# Ejecuta esta instruccion: file_map[key] = existing_nice_file.
				file_map[key] = existing_nice_file

		# Ejecuta esta instruccion: file_map[file] = nice_file.
		file_map[file] = nice_file


# Define el metodo get_nice_file para agrupar esta accion del script.
func get_nice_file(file_path: String, path_bit_count: int = 1) -> String:
	# Crea bits e inicializa su valor con file_path.replace("res://", "").replace(".dialogue", "").split("/").
	var bits = file_path.replace("res://", "").replace(".dialogue", "").split("/")
	# Guarda en bits el resultado de bits.slice(-path_bit_count).
	bits = bits.slice(-path_bit_count)
	# Termina el metodo y devuelve "/".join(bits) a quien lo llamo.
	return "/".join(bits)


# Define el metodo apply_filter para agrupar esta accion del script.
func apply_filter() -> void:
	# Llama al metodo list.clear para realizar esta accion en este punto.
	list.clear()
	# Recorre file_map.keys() y asigna cada elemento a file en cada vuelta.
	for file in file_map.keys():
		# Comprueba filter == "" or filter.to_lower() in file.to_lower(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if filter == "" or filter.to_lower() in file.to_lower():
			# Crea nice_file e inicializa su valor con file_map[file].
			var nice_file = file_map[file]
			# Comprueba file in unsaved_files; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if file in unsaved_files:
				# Suma a nice_file el valor MODIFIED_SUFFIX respecto de su valor anterior.
				nice_file += MODIFIED_SUFFIX
			# Crea new_id e inicializa su valor con list.add_item(nice_file).
			var new_id := list.add_item(nice_file)
			# Llama al metodo list.set_item_icon para realizar esta accion en este punto.
			list.set_item_icon(new_id, icon)

	# Llama al metodo select_file para realizar esta accion en este punto.
	select_file(current_file_path)


# Define el metodo apply_theme para agrupar esta accion del script.
func apply_theme() -> void:
	# Comprueba is_instance_valid(filter_edit); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(filter_edit):
		# Guarda en filter_edit.right_icon el resultado de get_theme_icon("Search", "EditorIcons").
		filter_edit.right_icon = get_theme_icon("Search", "EditorIcons")
	# Comprueba is_instance_valid(list); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(list):
		# Llama al metodo list.add_theme_stylebox_override para realizar esta accion en este punto.
		list.add_theme_stylebox_override("panel", get_theme_stylebox("panel", "Panel"))


### Signals


# Define el metodo _on_theme_changed para agrupar esta accion del script.
func _on_theme_changed() -> void:
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()


# Define el metodo _on_filter_edit_text_changed para agrupar esta accion del script.
func _on_filter_edit_text_changed(new_text: String) -> void:
	# Guarda en self.filter el resultado de new_text.
	self.filter = new_text


# Define el metodo _on_list_item_clicked para agrupar esta accion del script.
func _on_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	# Crea item_text e inicializa su valor con list.get_item_text(index).replace(MODIFIED_SUFFIX, "").
	var item_text = list.get_item_text(index).replace(MODIFIED_SUFFIX, "")
	# Crea file e inicializa su valor con file_map.find_key(item_text).
	var file = file_map.find_key(item_text)

	# Comprueba mouse_button_index == MOUSE_BUTTON_LEFT or mouse_button_index == MOUSE_BUTTON_RIGHT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if mouse_button_index == MOUSE_BUTTON_LEFT or mouse_button_index == MOUSE_BUTTON_RIGHT:
		# Llama al metodo select_file para realizar esta accion en este punto.
		select_file(file)
		# Emite la senal file_selected con estos datos: file.
		file_selected.emit(file)
		# Comprueba mouse_button_index == MOUSE_BUTTON_RIGHT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if mouse_button_index == MOUSE_BUTTON_RIGHT:
			# Emite la senal file_popup_menu_requested con estos datos: at_position.
			file_popup_menu_requested.emit(at_position)

	# Comprueba mouse_button_index == MOUSE_BUTTON_MIDDLE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if mouse_button_index == MOUSE_BUTTON_MIDDLE:
		# Emite la senal file_middle_clicked con estos datos: file.
		file_middle_clicked.emit(file)


# Define el metodo _on_list_item_activated para agrupar esta accion del script.
func _on_list_item_activated(index: int) -> void:
	# Crea item_text e inicializa su valor con list.get_item_text(index).replace(MODIFIED_SUFFIX, "").
	var item_text = list.get_item_text(index).replace(MODIFIED_SUFFIX, "")
	# Crea file e inicializa su valor con file_map.find_key(item_text).
	var file = file_map.find_key(item_text)
	# Llama al metodo select_file para realizar esta accion en este punto.
	select_file(file)
	# Emite la senal file_double_clicked con estos datos: file.
	file_double_clicked.emit(file)
