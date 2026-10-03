# Ejecuta esta instruccion: @tool.
@tool
# Hereda de EditorProperty y reutiliza sus propiedades y comportamiento base.
extends EditorProperty


# Define DialoguePropertyEditorControl con el valor fijo preload("./editor_property_control.tscn").
const DialoguePropertyEditorControl = preload("./editor_property_control.tscn")


# Declara editor_plugin para guardar un dato utilizado por este script.
var editor_plugin: EditorPlugin

# Crea control e inicializa su valor con DialoguePropertyEditorControl.instantiate().
var control = DialoguePropertyEditorControl.instantiate()
# Declara current_value para guardar un dato utilizado por este script.
var current_value: Resource
# Crea is_updating e inicializa su valor con false.
var is_updating: bool = false


# Define el metodo _init para agrupar esta accion del script.
func _init() -> void:
	# Llama al metodo add_child para realizar esta accion en este punto.
	add_child(control)

	# Guarda en control.resource el resultado de current_value.
	control.resource = current_value

	# Llama al metodo control.pressed.connect para realizar esta accion en este punto.
	control.pressed.connect(_on_button_pressed)
	# Llama al metodo control.resource_changed.connect para realizar esta accion en este punto.
	control.resource_changed.connect(_on_resource_changed)


# Define el metodo _update_property para agrupar esta accion del script.
func _update_property() -> void:
	# Crea next_value e inicializa su valor con get_edited_object()[get_edited_property()].
	var next_value = get_edited_object()[get_edited_property()]

	# The resource might have been deleted elsewhere so check that it's not in a weird state
	if is_instance_valid(next_value) and not next_value.resource_path.ends_with(".dialogue"):
		# Llama al metodo emit_changed para realizar esta accion en este punto.
		emit_changed(get_edited_property(), null)
		# Termina el metodo sin devolver un valor.
		return

	# Ejecuta esta instruccion: if next_value == current_value: return.
	if next_value == current_value: return

	# Guarda en is_updating el resultado de true.
	is_updating = true
	# Guarda en current_value el resultado de next_value.
	current_value = next_value
	# Guarda en control.resource el resultado de current_value.
	control.resource = current_value
	# Guarda en is_updating el resultado de false.
	is_updating = false


### Signals


# Define el metodo _on_button_pressed para agrupar esta accion del script.
func _on_button_pressed() -> void:
	# Llama al metodo editor_plugin.edit para realizar esta accion en este punto.
	editor_plugin.edit(current_value)


# Define el metodo _on_resource_changed para agrupar esta accion del script.
func _on_resource_changed(next_resource: Resource) -> void:
	# Llama al metodo emit_changed para realizar esta accion en este punto.
	emit_changed(get_edited_property(), next_resource)
