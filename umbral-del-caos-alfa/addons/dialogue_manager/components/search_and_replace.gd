# Ejecuta esta instruccion: @tool.
@tool
# Hereda de VBoxContainer y reutiliza sus propiedades y comportamiento base.
extends VBoxContainer


# Declara la seopen_requested1al open_requested; otros nodos pueden conectarse para reaccionar cuando se emita.
signal open_requested()
# Declara la seclose_requested1al close_requested; otros nodos pueden conectarse para reaccionar cuando se emita.
signal close_requested()


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")


# Obtiene la referencia input cuando el nodo ya esta listo.
@onready var input: LineEdit = $Search/Input
# Obtiene la referencia result_label cuando el nodo ya esta listo.
@onready var result_label: Label = $Search/ResultLabel
# Obtiene la referencia previous_button cuando el nodo ya esta listo.
@onready var previous_button: Button = $Search/PreviousButton
# Obtiene la referencia next_button cuando el nodo ya esta listo.
@onready var next_button: Button = $Search/NextButton
# Obtiene la referencia match_case_button cuando el nodo ya esta listo.
@onready var match_case_button: CheckBox = $Search/MatchCaseCheckBox
# Obtiene la referencia replace_check_button cuando el nodo ya esta listo.
@onready var replace_check_button: CheckButton = $Search/ReplaceCheckButton
# Obtiene la referencia replace_panel cuando el nodo ya esta listo.
@onready var replace_panel: HBoxContainer = $Replace
# Obtiene la referencia replace_input cuando el nodo ya esta listo.
@onready var replace_input: LineEdit = $Replace/Input
# Obtiene la referencia replace_button cuando el nodo ya esta listo.
@onready var replace_button: Button = $Replace/ReplaceButton
# Obtiene la referencia replace_all_button cuando el nodo ya esta listo.
@onready var replace_all_button: Button = $Replace/ReplaceAllButton

# The code edit we will be affecting (for some reason exporting this didn't work)
var code_edit: CodeEdit:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_code_edit):
		# Guarda en code_edit el resultado de next_code_edit.
		code_edit = next_code_edit
		# Llama al metodo code_edit.gui_input.connect para realizar esta accion en este punto.
		code_edit.gui_input.connect(_on_text_edit_gui_input)
		# Llama al metodo code_edit.text_changed.connect para realizar esta accion en este punto.
		code_edit.text_changed.connect(_on_text_edit_text_changed)
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve code_edit a quien lo llamo.
		return code_edit

# Crea results e inicializa su valor con [].
var results: Array = []
# Crea result_index e inicializa su valor con -1:.
var result_index: int = -1:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_result_index):
		# Guarda en result_index el resultado de next_result_index.
		result_index = next_result_index
		# Comprueba results.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if results.size() > 0:
			# Crea r e inicializa su valor con results[result_index].
			var r = results[result_index]
			# Llama al metodo code_edit.set_caret_line para realizar esta accion en este punto.
			code_edit.set_caret_line(r[0])
			# Llama al metodo code_edit.select para realizar esta accion en este punto.
			code_edit.select(r[0], r[1], r[0], r[1] + r[2])
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en result_index el resultado de -1.
			result_index = -1
			# Comprueba is_instance_valid(code_edit); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if is_instance_valid(code_edit):
				# Llama al metodo code_edit.deselect para realizar esta accion en este punto.
				code_edit.deselect()

		# Guarda en result_label.text el resultado de DialogueConstants.translate(&"n_of_n").format({ index = result_index + 1, total = results.size() }).
		result_label.text = DialogueConstants.translate(&"n_of_n").format({ index = result_index + 1, total = results.size() })
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve result_index a quien lo llamo.
		return result_index


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()

	# Guarda en input.placeholder_text el resultado de DialogueConstants.translate(&"search.placeholder").
	input.placeholder_text = DialogueConstants.translate(&"search.placeholder")
	# Guarda en previous_button.tooltip_text el resultado de DialogueConstants.translate(&"search.previous").
	previous_button.tooltip_text = DialogueConstants.translate(&"search.previous")
	# Guarda en next_button.tooltip_text el resultado de DialogueConstants.translate(&"search.next").
	next_button.tooltip_text = DialogueConstants.translate(&"search.next")
	# Guarda en match_case_button.text el resultado de DialogueConstants.translate(&"search.match_case").
	match_case_button.text = DialogueConstants.translate(&"search.match_case")
	# Ejecuta esta instruccion: $Search/ReplaceCheckButton.text = DialogueConstants.translate(&"search.toggle_replace").
	$Search/ReplaceCheckButton.text = DialogueConstants.translate(&"search.toggle_replace")
	# Guarda en replace_button.text el resultado de DialogueConstants.translate(&"search.replace").
	replace_button.text = DialogueConstants.translate(&"search.replace")
	# Guarda en replace_all_button.text el resultado de DialogueConstants.translate(&"search.replace_all").
	replace_all_button.text = DialogueConstants.translate(&"search.replace_all")
	# Ejecuta esta instruccion: $Replace/ReplaceLabel.text = DialogueConstants.translate(&"search.replace_with").
	$Replace/ReplaceLabel.text = DialogueConstants.translate(&"search.replace_with")

	# Guarda en self.result_index el resultado de -1.
	self.result_index = -1

	# Llama al metodo replace_panel.hide para realizar esta accion en este punto.
	replace_panel.hide()
	# Guarda en replace_button.disabled el resultado de true.
	replace_button.disabled = true
	# Guarda en replace_all_button.disabled el resultado de true.
	replace_all_button.disabled = true

	# Llama al metodo hide para realizar esta accion en este punto.
	hide()


