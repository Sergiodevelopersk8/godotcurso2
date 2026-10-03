# Ejecuta esta instruccion: @tool.
@tool
# Hereda de VBoxContainer y reutiliza sus propiedades y comportamiento base.
extends VBoxContainer

# Declara la setitle_selected1al title_selected; otros nodos pueden conectarse para reaccionar cuando se emita.
signal title_selected(title: String)


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")


# Obtiene la referencia filter_edit cuando el nodo ya esta listo.
@onready var filter_edit: LineEdit = $FilterEdit
# Obtiene la referencia list cuando el nodo ya esta listo.
@onready var list: ItemList = $List

# Declara titles para guardar un dato utilizado por este script.
var titles: PackedStringArray:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_titles):
		# Guarda en titles el resultado de next_titles.
		titles = next_titles
		# Llama al metodo apply_filter para realizar esta accion en este punto.
		apply_filter()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve titles a quien lo llamo.
		return titles

# Declara filter para guardar un dato utilizado por este script.
var filter: String:
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

	# Guarda en filter_edit.placeholder_text el resultado de DialogueConstants.translate(&"titles_list.filter").
	filter_edit.placeholder_text = DialogueConstants.translate(&"titles_list.filter")


# Define el metodo select_title para agrupar esta accion del script.
func select_title(title: String) -> void:
	# Llama al metodo list.deselect_all para realizar esta accion en este punto.
	list.deselect_all()
	# Recorre range(0, list.get_item_count()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, list.get_item_count()):
		# Comprueba list.get_item_text(i) == title.strip_edges(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if list.get_item_text(i) == title.strip_edges():
			# Llama al metodo list.select para realizar esta accion en este punto.
			list.select(i)


# Define el metodo apply_filter para agrupar esta accion del script.
func apply_filter() -> void:
	# Llama al metodo list.clear para realizar esta accion en este punto.
	list.clear()
	# Recorre titles y asigna cada elemento a title en cada vuelta.
	for title in titles:
		# Comprueba filter == "" or filter.to_lower() in title.to_lower(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if filter == "" or filter.to_lower() in title.to_lower():
			# Llama al metodo list.add_item para realizar esta accion en este punto.
			list.add_item(title.strip_edges())


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
	# Comprueba mouse_button_index == MOUSE_BUTTON_LEFT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		# Crea title e inicializa su valor con list.get_item_text(index).
		var title = list.get_item_text(index)
		# Emite la senal title_selected con estos datos: title.
		title_selected.emit(title)
