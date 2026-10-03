# Ejecuta esta instruccion: @tool.
@tool
# Hereda de HBoxContainer y reutiliza sus propiedades y comportamiento base.
extends HBoxContainer


# Declara la sepressed1al pressed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal pressed()
# Declara la seresource_changed1al resource_changed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal resource_changed(next_resource: Resource)


# Define ITEM_NEW con el valor fijo 100.
const ITEM_NEW = 100
# Define ITEM_QUICK_LOAD con el valor fijo 200.
const ITEM_QUICK_LOAD = 200
# Define ITEM_LOAD con el valor fijo 201.
const ITEM_LOAD = 201
# Define ITEM_EDIT con el valor fijo 300.
const ITEM_EDIT = 300
# Define ITEM_CLEAR con el valor fijo 301.
const ITEM_CLEAR = 301
# Define ITEM_FILESYSTEM con el valor fijo 400.
const ITEM_FILESYSTEM = 400


# Obtiene la referencia button cuando el nodo ya esta listo.
@onready var button: Button = $ResourceButton
# Obtiene la referencia menu_button cuando el nodo ya esta listo.
@onready var menu_button: Button = $MenuButton
# Obtiene la referencia menu cuando el nodo ya esta listo.
@onready var menu: PopupMenu = $Menu
# Obtiene la referencia quick_open_dialog cuando el nodo ya esta listo.
@onready var quick_open_dialog: ConfirmationDialog = $QuickOpenDialog
# Obtiene la referencia files_list cuando el nodo ya esta listo.
@onready var files_list = $QuickOpenDialog/FilesList
# Obtiene la referencia new_dialog cuando el nodo ya esta listo.
@onready var new_dialog: FileDialog = $NewDialog
# Obtiene la referencia open_dialog cuando el nodo ya esta listo.
@onready var open_dialog: FileDialog = $OpenDialog

# Declara editor_plugin para guardar un dato utilizado por este script.
var editor_plugin: EditorPlugin

# Declara resource para guardar un dato utilizado por este script.
var resource: Resource:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_resource):
		# Guarda en resource el resultado de next_resource.
		resource = next_resource
		# Comprueba button; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if button:
			# Guarda en button.resource el resultado de resource.
			button.resource = resource
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve resource a quien lo llamo.
		return resource

# Crea is_waiting_for_file e inicializa su valor con false.
var is_waiting_for_file: bool = false
# Crea quick_selected_file e inicializa su valor con "".
var quick_selected_file: String = ""


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Guarda en menu_button.icon el resultado de get_theme_icon("GuiDropdown", "EditorIcons").
	menu_button.icon = get_theme_icon("GuiDropdown", "EditorIcons")
	# Guarda en editor_plugin el resultado de Engine.get_meta("DialogueManagerPlugin").
	editor_plugin = Engine.get_meta("DialogueManagerPlugin")


# Define el metodo build_menu para agrupar esta accion del script.
func build_menu() -> void:
	# Llama al metodo menu.clear para realizar esta accion en este punto.
	menu.clear()

	# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
	menu.add_icon_item(editor_plugin._get_plugin_icon(), "New Dialogue", ITEM_NEW)
	# Llama al metodo menu.add_separator para realizar esta accion en este punto.
	menu.add_separator()
	# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
	menu.add_icon_item(get_theme_icon("Load", "EditorIcons"), "Quick Load", ITEM_QUICK_LOAD)
	# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
	menu.add_icon_item(get_theme_icon("Load", "EditorIcons"), "Load", ITEM_LOAD)
	# Comprueba resource; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if resource:
		# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
		menu.add_icon_item(get_theme_icon("Edit", "EditorIcons"), "Edit", ITEM_EDIT)
		# Llama al metodo menu.add_icon_item para realizar esta accion en este punto.
		menu.add_icon_item(get_theme_icon("Clear", "EditorIcons"), "Clear", ITEM_CLEAR)
		# Llama al metodo menu.add_separator para realizar esta accion en este punto.
		menu.add_separator()
		# Llama al metodo menu.add_item para realizar esta accion en este punto.
		menu.add_item("Show in FileSystem", ITEM_FILESYSTEM)

	# Guarda en menu.size el resultado de Vector2.ZERO.
	menu.size = Vector2.ZERO


### Signals


# Define el metodo _on_new_dialog_file_selected para agrupar esta accion del script.
func _on_new_dialog_file_selected(path: String) -> void:
	# Llama al metodo editor_plugin.main_view.new_file para realizar esta accion en este punto.
	editor_plugin.main_view.new_file(path)
	# Guarda en is_waiting_for_file el resultado de false.
	is_waiting_for_file = false
	# Comprueba Engine.get_meta("DMCache").has_file(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Engine.get_meta("DMCache").has_file(path):
		# Emite la senal resource_changed con estos datos: load(path).
		resource_changed.emit(load(path))
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Crea next_resource e inicializa su valor con await editor_plugin.import_plugin.compiled_resource.
		var next_resource: Resource = await editor_plugin.import_plugin.compiled_resource
		# Guarda en next_resource.resource_path el resultado de path.
		next_resource.resource_path = path
		# Emite la senal resource_changed con estos datos: next_resource.
		resource_changed.emit(next_resource)


# Define el metodo _on_open_dialog_file_selected para agrupar esta accion del script.
func _on_open_dialog_file_selected(file: String) -> void:
	# Emite la senal resource_changed con estos datos: load(file).
	resource_changed.emit(load(file))