# Define el metodo focus_line_edit para agrupar esta accion del script.
func focus_line_edit() -> void:
	# Llama al metodo input.grab_focus para realizar esta accion en este punto.
	input.grab_focus()
	# Llama al metodo input.select_all para realizar esta accion en este punto.
	input.select_all()


# Define el metodo apply_theme para agrupar esta accion del script.
func apply_theme() -> void:
	# Comprueba is_instance_valid(previous_button); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(previous_button):
		# Guarda en previous_button.icon el resultado de get_theme_icon("ArrowLeft", "EditorIcons").
		previous_button.icon = get_theme_icon("ArrowLeft", "EditorIcons")
	# Comprueba is_instance_valid(next_button); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(next_button):
		# Guarda en next_button.icon el resultado de get_theme_icon("ArrowRight", "EditorIcons").
		next_button.icon = get_theme_icon("ArrowRight", "EditorIcons")


# Find text in the code
func search(text: String = "", default_result_index: int = 0) -> void:
	# Llama al metodo results.clear para realizar esta accion en este punto.
	results.clear()

	# Comprueba text == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text == "":
		# Guarda en text el resultado de input.text.
		text = input.text

	# Crea lines e inicializa su valor con code_edit.text.split("\n").
	var lines = code_edit.text.split("\n")
	# Recorre range(0, lines.size()) y asigna cada elemento a line_number en cada vuelta.
	for line_number in range(0, lines.size()):
		# Crea line e inicializa su valor con lines[line_number].
		var line = lines[line_number]

		# Crea column e inicializa su valor con find_in_line(line, text, 0).
		var column = find_in_line(line, text, 0)
		# Repite este bloque mientras column > -1 sea verdadero.
		while column > -1:
			# Llama al metodo results.append para realizar esta accion en este punto.
			results.append([line_number, column, text.length()])
			# Guarda en column el resultado de find_in_line(line, text, column + 1).
			column = find_in_line(line, text, column + 1)

	# Comprueba results.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if results.size() > 0:
		# Guarda en replace_button.disabled el resultado de false.
		replace_button.disabled = false
		# Guarda en replace_all_button.disabled el resultado de false.
		replace_all_button.disabled = false
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en replace_button.disabled el resultado de true.
		replace_button.disabled = true
		# Guarda en replace_all_button.disabled el resultado de true.
		replace_all_button.disabled = true

	# Guarda en self.result_index el resultado de clamp(default_result_index, 0, results.size() - 1).
	self.result_index = clamp(default_result_index, 0, results.size() - 1)


# Find text in a string and match case if requested
func find_in_line(line: String, text: String, from_index: int = 0) -> int:
	# Comprueba match_case_button.button_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if match_case_button.button_pressed:
		# Termina el metodo y devuelve line.find(text, from_index) a quien lo llamo.
		return line.find(text, from_index)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve line.findn(text, from_index) a quien lo llamo.
		return line.findn(text, from_index)


#region Signals


# Define el metodo _on_text_edit_gui_input para agrupar esta accion del script.
func _on_text_edit_gui_input(event: InputEvent) -> void:
	# Comprueba event is InputEventKey and event.is_pressed(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if event is InputEventKey and event.is_pressed():
		# Compara event.as_text() con los casos siguientes y ejecuta el que coincida.
		match event.as_text():
			# Ejecuta esta instruccion: "Ctrl+F", "Command+F":.
			"Ctrl+F", "Command+F":
				# Emite la senal open_requested con estos datos: ninguno.
				open_requested.emit()
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Ejecuta esta instruccion: "Ctrl+Shift+R", "Command+Shift+R":.
			"Ctrl+Shift+R", "Command+Shift+R":
				# Llama al metodo replace_check_button.set_pressed para realizar esta accion en este punto.
				replace_check_button.set_pressed(true)
				# Emite la senal open_requested con estos datos: ninguno.
				open_requested.emit()
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()


# Define el metodo _on_text_edit_text_changed para agrupar esta accion del script.
func _on_text_edit_text_changed() -> void:
	# Llama al metodo results.clear para realizar esta accion en este punto.
	results.clear()


# Define el metodo _on_search_and_replace_theme_changed para agrupar esta accion del script.
func _on_search_and_replace_theme_changed() -> void:
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()


# Define el metodo _on_input_text_changed para agrupar esta accion del script.
func _on_input_text_changed(new_text: String) -> void:
	# Llama al metodo search para realizar esta accion en este punto.
	search(new_text)


