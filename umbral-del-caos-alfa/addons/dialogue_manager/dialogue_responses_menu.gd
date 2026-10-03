# Ejecuta esta instruccion: @icon("./assets/responses_menu.svg").
@icon("./assets/responses_menu.svg")

## A [Container] for dialogue responses provided by [b]Dialogue Manager[/b].
class_name DialogueResponsesMenu extends Container


## Emitted when a response is selected.
signal response_selected(response)


## Optionally specify a control to duplicate for each response
@export var response_template: Control

## The action for accepting a response (is possibly overridden by parent dialogue balloon).
@export var next_action: StringName = &""

## Hide any responses where [code]is_allowed[/code] is false
@export var hide_failed_responses: bool = false

## The list of dialogue responses.
var responses: Array = []:
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve responses a quien lo llamo.
		return responses
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Guarda en responses el resultado de value.
		responses = value

		# Remove any current items
		for item in get_children():
			# Ejecuta esta instruccion: if item == response_template: continue.
			if item == response_template: continue

			# Llama al metodo remove_child para realizar esta accion en este punto.
			remove_child(item)
			# Llama al metodo item.queue_free para realizar esta accion en este punto.
			item.queue_free()

		# Add new items
		if responses.size() > 0:
			# Recorre responses y asigna cada elemento a response en cada vuelta.
			for response in responses:
				# Ejecuta esta instruccion: if hide_failed_responses and not response.is_allowed: continue.
				if hide_failed_responses and not response.is_allowed: continue

				# Declara item para guardar un dato utilizado por este script.
				var item: Control
				# Comprueba is_instance_valid(response_template); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if is_instance_valid(response_template):
					# Guarda en item el resultado de response_template.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS).
					item = response_template.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS)
					# Llama al metodo item.show para realizar esta accion en este punto.
					item.show()
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Guarda en item el resultado de Button.new().
					item = Button.new()
				# Guarda en item.name el resultado de "Response%d" % get_child_count().
				item.name = "Response%d" % get_child_count()
				# Comprueba not response.is_allowed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if not response.is_allowed:
					# Guarda en item.name el resultado de item.name + &"Disallowed".
					item.name = item.name + &"Disallowed"
					# Guarda en item.disabled el resultado de true.
					item.disabled = true

				# If the item has a response property then use that
				if "response" in item:
					# Guarda en item.response el resultado de response.
					item.response = response
				# Otherwise assume we can just set the text
				else:
					# Guarda en item.text el resultado de response.text.
					item.text = response.text

				# Llama al metodo item.set_meta para realizar esta accion en este punto.
				item.set_meta("response", response)

				# Llama al metodo add_child para realizar esta accion en este punto.
				add_child(item)

			# Llama al metodo _configure_focus para realizar esta accion en este punto.
			_configure_focus()


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Llama al metodo visibility_changed.connect para realizar esta accion en este punto.
	visibility_changed.connect(func():
		# Comprueba visible and get_menu_items().size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if visible and get_menu_items().size() > 0:
			# Crea first_item e inicializa su valor con get_menu_items()[0].
			var first_item: Control = get_menu_items()[0]
			# Comprueba first_item.is_inside_tree(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_item.is_inside_tree():
				# Llama al metodo first_item.grab_focus para realizar esta accion en este punto.
				first_item.grab_focus()
	)

	# Comprueba is_instance_valid(response_template); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(response_template):
		# Llama al metodo response_template.hide para realizar esta accion en este punto.
		response_template.hide()


## Get the selectable items in the menu.
func get_menu_items() -> Array:
	# Crea items e inicializa su valor con [].
	var items: Array = []
	# Recorre get_children() y asigna cada elemento a child en cada vuelta.
	for child in get_children():
		# Ejecuta esta instruccion: if not child.visible: continue.
		if not child.visible: continue
		# Ejecuta esta instruccion: if "Disallowed" in child.name: continue.
		if "Disallowed" in child.name: continue
		# Llama al metodo items.append para realizar esta accion en este punto.
		items.append(child)

	# Termina el metodo y devuelve items a quien lo llamo.
	return items


