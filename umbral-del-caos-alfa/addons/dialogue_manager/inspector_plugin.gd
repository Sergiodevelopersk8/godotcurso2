# Ejecuta esta instruccion: @tool.
@tool
# Registra DMInspectorPlugin como nombre de clase global para usarlo en otros scripts.
class_name DMInspectorPlugin extends EditorInspectorPlugin


# Define DialogueEditorProperty con el valor fijo preload("./components/editor_property/editor_property.gd").
const DialogueEditorProperty = preload("./components/editor_property/editor_property.gd")


# Define el metodo _can_handle para agrupar esta accion del script.
func _can_handle(object) -> bool:
	# Ejecuta esta instruccion: if object is GDScript: return false.
	if object is GDScript: return false
	# Ejecuta esta instruccion: if not object is Node: return false.
	if not object is Node: return false
	# Ejecuta esta instruccion: if "name" in object and object.name == "Dialogue Manager": return false.
	if "name" in object and object.name == "Dialogue Manager": return false
	# Termina el metodo y devuelve true a quien lo llamo.
	return true


# Define el metodo _parse_property para agrupar esta accion del script.
func _parse_property(object: Object, type, name: String, hint_type, hint_string: String, usage_flags: int, wide: bool) -> bool:
	# Comprueba hint_string == "DialogueResource" or ("dialogue" in name.to_lower() and hint_string == "Resource"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if hint_string == "DialogueResource" or ("dialogue" in name.to_lower() and hint_string == "Resource"):
		# Crea property_editor e inicializa su valor con DialogueEditorProperty.new().
		var property_editor = DialogueEditorProperty.new()
		# Llama al metodo add_property_editor para realizar esta accion en este punto.
		add_property_editor(name, property_editor)
		# Termina el metodo y devuelve true a quien lo llamo.
		return true

	# Termina el metodo y devuelve false a quien lo llamo.
	return false
