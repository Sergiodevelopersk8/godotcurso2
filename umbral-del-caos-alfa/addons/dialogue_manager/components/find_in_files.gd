# Ejecuta esta instruccion: @tool.
@tool
# Hereda de Control y reutiliza sus propiedades y comportamiento base.
extends Control

# Declara la seresult_selected1al result_selected; otros nodos pueden conectarse para reaccionar cuando se emita.
signal result_selected(path: String, cursor: Vector2, length: int)


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")


# Expone main_view en el Inspector para configurarlo desde la escena.
@export var main_view: Control
# Expone code_edit en el Inspector para configurarlo desde la escena.
@export var code_edit: CodeEdit

# Obtiene la referencia input cuando el nodo ya esta listo.
@onready var input: LineEdit = %Input
# Obtiene la referencia search_button cuando el nodo ya esta listo.
@onready var search_button: Button = %SearchButton
# Obtiene la referencia match_case_button cuando el nodo ya esta listo.
@onready var match_case_button: CheckBox = %MatchCaseButton
# Obtiene la referencia replace_toggle cuando el nodo ya esta listo.
@onready var replace_toggle: CheckButton = %ReplaceToggle
# Obtiene la referencia replace_container cuando el nodo ya esta listo.
@onready var replace_container: VBoxContainer = %ReplaceContainer
# Obtiene la referencia replace_input cuando el nodo ya esta listo.
@onready var replace_input: LineEdit = %ReplaceInput
# Obtiene la referencia replace_selected_button cuando el nodo ya esta listo.
@onready var replace_selected_button: Button = %ReplaceSelectedButton
# Obtiene la referencia replace_all_button cuando el nodo ya esta listo.
@onready var replace_all_button: Button = %ReplaceAllButton
# Obtiene la referencia results_container cuando el nodo ya esta listo.
@onready var results_container: VBoxContainer = %ResultsContainer
# Obtiene la referencia result_template cuando el nodo ya esta listo.
@onready var result_template: HBoxContainer = %ResultTemplate

# Crea current_results e inicializa su valor con {}:.
var current_results: Dictionary = {}:
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Guarda en current_results el resultado de value.
		current_results = value
		# Llama al metodo update_results_view para realizar esta accion en este punto.
		update_results_view()
		# Comprueba current_results.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if current_results.size() == 0:
			# Guarda en replace_selected_button.disabled el resultado de true.
			replace_selected_button.disabled = true
			# Guarda en replace_all_button.disabled el resultado de true.
			replace_all_button.disabled = true
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en replace_selected_button.disabled el resultado de false.
			replace_selected_button.disabled = false
			# Guarda en replace_all_button.disabled el resultado de false.
			replace_all_button.disabled = false
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve current_results a quien lo llamo.
		return current_results

# Crea selections e inicializa su valor con [].
var selections: PackedStringArray = []


# Define el metodo prepare para agrupar esta accion del script.
func prepare() -> void:
	# Llama al metodo input.grab_focus para realizar esta accion en este punto.
	input.grab_focus()

	# Crea template_label e inicializa su valor con result_template.get_node("Label").
	var template_label = result_template.get_node("Label")
	# Llama al metodo template_label.get_theme_stylebox para realizar esta accion en este punto.
	template_label.get_theme_stylebox(&"focus").bg_color = code_edit.theme_overrides.current_line_color
	# Llama al metodo template_label.add_theme_font_override para realizar esta accion en este punto.
	template_label.add_theme_font_override(&"normal_font", code_edit.get_theme_font(&"font"))

	# Llama al metodo replace_toggle.set_pressed_no_signal para realizar esta accion en este punto.
	replace_toggle.set_pressed_no_signal(false)
	# Llama al metodo replace_container.hide para realizar esta accion en este punto.
	replace_container.hide()

	# Ejecuta esta instruccion: $VBoxContainer/HBoxContainer/FindContainer/Label.text = DialogueConstants.translate(&"search.find").
	$VBoxContainer/HBoxContainer/FindContainer/Label.text = DialogueConstants.translate(&"search.find")
	# Guarda en input.placeholder_text el resultado de DialogueConstants.translate(&"search.placeholder").
	input.placeholder_text = DialogueConstants.translate(&"search.placeholder")
	# Guarda en input.text el resultado de "".
	input.text = ""
	# Guarda en search_button.text el resultado de DialogueConstants.translate(&"search.find_all").
	search_button.text = DialogueConstants.translate(&"search.find_all")
	# Guarda en match_case_button.text el resultado de DialogueConstants.translate(&"search.match_case").
	match_case_button.text = DialogueConstants.translate(&"search.match_case")
	# Guarda en replace_toggle.text el resultado de DialogueConstants.translate(&"search.toggle_replace").
	replace_toggle.text = DialogueConstants.translate(&"search.toggle_replace")
	# Ejecuta esta instruccion: $VBoxContainer/HBoxContainer/ReplaceContainer/ReplaceLabel.text = DialogueConstants.translate(&"search.replace_with").
	$VBoxContainer/HBoxContainer/ReplaceContainer/ReplaceLabel.text = DialogueConstants.translate(&"search.replace_with")
	# Guarda en replace_input.placeholder_text el resultado de DialogueConstants.translate(&"search.replace_placeholder").
	replace_input.placeholder_text = DialogueConstants.translate(&"search.replace_placeholder")
	# Guarda en replace_input.text el resultado de "".
	replace_input.text = ""
	# Guarda en replace_all_button.text el resultado de DialogueConstants.translate(&"search.replace_all").
	replace_all_button.text = DialogueConstants.translate(&"search.replace_all")
	# Guarda en replace_selected_button.text el resultado de DialogueConstants.translate(&"search.replace_selected").
	replace_selected_button.text = DialogueConstants.translate(&"search.replace_selected")

	# Llama al metodo selections.clear para realizar esta accion en este punto.
	selections.clear()
	# Guarda en self.current_results el resultado de {}.
	self.current_results = {}