#region Internal


# Prepare the menu for keyboard and mouse navigation.
func _configure_focus() -> void:
	# Crea items e inicializa su valor con get_menu_items().
	var items = get_menu_items()
	# Recorre items.size() y asigna cada elemento a i en cada vuelta.
	for i in items.size():
		# Crea item e inicializa su valor con items[i].
		var item: Control = items[i]

		# Guarda en item.focus_mode el resultado de Control.FOCUS_ALL.
		item.focus_mode = Control.FOCUS_ALL

		# Guarda en item.focus_neighbor_left el resultado de item.get_path().
		item.focus_neighbor_left = item.get_path()
		# Guarda en item.focus_neighbor_right el resultado de item.get_path().
		item.focus_neighbor_right = item.get_path()

		# Comprueba i == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if i == 0:
			# Guarda en item.focus_neighbor_top el resultado de item.get_path().
			item.focus_neighbor_top = item.get_path()
			# Guarda en item.focus_previous el resultado de item.get_path().
			item.focus_previous = item.get_path()
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en item.focus_neighbor_top el resultado de items[i - 1].get_path().
			item.focus_neighbor_top = items[i - 1].get_path()
			# Guarda en item.focus_previous el resultado de items[i - 1].get_path().
			item.focus_previous = items[i - 1].get_path()

		# Comprueba i == items.size() - 1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if i == items.size() - 1:
			# Guarda en item.focus_neighbor_bottom el resultado de item.get_path().
			item.focus_neighbor_bottom = item.get_path()
			# Guarda en item.focus_next el resultado de item.get_path().
			item.focus_next = item.get_path()
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en item.focus_neighbor_bottom el resultado de items[i + 1].get_path().
			item.focus_neighbor_bottom = items[i + 1].get_path()
			# Guarda en item.focus_next el resultado de items[i + 1].get_path().
			item.focus_next = items[i + 1].get_path()

		# Llama al metodo item.mouse_entered.connect para realizar esta accion en este punto.
		item.mouse_entered.connect(_on_response_mouse_entered.bind(item))
		# Llama al metodo item.gui_input.connect para realizar esta accion en este punto.
		item.gui_input.connect(_on_response_gui_input.bind(item, item.get_meta("response")))

	# Ejecuta esta instruccion: items[0].grab_focus().
	items[0].grab_focus()


#endregion

#region Signals


# Define el metodo _on_response_mouse_entered para agrupar esta accion del script.
func _on_response_mouse_entered(item: Control) -> void:
	# Ejecuta esta instruccion: if "Disallowed" in item.name: return.
	if "Disallowed" in item.name: return

	# Llama al metodo item.grab_focus para realizar esta accion en este punto.
	item.grab_focus()


# Define el metodo _on_response_gui_input para agrupar esta accion del script.
func _on_response_gui_input(event: InputEvent, item: Control, response) -> void:
	# Ejecuta esta instruccion: if "Disallowed" in item.name: return.
	if "Disallowed" in item.name: return

	# Comprueba event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		# Llama al metodo get_viewport para realizar esta accion en este punto.
		get_viewport().set_input_as_handled()
		# Emite la senal response_selected con estos datos: response.
		response_selected.emit(response)
	# Comprueba event.is_action_pressed(&"ui_accept" if next_action.is_empty() else next_action) and item in get_menu_items() si las condiciones anteriores resultaron falsas.
	elif event.is_action_pressed(&"ui_accept" if next_action.is_empty() else next_action) and item in get_menu_items():
		# Llama al metodo get_viewport para realizar esta accion en este punto.
		get_viewport().set_input_as_handled()
		# Emite la senal response_selected con estos datos: response.
		response_selected.emit(response)


#endregion