# Define el metodo _on_previous_button_pressed para agrupar esta accion del script.
func _on_previous_button_pressed() -> void:
	# Guarda en self.result_index el resultado de wrapi(result_index - 1, 0, results.size()).
	self.result_index = wrapi(result_index - 1, 0, results.size())


# Define el metodo _on_next_button_pressed para agrupar esta accion del script.
func _on_next_button_pressed() -> void:
	# Guarda en self.result_index el resultado de wrapi(result_index + 1, 0, results.size()).
	self.result_index = wrapi(result_index + 1, 0, results.size())


# Define el metodo _on_search_and_replace_visibility_changed para agrupar esta accion del script.
func _on_search_and_replace_visibility_changed() -> void:
	# Comprueba is_instance_valid(input); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_instance_valid(input):
		# Comprueba visible; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if visible:
			# Llama al metodo input.grab_focus para realizar esta accion en este punto.
			input.grab_focus()
			# Crea selection e inicializa su valor con code_edit.get_selected_text().
			var selection = code_edit.get_selected_text()
			# Comprueba input.text == "" and selection != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if input.text == "" and selection != "":
				# Guarda en input.text el resultado de selection.
				input.text = selection
				# Llama al metodo search para realizar esta accion en este punto.
				search(selection)
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Llama al metodo search para realizar esta accion en este punto.
				search()
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en input.text el resultado de "".
			input.text = ""


# Define el metodo _on_input_gui_input para agrupar esta accion del script.
func _on_input_gui_input(event: InputEvent) -> void:
	# Comprueba event is InputEventKey and event.is_pressed(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if event is InputEventKey and event.is_pressed():
		# Compara event.as_text() con los casos siguientes y ejecuta el que coincida.
		match event.as_text():
			# Asocia la clave "Enter" con  dentro del diccionario.
			"Enter":
				# Llama al metodo search para realizar esta accion en este punto.
				search(input.text)
			# Asocia la clave "Escape" con  dentro del diccionario.
			"Escape":
				# Llama al metodo emit_signal para realizar esta accion en este punto.
				emit_signal("close_requested")


# Define el metodo _on_replace_button_pressed para agrupar esta accion del script.
func _on_replace_button_pressed() -> void:
	# Ejecuta esta instruccion: if result_index == -1: return.
	if result_index == -1: return

	# Replace the selection at result index
	var r: Array = results[result_index]
	# Llama al metodo code_edit.begin_complex_operation para realizar esta accion en este punto.
	code_edit.begin_complex_operation()
	# Crea lines e inicializa su valor con code_edit.text.split("\n").
	var lines: PackedStringArray = code_edit.text.split("\n")
	# Crea line e inicializa su valor con lines[r[0]].
	var line: String = lines[r[0]]
	# Guarda en line el resultado de line.substr(0, r[1]) + replace_input.text + line.substr(r[1] + r[2]).
	line = line.substr(0, r[1]) + replace_input.text + line.substr(r[1] + r[2])
	# Ejecuta esta instruccion: lines[r[0]] = line.
	lines[r[0]] = line
	# Guarda en code_edit.text el resultado de "\n".join(lines).
	code_edit.text = "\n".join(lines)
	# Llama al metodo code_edit.end_complex_operation para realizar esta accion en este punto.
	code_edit.end_complex_operation()
	# Emite la senal code_edit.text_changed con estos datos: ninguno.
	code_edit.text_changed.emit()

	# Llama al metodo search para realizar esta accion en este punto.
	search(input.text, result_index)


# Define el metodo _on_replace_all_button_pressed para agrupar esta accion del script.
func _on_replace_all_button_pressed() -> void:
	# Comprueba match_case_button.button_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if match_case_button.button_pressed:
		# Guarda en code_edit.text el resultado de code_edit.text.replace(input.text, replace_input.text).
		code_edit.text = code_edit.text.replace(input.text, replace_input.text)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en code_edit.text el resultado de code_edit.text.replacen(input.text, replace_input.text).
		code_edit.text = code_edit.text.replacen(input.text, replace_input.text)
	# Llama al metodo search para realizar esta accion en este punto.
	search()
	# Emite la senal code_edit.text_changed con estos datos: ninguno.
	code_edit.text_changed.emit()


# Define el metodo _on_replace_check_button_toggled para agrupar esta accion del script.
func _on_replace_check_button_toggled(button_pressed: bool) -> void:
	# Guarda en replace_panel.visible el resultado de button_pressed.
	replace_panel.visible = button_pressed
	# Comprueba button_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if button_pressed:
		# Llama al metodo replace_input.grab_focus para realizar esta accion en este punto.
		replace_input.grab_focus()


# Define el metodo _on_input_focus_entered para agrupar esta accion del script.
func _on_input_focus_entered() -> void:
	# Comprueba results.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if results.size() == 0:
		# Llama al metodo search para realizar esta accion en este punto.
		search()
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en self.result_index el resultado de result_index.
		self.result_index = result_index


# Define el metodo _on_match_case_check_box_toggled para agrupar esta accion del script.
func _on_match_case_check_box_toggled(button_pressed: bool) -> void:
	# Llama al metodo search para realizar esta accion en este punto.
	search()


#endregion