#region helpers


# Define el metodo update_results_view para agrupar esta accion del script.
func update_results_view() -> void:
	# Recorre results_container.get_children() y asigna cada elemento a child en cada vuelta.
	for child in results_container.get_children():
		# Llama al metodo child.queue_free para realizar esta accion en este punto.
		child.queue_free()

	# Recorre current_results.keys() y asigna cada elemento a path en cada vuelta.
	for path in current_results.keys():
		# Crea path_label e inicializa su valor con Label.new().
		var path_label: Label = Label.new()
		# Guarda en path_label.text el resultado de path.
		path_label.text = path
		# Show open files
		if main_view.open_buffers.has(path):
			# Suma a path_label.text el valor "(*)" respecto de su valor anterior.
			path_label.text += "(*)"
		# Llama al metodo results_container.add_child para realizar esta accion en este punto.
		results_container.add_child(path_label)
		# Recorre current_results.get(path) y asigna cada elemento a path_result en cada vuelta.
		for path_result in current_results.get(path):
			# Crea result_item e inicializa su valor con result_template.duplicate().
			var result_item: HBoxContainer = result_template.duplicate()

			# Crea checkbox e inicializa su valor con result_item.get_node("CheckBox") as CheckBox.
			var checkbox: CheckBox = result_item.get_node("CheckBox") as CheckBox
			# Crea key e inicializa su valor con get_selection_key(path, path_result).
			var key: String = get_selection_key(path, path_result)
			# Llama al metodo checkbox.toggled.connect para realizar esta accion en este punto.
			checkbox.toggled.connect(func(is_pressed):
				# Comprueba is_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if is_pressed:
					# Comprueba not selections.has(key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if not selections.has(key):
						# Llama al metodo selections.append para realizar esta accion en este punto.
						selections.append(key)
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Comprueba selections.has(key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if selections.has(key):
						# Llama al metodo selections.remove_at para realizar esta accion en este punto.
						selections.remove_at(selections.find(key))
			)
			# Llama al metodo checkbox.set_pressed_no_signal para realizar esta accion en este punto.
			checkbox.set_pressed_no_signal(selections.has(key))
			# Guarda en checkbox.visible el resultado de replace_toggle.button_pressed.
			checkbox.visible = replace_toggle.button_pressed

			# Crea result_label e inicializa su valor con result_item.get_node("Label") as RichTextLabel.
			var result_label: RichTextLabel = result_item.get_node("Label") as RichTextLabel
			# Crea colors e inicializa su valor con code_edit.theme_overrides.
			var colors: Dictionary = code_edit.theme_overrides
			# Crea highlight e inicializa su valor con "".
			var highlight: String = ""
			# Comprueba replace_toggle.button_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if replace_toggle.button_pressed:
				# Crea matched_word e inicializa su valor con "[bgcolor=" + colors.critical_color.to_html() + "][color=" + colors.text_color.to_html() + "]" + path_result.matched_text + "[/color][/bgcolor]".
				var matched_word: String = "[bgcolor=" + colors.critical_color.to_html() + "][color=" + colors.text_color.to_html() + "]" + path_result.matched_text + "[/color][/bgcolor]"
				# Guarda en highlight el resultado de "[s]" + matched_word + "[/s][bgcolor=" + colors.notice_color.to_html() + "][color=" + colors.text_color.to_html() + "]" + replace_input.text + "[/color][/bgcolor]".
				highlight = "[s]" + matched_word + "[/s][bgcolor=" + colors.notice_color.to_html() + "][color=" + colors.text_color.to_html() + "]" + replace_input.text + "[/color][/bgcolor]"
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en highlight el resultado de "[bgcolor=" + colors.notice_color.to_html() + "][color=" + colors.text_color.to_html() + "]" + path_result.matched_text + "[/color][/bgcolor]".
				highlight = "[bgcolor=" + colors.notice_color.to_html() + "][color=" + colors.text_color.to_html() + "]" + path_result.matched_text + "[/color][/bgcolor]"
			# Crea text e inicializa su valor con path_result.text.substr(0, path_result.index) + highlight + path_result.text.substr(path_result.index + path_result.query.length()).
			var text: String = path_result.text.substr(0, path_result.index) + highlight + path_result.text.substr(path_result.index + path_result.query.length())
			# Guarda en result_label.text el resultado de "%s: %s" % [str(path_result.line).lpad(4), text].
			result_label.text = "%s: %s" % [str(path_result.line).lpad(4), text]
			# Llama al metodo result_label.gui_input.connect para realizar esta accion en este punto.
			result_label.gui_input.connect(func(event):
				# Comprueba event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and (event as InputEventMouseButton).double_click; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and (event as InputEventMouseButton).double_click:
					# Emite la senal result_selected con estos datos: path, Vector2(path_result.index, path_result.line), path_result.query.length().
					result_selected.emit(path, Vector2(path_result.index, path_result.line), path_result.query.length())
			)

			# Llama al metodo results_container.add_child para realizar esta accion en este punto.
			results_container.add_child(result_item)


# Define el metodo find_in_files para agrupar esta accion del script.
func find_in_files() -> Dictionary:
	# Crea results e inicializa su valor con {}.
	var results: Dictionary = {}

	# Crea q e inicializa su valor con input.text.
	var q: String = input.text
	# Crea cache e inicializa su valor con Engine.get_meta("DMCache").
	var cache = Engine.get_meta("DMCache")
	# Declara file para guardar un dato utilizado por este script.
	var file: FileAccess
	# Recorre cache.get_files() y asigna cada elemento a path en cada vuelta.
	for path in cache.get_files():
		# Crea path_results e inicializa su valor con [].
		var path_results: Array = []
		# Crea lines e inicializa su valor con [].
		var lines: PackedStringArray = []

		# Comprueba main_view.open_buffers.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if main_view.open_buffers.has(path):
			# Guarda en lines el resultado de main_view.open_buffers.get(path).text.split("\n").
			lines = main_view.open_buffers.get(path).text.split("\n")
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en file el resultado de FileAccess.open(path, FileAccess.READ).
			file = FileAccess.open(path, FileAccess.READ)
			# Guarda en lines el resultado de file.get_as_text().split("\n").
			lines = file.get_as_text().split("\n")

		# Recorre range(0, lines.size()) y asigna cada elemento a i en cada vuelta.
		for i in range(0, lines.size()):
			# Crea index e inicializa su valor con find_in_line(lines[i], q).
			var index: int = find_in_line(lines[i], q)
			# Repite este bloque mientras index > -1 sea verdadero.
			while index > -1:
				# Llama al metodo path_results.append para realizar esta accion en este punto.
				path_results.append({
					# Guarda en line el resultado de i,.
					line = i,
					# Guarda en index el resultado de index,.
					index = index,
					# Guarda en text el resultado de lines[i],.
					text = lines[i],
					# Guarda en matched_text el resultado de lines[i].substr(index, q.length()),.
					matched_text = lines[i].substr(index, q.length()),
					# Guarda en query el resultado de q.
					query = q
				# Ejecuta esta instruccion: }).
				})
				# Guarda en index el resultado de find_in_line(lines[i], q, index + q.length()).
				index = find_in_line(lines[i], q, index + q.length())

		# Comprueba file != null and file.is_open(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if file != null and file.is_open():
			# Llama al metodo file.close para realizar esta accion en este punto.
			file.close()

		# Comprueba path_results.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if path_results.size() > 0:
			# Ejecuta esta instruccion: results[path] = path_results.
			results[path] = path_results

	# Termina el metodo y devuelve results a quien lo llamo.
	return results


# Define el metodo get_selection_key para agrupar esta accion del script.
func get_selection_key(path: String, path_result: Dictionary) -> String:
	# Termina el metodo y devuelve "%s-%d-%d" % [path, path_result.line, path_result.index] a quien lo llamo.
	return "%s-%d-%d" % [path, path_result.line, path_result.index]


# Define el metodo find_in_line para agrupar esta accion del script.
func find_in_line(line: String, query: String, from_index: int = 0) -> int:
	# Comprueba match_case_button.button_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if match_case_button.button_pressed:
		# Termina el metodo y devuelve line.find(query, from_index) a quien lo llamo.
		return line.find(query, from_index)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve line.findn(query, from_index) a quien lo llamo.
		return line.findn(query, from_index)


# Define el metodo replace_results para agrupar esta accion del script.
func replace_results(only_selected: bool) -> void:
	# Declara file para guardar un dato utilizado por este script.
	var file: FileAccess
	# Crea lines e inicializa su valor con [].
	var lines: PackedStringArray = []
	# Recorre current_results y asigna cada elemento a path en cada vuelta.
	for path in current_results:
		# Comprueba main_view.open_buffers.has(path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if main_view.open_buffers.has(path):
			# Guarda en lines el resultado de main_view.open_buffers.get(path).text.split("\n").
			lines = main_view.open_buffers.get(path).text.split("\n")
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en file el resultado de FileAccess.open(path, FileAccess.READ_WRITE).
			file = FileAccess.open(path, FileAccess.READ_WRITE)
			# Guarda en lines el resultado de file.get_as_text().split("\n").
			lines = file.get_as_text().split("\n")

		# Read the results in reverse because we're going to be modifying them as we go
		var path_results: Array = current_results.get(path).duplicate()
		# Llama al metodo path_results.reverse para realizar esta accion en este punto.
		path_results.reverse()
		# Recorre path_results y asigna cada elemento a path_result en cada vuelta.
		for path_result in path_results:
			# Crea key e inicializa su valor con get_selection_key(path, path_result).
			var key: String = get_selection_key(path, path_result)
			# Comprueba not only_selected or (only_selected and selections.has(key)); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not only_selected or (only_selected and selections.has(key)):
				# Ejecuta esta instruccion: lines[path_result.line] = lines[path_result.line].substr(0, path_result.index) + replace_input.text + lines[path_result.line].substr(path_result.index + path_result.matched_text.length()).
				lines[path_result.line] = lines[path_result.line].substr(0, path_result.index) + replace_input.text + lines[path_result.line].substr(path_result.index + path_result.matched_text.length())

		# Crea replaced_text e inicializa su valor con "\n".join(lines).
		var replaced_text: String = "\n".join(lines)
		# Comprueba file != null and file.is_open(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if file != null and file.is_open():
			# Llama al metodo file.seek para realizar esta accion en este punto.
			file.seek(0)
			# Llama al metodo file.store_string para realizar esta accion en este punto.
			file.store_string(replaced_text)
			# Llama al metodo file.close para realizar esta accion en este punto.
			file.close()
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo main_view.open_buffers.get para realizar esta accion en este punto.
			main_view.open_buffers.get(path).text = replaced_text
			# Comprueba main_view.current_file_path == path; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if main_view.current_file_path == path:
				# Guarda en code_edit.text el resultado de replaced_text.
				code_edit.text = replaced_text

	# Guarda en current_results el resultado de find_in_files().
	current_results = find_in_files()


#endregion

#region signals


# Define el metodo _on_search_button_pressed para agrupar esta accion del script.
func _on_search_button_pressed() -> void:
	# Llama al metodo selections.clear para realizar esta accion en este punto.
	selections.clear()
	# Guarda en self.current_results el resultado de find_in_files().
	self.current_results = find_in_files()


# Define el metodo _on_input_text_submitted para agrupar esta accion del script.
func _on_input_text_submitted(new_text: String) -> void:
	# Llama al metodo _on_search_button_pressed para realizar esta accion en este punto.
	_on_search_button_pressed()


# Define el metodo _on_replace_toggle_toggled para agrupar esta accion del script.
func _on_replace_toggle_toggled(toggled_on: bool) -> void:
	# Guarda en replace_container.visible el resultado de toggled_on.
	replace_container.visible = toggled_on
	# Comprueba toggled_on; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if toggled_on:
		# Llama al metodo replace_input.grab_focus para realizar esta accion en este punto.
		replace_input.grab_focus()
	# Llama al metodo update_results_view para realizar esta accion en este punto.
	update_results_view()


# Define el metodo _on_replace_input_text_changed para agrupar esta accion del script.
func _on_replace_input_text_changed(new_text: String) -> void:
	# Llama al metodo update_results_view para realizar esta accion en este punto.
	update_results_view()


# Define el metodo _on_replace_selected_button_pressed para agrupar esta accion del script.
func _on_replace_selected_button_pressed() -> void:
	# Llama al metodo replace_results para realizar esta accion en este punto.
	replace_results(true)


# Define el metodo _on_replace_all_button_pressed para agrupar esta accion del script.
func _on_replace_all_button_pressed() -> void:
	# Llama al metodo replace_results para realizar esta accion en este punto.
	replace_results(false)


# Define el metodo _on_match_case_button_toggled para agrupar esta accion del script.
func _on_match_case_button_toggled(toggled_on: bool) -> void:
	# Llama al metodo _on_search_button_pressed para realizar esta accion en este punto.
	_on_search_button_pressed()


#endregion