# Define el metodo _on_file_dialog_canceled para agrupar esta accion del script.
func _on_file_dialog_canceled() -> void:
	# Guarda en is_waiting_for_file el resultado de false.
	is_waiting_for_file = false


# Define el metodo _on_resource_button_pressed para agrupar esta accion del script.
func _on_resource_button_pressed() -> void:
	# Comprueba is_instance_valid(resource); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(resource):
		# Llama al metodo EditorInterface.call_deferred para realizar esta accion en este punto.
		EditorInterface.call_deferred("edit_resource", resource)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo build_menu para realizar esta accion en este punto.
		build_menu()
		# Guarda en menu.position el resultado de get_viewport().position + Vector2i(.
		menu.position = get_viewport().position + Vector2i(
			# Ejecuta esta instruccion: button.global_position.x + button.size.x - menu.size.x,.
			button.global_position.x + button.size.x - menu.size.x,
			# Ejecuta esta instruccion: 2 + menu_button.global_position.y + button.size.y.
			2 + menu_button.global_position.y + button.size.y
		)
		# Llama al metodo menu.popup para realizar esta accion en este punto.
		menu.popup()


# Define el metodo _on_resource_button_resource_dropped para agrupar esta accion del script.
func _on_resource_button_resource_dropped(next_resource: Resource) -> void:
	# Emite la senal resource_changed con estos datos: next_resource.
	resource_changed.emit(next_resource)


# Define el metodo _on_menu_button_pressed para agrupar esta accion del script.
func _on_menu_button_pressed() -> void:
	# Llama al metodo build_menu para realizar esta accion en este punto.
	build_menu()
	# Guarda en menu.position el resultado de get_viewport().position + Vector2i(.
	menu.position = get_viewport().position + Vector2i(
		# Ejecuta esta instruccion: menu_button.global_position.x + menu_button.size.x - menu.size.x,.
		menu_button.global_position.x + menu_button.size.x - menu.size.x,
		# Ejecuta esta instruccion: 2 + menu_button.global_position.y + menu_button.size.y.
		2 + menu_button.global_position.y + menu_button.size.y
	)
	# Llama al metodo menu.popup para realizar esta accion en este punto.
	menu.popup()


# Define el metodo _on_menu_id_pressed para agrupar esta accion del script.
func _on_menu_id_pressed(id: int) -> void:
	# Compara id con los casos siguientes y ejecuta el que coincida.
	match id:
		# Asocia la clave ITEM_NEW con  dentro del diccionario.
		ITEM_NEW:
			# Guarda en is_waiting_for_file el resultado de true.
			is_waiting_for_file = true
			# Llama al metodo new_dialog.popup_centered para realizar esta accion en este punto.
			new_dialog.popup_centered()

		# Asocia la clave ITEM_QUICK_LOAD con  dentro del diccionario.
		ITEM_QUICK_LOAD:
			# Guarda en quick_selected_file el resultado de "".
			quick_selected_file = ""
			# Guarda en files_list.files el resultado de Engine.get_meta("DMCache").get_files().
			files_list.files = Engine.get_meta("DMCache").get_files()
			# Comprueba resource; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if resource:
				# Llama al metodo files_list.select_file para realizar esta accion en este punto.
				files_list.select_file(resource.resource_path)
			# Llama al metodo quick_open_dialog.popup_centered para realizar esta accion en este punto.
			quick_open_dialog.popup_centered()
			# Llama al metodo files_list.focus_filter para realizar esta accion en este punto.
			files_list.focus_filter()

		# Asocia la clave ITEM_LOAD con  dentro del diccionario.
		ITEM_LOAD:
			# Guarda en is_waiting_for_file el resultado de true.
			is_waiting_for_file = true
			# Llama al metodo open_dialog.popup_centered para realizar esta accion en este punto.
			open_dialog.popup_centered()

		# Asocia la clave ITEM_EDIT con  dentro del diccionario.
		ITEM_EDIT:
			# Llama al metodo EditorInterface.call_deferred para realizar esta accion en este punto.
			EditorInterface.call_deferred("edit_resource", resource)

		# Asocia la clave ITEM_CLEAR con  dentro del diccionario.
		ITEM_CLEAR:
			# Emite la senal resource_changed con estos datos: null.
			resource_changed.emit(null)

		# Asocia la clave ITEM_FILESYSTEM con  dentro del diccionario.
		ITEM_FILESYSTEM:
			# Crea file_system e inicializa su valor con EditorInterface.get_file_system_dock().
			var file_system = EditorInterface.get_file_system_dock()
			# Llama al metodo file_system.navigate_to_path para realizar esta accion en este punto.
			file_system.navigate_to_path(resource.resource_path)


# Define el metodo _on_files_list_file_double_clicked para agrupar esta accion del script.
func _on_files_list_file_double_clicked(file_path: String) -> void:
	# Emite la senal resource_changed con estos datos: load(file_path).
	resource_changed.emit(load(file_path))
	# Llama al metodo quick_open_dialog.hide para realizar esta accion en este punto.
	quick_open_dialog.hide()


# Define el metodo _on_files_list_file_selected para agrupar esta accion del script.
func _on_files_list_file_selected(file_path: String) -> void:
	# Guarda en quick_selected_file el resultado de file_path.
	quick_selected_file = file_path


# Define el metodo _on_quick_open_dialog_confirmed para agrupar esta accion del script.
func _on_quick_open_dialog_confirmed() -> void:
	# Comprueba quick_selected_file != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if quick_selected_file != "":
		# Emite la senal resource_changed con estos datos: load(quick_selected_file).
		resource_changed.emit(load(quick_selected_file))
