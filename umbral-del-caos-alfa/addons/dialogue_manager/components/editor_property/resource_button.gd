# Ejecuta esta instruccion: @tool.
@tool
# Hereda de Button y reutiliza sus propiedades y comportamiento base.
extends Button


# Declara la seresource_dropped1al resource_dropped; otros nodos pueden conectarse para reaccionar cuando se emita.
signal resource_dropped(next_resource: Resource)


# Declara resource para guardar un dato utilizado por este script.
var resource: Resource:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_resource):
		# Guarda en resource el resultado de next_resource.
		resource = next_resource
		# Comprueba resource; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if resource:
			# Guarda en icon el resultado de Engine.get_meta("DialogueManagerPlugin")._get_plugin_icon().
			icon = Engine.get_meta("DialogueManagerPlugin")._get_plugin_icon()
			# Guarda en text el resultado de resource.resource_path.get_file().replace(".dialogue", "").
			text = resource.resource_path.get_file().replace(".dialogue", "")
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en icon el resultado de null.
			icon = null
			# Guarda en text el resultado de "<empty>".
			text = "<empty>"
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve resource a quien lo llamo.
		return resource


# Define el metodo _notification para agrupar esta accion del script.
func _notification(what: int) -> void:
	# Compara what con los casos siguientes y ejecuta el que coincida.
	match what:
		# Asocia la clave NOTIFICATION_DRAG_BEGIN con  dentro del diccionario.
		NOTIFICATION_DRAG_BEGIN:
			# Crea data e inicializa su valor con get_viewport().gui_get_drag_data().
			var data = get_viewport().gui_get_drag_data()
			# Comprueba typeof(data) == TYPE_DICTIONARY and data.type == "files" and data.files.size() > 0 and data.files[0].ends_with(".dialogue"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if typeof(data) == TYPE_DICTIONARY and data.type == "files" and data.files.size() > 0 and data.files[0].ends_with(".dialogue"):
				# Llama al metodo add_theme_stylebox_override para realizar esta accion en este punto.
				add_theme_stylebox_override("normal", get_theme_stylebox("focus", "LineEdit"))
				# Llama al metodo add_theme_stylebox_override para realizar esta accion en este punto.
				add_theme_stylebox_override("hover", get_theme_stylebox("focus", "LineEdit"))

		# Asocia la clave NOTIFICATION_DRAG_END con  dentro del diccionario.
		NOTIFICATION_DRAG_END:
			# Guarda en self.resource el resultado de resource.
			self.resource = resource
			# Llama al metodo remove_theme_stylebox_override para realizar esta accion en este punto.
			remove_theme_stylebox_override("normal")
			# Llama al metodo remove_theme_stylebox_override para realizar esta accion en este punto.
			remove_theme_stylebox_override("hover")


# Define el metodo _can_drop_data para agrupar esta accion del script.
func _can_drop_data(at_position: Vector2, data) -> bool:
	# Ejecuta esta instruccion: if typeof(data) != TYPE_DICTIONARY: return false.
	if typeof(data) != TYPE_DICTIONARY: return false
	# Ejecuta esta instruccion: if data.type != "files": return false.
	if data.type != "files": return false

	# Crea files e inicializa su valor con Array(data.files).filter(func(f): return f.get_extension() == "dialogue").
	var files: PackedStringArray = Array(data.files).filter(func(f): return f.get_extension() == "dialogue")
	# Termina el metodo y devuelve files.size() > 0 a quien lo llamo.
	return files.size() > 0


# Define el metodo _drop_data para agrupar esta accion del script.
func _drop_data(at_position: Vector2, data) -> void:
	# Crea files e inicializa su valor con Array(data.files).filter(func(f): return f.get_extension() == "dialogue").
	var files: PackedStringArray = Array(data.files).filter(func(f): return f.get_extension() == "dialogue")

	# Ejecuta esta instruccion: if files.size() == 0: return.
	if files.size() == 0: return

	# Emite la senal resource_dropped con estos datos: load(files[0]).
	resource_dropped.emit(load(files[0]))
