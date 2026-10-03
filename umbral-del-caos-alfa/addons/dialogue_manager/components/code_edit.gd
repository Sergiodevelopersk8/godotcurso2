# Ejecuta esta instruccion: @tool.
@tool
# Registra DMCodeEdit como nombre de clase global para usarlo en otros scripts.
class_name DMCodeEdit extends CodeEdit


# Declara la seactive_title_change1al active_title_change; otros nodos pueden conectarse para reaccionar cuando se emita.
signal active_title_change(title: String)
# Declara la seerror_clicked1al error_clicked; otros nodos pueden conectarse para reaccionar cuando se emita.
signal error_clicked(line_number: int)
# Declara la seexternal_file_requested1al external_file_requested; otros nodos pueden conectarse para reaccionar cuando se emita.
signal external_file_requested(path: String, title: String)


# A link back to the owner `MainView`
var main_view

# Theme overrides for syntax highlighting, etc
var theme_overrides: Dictionary:
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Guarda en theme_overrides el resultado de value.
		theme_overrides = value

		# Guarda en syntax_highlighter el resultado de DMSyntaxHighlighter.new().
		syntax_highlighter = DMSyntaxHighlighter.new()

		# General UI
		add_theme_color_override("font_color", theme_overrides.text_color)
		# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
		add_theme_color_override("background_color", theme_overrides.background_color)
		# Llama al metodo add_theme_color_override para realizar esta accion en este punto.
		add_theme_color_override("current_line_color", theme_overrides.current_line_color)
		# Llama al metodo add_theme_font_override para realizar esta accion en este punto.
		add_theme_font_override("font", get_theme_font("source", "EditorFonts"))
		# Llama al metodo add_theme_font_size_override para realizar esta accion en este punto.
		add_theme_font_size_override("font_size", theme_overrides.font_size * theme_overrides.scale)
		# Guarda en font_size el resultado de round(theme_overrides.font_size).
		font_size = round(theme_overrides.font_size)
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve theme_overrides a quien lo llamo.
		return theme_overrides

# Any parse errors
var errors: Array:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_errors):
		# Guarda en errors el resultado de next_errors.
		errors = next_errors
		# Recorre range(0, get_line_count()) y asigna cada elemento a i en cada vuelta.
		for i in range(0, get_line_count()):
			# Crea is_error e inicializa su valor con false.
			var is_error: bool = false
			# Recorre errors y asigna cada elemento a error en cada vuelta.
			for error in errors:
				# Comprueba error.line_number == i; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if error.line_number == i:
					# Guarda en is_error el resultado de true.
					is_error = true
			# Llama al metodo mark_line_as_error para realizar esta accion en este punto.
			mark_line_as_error(i, is_error)
		# Llama al metodo _on_code_edit_caret_changed para realizar esta accion en este punto.
		_on_code_edit_caret_changed()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve errors a quien lo llamo.
		return errors

# The last selection (if there was one) so we can remember it for refocusing
var last_selected_text: String

# Declara font_size para guardar un dato utilizado por este script.
var font_size: int:
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Guarda en font_size el resultado de value.
		font_size = value
		# Llama al metodo add_theme_font_size_override para realizar esta accion en este punto.
		add_theme_font_size_override("font_size", font_size * theme_overrides.scale)
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve font_size a quien lo llamo.
		return font_size

# Crea WEIGHTED_RANDOM_PREFIX e inicializa su valor con RegEx.create_from_string("^\\%[\\d.]+\\s").
var WEIGHTED_RANDOM_PREFIX: RegEx = RegEx.create_from_string("^\\%[\\d.]+\\s")

# Crea compiler_regex e inicializa su valor con DMCompilerRegEx.new().
var compiler_regex: DMCompilerRegEx = DMCompilerRegEx.new()
# Crea _autoloads e inicializa su valor con {}.
var _autoloads: Dictionary[String, String] = {}
# Crea _autoload_member_cache e inicializa su valor con {}.
var _autoload_member_cache: Dictionary[String, Dictionary] = {}


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Add error gutter
	add_gutter(0)
	# Llama al metodo set_gutter_type para realizar esta accion en este punto.
	set_gutter_type(0, TextEdit.GUTTER_TYPE_ICON)

	# Add comment delimiter
	if not has_comment_delimiter("#"):
		# Llama al metodo add_comment_delimiter para realizar esta accion en este punto.
		add_comment_delimiter("#", "", true)

	# Guarda en syntax_highlighter el resultado de DMSyntaxHighlighter.new().
	syntax_highlighter = DMSyntaxHighlighter.new()

	# Keep track of any autoloads
	ProjectSettings.settings_changed.connect(_on_project_settings_changed)
	# Llama al metodo _on_project_settings_changed para realizar esta accion en este punto.
	_on_project_settings_changed()


# Define el metodo _gui_input para agrupar esta accion del script.
func _gui_input(event: InputEvent) -> void:
	# Handle shortcuts that come from the editor
	if event is InputEventKey and event.is_pressed():
		# Crea shortcut e inicializa su valor con Engine.get_meta("DialogueManagerPlugin").get_editor_shortcut(event).
		var shortcut: String = Engine.get_meta("DialogueManagerPlugin").get_editor_shortcut(event)
		# Compara shortcut con los casos siguientes y ejecuta el que coincida.
		match shortcut:
			# Asocia la clave "toggle_comment" con  dentro del diccionario.
			"toggle_comment":
				# Llama al metodo toggle_comment para realizar esta accion en este punto.
				toggle_comment()
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Asocia la clave "delete_line" con  dentro del diccionario.
			"delete_line":
				# Llama al metodo delete_current_line para realizar esta accion en este punto.
				delete_current_line()
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Asocia la clave "move_up" con  dentro del diccionario.
			"move_up":
				# Llama al metodo move_line para realizar esta accion en este punto.
				move_line(-1)
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Asocia la clave "move_down" con  dentro del diccionario.
			"move_down":
				# Llama al metodo move_line para realizar esta accion en este punto.
				move_line(1)
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Asocia la clave "text_size_increase" con  dentro del diccionario.
			"text_size_increase":
				# Suma a self.font_size el valor 1 respecto de su valor anterior.
				self.font_size += 1
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Asocia la clave "text_size_decrease" con  dentro del diccionario.
			"text_size_decrease":
				# Resta de self.font_size el valor 1 respecto de su valor anterior.
				self.font_size -= 1
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Asocia la clave "text_size_reset" con  dentro del diccionario.
			"text_size_reset":
				# Guarda en self.font_size el resultado de theme_overrides.font_size.
				self.font_size = theme_overrides.font_size
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()

	# Comprueba event is InputEventMouse si las condiciones anteriores resultaron falsas.
	elif event is InputEventMouse:
		# Compara event.as_text() con los casos siguientes y ejecuta el que coincida.
		match event.as_text():
			# Ejecuta esta instruccion: "Ctrl+Mouse Wheel Up", "Command+Mouse Wheel Up":.
			"Ctrl+Mouse Wheel Up", "Command+Mouse Wheel Up":
				# Suma a self.font_size el valor 1 respecto de su valor anterior.
				self.font_size += 1
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()
			# Ejecuta esta instruccion: "Ctrl+Mouse Wheel Down", "Command+Mouse Wheel Down":.
			"Ctrl+Mouse Wheel Down", "Command+Mouse Wheel Down":
				# Resta de self.font_size el valor 1 respecto de su valor anterior.
				self.font_size -= 1
				# Llama al metodo get_viewport para realizar esta accion en este punto.
				get_viewport().set_input_as_handled()


# Define el metodo _can_drop_data para agrupar esta accion del script.
func _can_drop_data(at_position: Vector2, data) -> bool:
	# Ejecuta esta instruccion: if typeof(data) != TYPE_DICTIONARY: return false.
	if typeof(data) != TYPE_DICTIONARY: return false
	# Ejecuta esta instruccion: if data.type != "files": return false.
	if data.type != "files": return false

	# Crea files e inicializa su valor con Array(data.files).
	var files: PackedStringArray = Array(data.files)
	# Termina el metodo y devuelve files.size() > 0 a quien lo llamo.
	return files.size() > 0


# Define el metodo _drop_data para agrupar esta accion del script.
func _drop_data(at_position: Vector2, data) -> void:
	# Crea replace_regex e inicializa su valor con RegEx.create_from_string("[^a-zA-Z_0-9]+").
	var replace_regex: RegEx = RegEx.create_from_string("[^a-zA-Z_0-9]+")

	# Crea files e inicializa su valor con Array(data.files).
	var files: PackedStringArray = Array(data.files)
	# Recorre files y asigna cada elemento a file en cada vuelta.
	for file in files:
		# Don't import the file into itself
		if file == main_view.current_file_path: continue

		# Comprueba file.get_extension() == "dialogue"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if file.get_extension() == "dialogue":
			# Crea path e inicializa su valor con file.replace("res://", "").replace(".dialogue", "").
			var path = file.replace("res://", "").replace(".dialogue", "")
			# Find the first non-import line in the file to add our import
			var lines = text.split("\n")
			# Recorre range(0, lines.size()) y asigna cada elemento a i en cada vuelta.
			for i in range(0, lines.size()):
				# Comprueba not lines[i].begins_with("import "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if not lines[i].begins_with("import "):
					# Llama al metodo insert_line_at para realizar esta accion en este punto.
					insert_line_at(i, "import \"%s\" as %s\n" % [file, replace_regex.sub(path, "_", true)])
					# Llama al metodo set_caret_line para realizar esta accion en este punto.
					set_caret_line(i)
					# Termina inmediatamente el bucle actual.
					break
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Crea cursor e inicializa su valor con get_line_column_at_pos(at_position).
			var cursor: Vector2 = get_line_column_at_pos(at_position)
			# Comprueba cursor.x > -1 and cursor.y > -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if cursor.x > -1 and cursor.y > -1:
				# Llama al metodo set_cursor para realizar esta accion en este punto.
				set_cursor(cursor)
				# Llama al metodo remove_secondary_carets para realizar esta accion en este punto.
				remove_secondary_carets()
				# Llama al metodo insert_text para realizar esta accion en este punto.
				insert_text("\"%s\"" % file, cursor.y, cursor.x)
	# Llama al metodo grab_focus para realizar esta accion en este punto.
	grab_focus()


# Define el metodo _request_code_completion para agrupar esta accion del script.
func _request_code_completion(force: bool) -> void:
	# Crea cursor e inicializa su valor con get_cursor().
	var cursor: Vector2 = get_cursor()
	# Crea current_line e inicializa su valor con get_line(cursor.y).
	var current_line: String = get_line(cursor.y)

	# Match jumps
	if ("=> " in current_line or "=>< " in current_line) and (cursor.x > current_line.find("=>")):
		# Crea prompt e inicializa su valor con current_line.split("=>")[1].
		var prompt: String = current_line.split("=>")[1]
		# Comprueba prompt.begins_with("< "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if prompt.begins_with("< "):
			# Guarda en prompt el resultado de prompt.substr(2).
			prompt = prompt.substr(2)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en prompt el resultado de prompt.substr(1).
			prompt = prompt.substr(1)

		# Comprueba "=> " in current_line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if "=> " in current_line:
			# Comprueba matches_prompt(prompt, "end"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if matches_prompt(prompt, "end"):
				# Llama al metodo add_code_completion_option para realizar esta accion en este punto.
				add_code_completion_option(CodeEdit.KIND_CLASS, "END", "END".substr(prompt.length()), theme_overrides.text_color, get_theme_icon("Stop", "EditorIcons"))
			# Comprueba matches_prompt(prompt, "end!"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if matches_prompt(prompt, "end!"):
				# Llama al metodo add_code_completion_option para realizar esta accion en este punto.
				add_code_completion_option(CodeEdit.KIND_CLASS, "END!", "END!".substr(prompt.length()), theme_overrides.text_color, get_theme_icon("Stop", "EditorIcons"))

		# Get all titles, including those in imports
		for title: String in DMCompiler.get_titles_in_text(text, main_view.current_file_path):
			# Ignore any imported titles that aren't resolved to human readable.
			if title.to_int() > 0:
				# Pasa directamente a la siguiente vuelta del bucle.
				continue

			# Comprueba "/" in title si las condiciones anteriores resultaron falsas.
			elif "/" in title:
				# Crea bits e inicializa su valor con title.split("/").
				var bits = title.split("/")
				# Comprueba matches_prompt(prompt, bits[0]) or matches_prompt(prompt, bits[1]); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if matches_prompt(prompt, bits[0]) or matches_prompt(prompt, bits[1]):
					# Llama al metodo add_code_completion_option para realizar esta accion en este punto.
					add_code_completion_option(CodeEdit.KIND_CLASS, title, title.substr(prompt.length()), theme_overrides.text_color, get_theme_icon("CombineLines", "EditorIcons"))
			# Comprueba matches_prompt(prompt, title) si las condiciones anteriores resultaron falsas.
			elif matches_prompt(prompt, title):
				# Llama al metodo add_code_completion_option para realizar esta accion en este punto.
				add_code_completion_option(CodeEdit.KIND_CLASS, title, title.substr(prompt.length()), theme_overrides.text_color, get_theme_icon("ArrowRight", "EditorIcons"))

	# Match character names
	var name_so_far: String = WEIGHTED_RANDOM_PREFIX.sub(current_line.strip_edges(), "")
	# Comprueba name_so_far != "" and name_so_far[0].to_upper() == name_so_far[0]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if name_so_far != "" and name_so_far[0].to_upper() == name_so_far[0]:
		# Only show names starting with that character
		var names: PackedStringArray = get_character_names(name_so_far)
		# Comprueba names.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if names.size() > 0:
			# Recorre names y asigna cada elemento a name en cada vuelta.
			for name in names:
				# Llama al metodo add_code_completion_option para realizar esta accion en este punto.
				add_code_completion_option(CodeEdit.KIND_CLASS, name + ": ", name.substr(name_so_far.length()) + ": ", theme_overrides.text_color, get_theme_icon("Sprite2D", "EditorIcons"))

	# Match autoloads on mutation lines
	for prefix in ["do ", "set ", "if ", "elif ", "else if ", "match ", "when ", "using "]:
		# Comprueba (current_line.strip_edges().begins_with(prefix) and (cursor.x > current_line.find(prefix))); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if (current_line.strip_edges().begins_with(prefix) and (cursor.x > current_line.find(prefix))):
			# Crea expression e inicializa su valor con current_line.substr(0, cursor.x).strip_edges().substr(3).
			var expression: String = current_line.substr(0, cursor.x).strip_edges().substr(3)
			# Find the last couple of tokens
			var possible_prompt: String = expression.reverse()
			# Guarda en possible_prompt el resultado de possible_prompt.substr(0, possible_prompt.find(" ")).
			possible_prompt = possible_prompt.substr(0, possible_prompt.find(" "))
			# Guarda en possible_prompt el resultado de possible_prompt.substr(0, possible_prompt.find("(")).
			possible_prompt = possible_prompt.substr(0, possible_prompt.find("("))
			# Guarda en possible_prompt el resultado de possible_prompt.reverse().
			possible_prompt = possible_prompt.reverse()
			# Crea segments e inicializa su valor con possible_prompt.split(".").slice(-2).
			var segments: PackedStringArray = possible_prompt.split(".").slice(-2)
			# Crea auto_completes e inicializa su valor con [].
			var auto_completes: Array[Dictionary] = []

			# Autoloads and state shortcuts
			if segments.size() == 1:
				# Crea prompt e inicializa su valor con segments[0].
				var prompt: String = segments[0]
				# Recorre _autoloads.keys() y asigna cada elemento a autoload en cada vuelta.
				for autoload in _autoloads.keys():
					# Comprueba matches_prompt(prompt, autoload); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if matches_prompt(prompt, autoload):
						# Llama al metodo auto_completes.append para realizar esta accion en este punto.
						auto_completes.append({
							# Guarda en prompt el resultado de prompt,.
							prompt = prompt,
							# Guarda en text el resultado de autoload,.
							text = autoload,
							# Guarda en type el resultado de "script".
							type = "script"
						# Ejecuta esta instruccion: }).
						})
				# Recorre get_state_shortcuts() y asigna cada elemento a autoload en cada vuelta.
				for autoload in get_state_shortcuts():
					# Ejecuta esta instruccion: for member: Dictionary in get_members_for_autoload(autoload):.
					for member: Dictionary in get_members_for_autoload(autoload):
						# Comprueba matches_prompt(prompt, member.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
						if matches_prompt(prompt, member.name):
							# Llama al metodo auto_completes.append para realizar esta accion en este punto.
							auto_completes.append({
								# Guarda en prompt el resultado de prompt,.
								prompt = prompt,
								# Guarda en text el resultado de member.name,.
								text = member.name,
								# Guarda en type el resultado de member.type.
								type = member.type
							# Ejecuta esta instruccion: }).
							})

			# Members of an autoload
			elif segments[0] in _autoloads.keys() and not current_line.strip_edges().begins_with("using "):
				# Crea prompt e inicializa su valor con segments[1].
				var prompt: String = segments[1]
				# Ejecuta esta instruccion: for member: Dictionary in get_members_for_autoload(segments[0]):.
				for member: Dictionary in get_members_for_autoload(segments[0]):
					# Comprueba matches_prompt(prompt, member.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if matches_prompt(prompt, member.name):
						# Llama al metodo auto_completes.append para realizar esta accion en este punto.
						auto_completes.append({
							# Guarda en prompt el resultado de prompt,.
							prompt = prompt,
							# Guarda en text el resultado de member.name,.
							text = member.name,
							# Guarda en type el resultado de member.type.
							type = member.type
						# Ejecuta esta instruccion: }).
						})

			# Llama al metodo auto_completes.sort_custom para realizar esta accion en este punto.
			auto_completes.sort_custom(func(a, b): return a.text < b.text)

			# Recorre auto_completes y asigna cada elemento a auto_complete en cada vuelta.
			for auto_complete in auto_completes:
				# Declara icon para guardar un dato utilizado por este script.
				var icon: Texture2D
				# Crea text e inicializa su valor con auto_complete.text.
				var text: String = auto_complete.text
				# Compara auto_complete.type con los casos siguientes y ejecuta el que coincida.
				match auto_complete.type:
					# Asocia la clave "script" con  dentro del diccionario.
					"script":
						# Guarda en icon el resultado de get_theme_icon("Script", "EditorIcons").
						icon = get_theme_icon("Script", "EditorIcons")
					# Asocia la clave "property" con  dentro del diccionario.
					"property":
						# Guarda en icon el resultado de get_theme_icon("MemberProperty", "EditorIcons").
						icon = get_theme_icon("MemberProperty", "EditorIcons")
					# Asocia la clave "method" con  dentro del diccionario.
					"method":
						# Guarda en icon el resultado de get_theme_icon("MemberMethod", "EditorIcons").
						icon = get_theme_icon("MemberMethod", "EditorIcons")
						# Suma a text el valor "()" respecto de su valor anterior.
						text += "()"
					# Asocia la clave "signal" con  dentro del diccionario.
					"signal":
						# Guarda en icon el resultado de get_theme_icon("MemberSignal", "EditorIcons").
						icon = get_theme_icon("MemberSignal", "EditorIcons")
					# Asocia la clave "constant" con  dentro del diccionario.
					"constant":
						# Guarda en icon el resultado de get_theme_icon("MemberConstant", "EditorIcons").
						icon = get_theme_icon("MemberConstant", "EditorIcons")
				# Crea insert e inicializa su valor con text.substr(auto_complete.prompt.length()).
				var insert: String = text.substr(auto_complete.prompt.length())
				# Llama al metodo add_code_completion_option para realizar esta accion en este punto.
				add_code_completion_option(CodeEdit.KIND_CLASS, text, insert, theme_overrides.text_color, icon)

	# Llama al metodo update_code_completion_options para realizar esta accion en este punto.
	update_code_completion_options(true)
	# Comprueba get_code_completion_options().size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if get_code_completion_options().size() == 0:
		# Llama al metodo cancel_code_completion para realizar esta accion en este punto.
		cancel_code_completion()


# Define el metodo _filter_code_completion_candidates para agrupar esta accion del script.
func _filter_code_completion_candidates(candidates: Array) -> Array:
	# Not sure why but if this method isn't overridden then all completions are wrapped in quotes.
	return candidates


# Define el metodo _confirm_code_completion para agrupar esta accion del script.
func _confirm_code_completion(replace: bool) -> void:
	# Crea completion e inicializa su valor con get_code_completion_option(get_code_completion_selected_index()).
	var completion = get_code_completion_option(get_code_completion_selected_index())
	# Llama al metodo begin_complex_operation para realizar esta accion en este punto.
	begin_complex_operation()
	# Delete any part of the text that we've already typed
	if completion.insert_text.length() > 0:
		# Recorre range(0, completion.display_text.length() - completion.insert_text.length()) y asigna cada elemento a i en cada vuelta.
		for i in range(0, completion.display_text.length() - completion.insert_text.length()):
			# Llama al metodo backspace para realizar esta accion en este punto.
			backspace()
	# Insert the whole match
	insert_text_at_caret(completion.display_text)
	# Llama al metodo end_complex_operation para realizar esta accion en este punto.
	end_complex_operation()

	# Comprueba completion.display_text.ends_with("()"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if completion.display_text.ends_with("()"):
		# Llama al metodo set_cursor para realizar esta accion en este punto.
		set_cursor(get_cursor() - Vector2.RIGHT)

	# Close the autocomplete menu on the next tick
	call_deferred("cancel_code_completion")


#region Helpers


# Get the current caret as a Vector2
func get_cursor() -> Vector2:
	# Termina el metodo y devuelve Vector2(get_caret_column(), get_caret_line()) a quien lo llamo.
	return Vector2(get_caret_column(), get_caret_line())


# Set the caret from a Vector2
func set_cursor(from_cursor: Vector2) -> void:
	# Llama al metodo set_caret_line para realizar esta accion en este punto.
	set_caret_line(from_cursor.y, false)
	# Llama al metodo set_caret_column para realizar esta accion en este punto.
	set_caret_column(from_cursor.x, false)


# Check if a prompt is the start of a string without actually being that string
func matches_prompt(prompt: String, matcher: String) -> bool:
	# Termina el metodo y devuelve prompt.length() < matcher.length() and matcher.to_lower().begins_with(prompt.to_lower()) a quien lo llamo.
	return prompt.length() < matcher.length() and matcher.to_lower().begins_with(prompt.to_lower())


# Define el metodo get_state_shortcuts para agrupar esta accion del script.
func get_state_shortcuts() -> PackedStringArray:
	# Get any shortcuts defined in settings
	var shortcuts: PackedStringArray = DMSettings.get_setting(DMSettings.STATE_AUTOLOAD_SHORTCUTS, [])
	# Check for "using" clauses
	for line: String in text.split("\n"):
		# Crea found e inicializa su valor con compiler_regex.USING_REGEX.search(line).
		var found: RegExMatch = compiler_regex.USING_REGEX.search(line)
		# Comprueba found; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if found:
			# Llama al metodo shortcuts.append para realizar esta accion en este punto.
			shortcuts.append(found.strings[found.names.state])
	# Check for any other script sources
	for extra_script_source in DMSettings.get_setting(DMSettings.EXTRA_AUTO_COMPLETE_SCRIPT_SOURCES, []):
		# Llama al metodo shortcuts.append para realizar esta accion en este punto.
		shortcuts.append(extra_script_source)

	# Termina el metodo y devuelve shortcuts a quien lo llamo.
	return shortcuts


# Define el metodo get_members_for_autoload para agrupar esta accion del script.
func get_members_for_autoload(autoload_name: String) -> Array[Dictionary]:
	# Debounce method list lookups
	if _autoload_member_cache.has(autoload_name) and _autoload_member_cache.get(autoload_name).get("at") > Time.get_ticks_msec() - 5000:
		# Termina el metodo y devuelve _autoload_member_cache.get(autoload_name).get("members") a quien lo llamo.
		return _autoload_member_cache.get(autoload_name).get("members")

	# Ejecuta esta instruccion: if not _autoloads.has(autoload_name) and not autoload_name.begins_with("res://") and not autoload_name.begins_with("uid://"): return [].
	if not _autoloads.has(autoload_name) and not autoload_name.begins_with("res://") and not autoload_name.begins_with("uid://"): return []

	# Crea autoload e inicializa su valor con load(_autoloads.get(autoload_name, autoload_name)).
	var autoload = load(_autoloads.get(autoload_name, autoload_name))
	# Crea script e inicializa su valor con autoload if autoload is Script else autoload.get_script().
	var script: Script = autoload if autoload is Script else autoload.get_script()

	# Ejecuta esta instruccion: if not is_instance_valid(script): return [].
	if not is_instance_valid(script): return []

	# Crea members e inicializa su valor con [].
	var members: Array[Dictionary] = []
	# Comprueba script.resource_path.ends_with(".gd"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if script.resource_path.ends_with(".gd"):
		# Ejecuta esta instruccion: for m: Dictionary in script.get_script_method_list():.
		for m: Dictionary in script.get_script_method_list():
			# Comprueba not m.name.begins_with("@"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not m.name.begins_with("@"):
				# Llama al metodo members.append para realizar esta accion en este punto.
				members.append({
					# Guarda en name el resultado de m.name,.
					name = m.name,
					# Guarda en type el resultado de "method".
					type = "method"
				# Ejecuta esta instruccion: }).
				})
		# Ejecuta esta instruccion: for m: Dictionary in script.get_script_property_list():.
		for m: Dictionary in script.get_script_property_list():
			# Llama al metodo members.append para realizar esta accion en este punto.
			members.append({
				# Guarda en name el resultado de m.name,.
				name = m.name,
				# Guarda en type el resultado de "property".
				type = "property"
			# Ejecuta esta instruccion: }).
			})
		# Ejecuta esta instruccion: for m: Dictionary in script.get_script_signal_list():.
		for m: Dictionary in script.get_script_signal_list():
			# Llama al metodo members.append para realizar esta accion en este punto.
			members.append({
				# Guarda en name el resultado de m.name,.
				name = m.name,
				# Guarda en type el resultado de "signal".
				type = "signal"
			# Ejecuta esta instruccion: }).
			})
		# Ejecuta esta instruccion: for c: String in script.get_script_constant_map():.
		for c: String in script.get_script_constant_map():
			# Llama al metodo members.append para realizar esta accion en este punto.
			members.append({
				# Guarda en name el resultado de c,.
				name = c,
				# Guarda en type el resultado de "constant".
				type = "constant"
			# Ejecuta esta instruccion: }).
			})
	# Comprueba script.resource_path.ends_with(".cs") si las condiciones anteriores resultaron falsas.
	elif script.resource_path.ends_with(".cs"):
		# Crea dotnet e inicializa su valor con load(Engine.get_meta("DialogueManagerPlugin").get_plugin_path() + "/DialogueManager.cs").new().
		var dotnet = load(Engine.get_meta("DialogueManagerPlugin").get_plugin_path() + "/DialogueManager.cs").new()
		# Ejecuta esta instruccion: for m: Dictionary in dotnet.GetMembersForAutoload(script):.
		for m: Dictionary in dotnet.GetMembersForAutoload(script):
			# Llama al metodo members.append para realizar esta accion en este punto.
			members.append(m)

	# Ejecuta esta instruccion: _autoload_member_cache[autoload_name] = {.
	_autoload_member_cache[autoload_name] = {
		# Guarda en at el resultado de Time.get_ticks_msec(),.
		at = Time.get_ticks_msec(),
		# Guarda en members el resultado de members.
		members = members
	}

	# Termina el metodo y devuelve members a quien lo llamo.
	return members


## Get a list of titles from the current text
func get_titles() -> PackedStringArray:
	# Crea titles e inicializa su valor con PackedStringArray([]).
	var titles = PackedStringArray([])
	# Crea lines e inicializa su valor con text.split("\n").
	var lines = text.split("\n")
	# Recorre lines y asigna cada elemento a line en cada vuelta.
	for line in lines:
		# Comprueba line.strip_edges().begins_with("~ "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if line.strip_edges().begins_with("~ "):
			# Llama al metodo titles.append para realizar esta accion en este punto.
			titles.append(line.strip_edges().substr(2))

	# Termina el metodo y devuelve titles a quien lo llamo.
	return titles


## Work out what the next title above the current line is
func check_active_title() -> void:
	# Crea line_number e inicializa su valor con get_caret_line().
	var line_number = get_caret_line()
	# Crea lines e inicializa su valor con text.split("\n").
	var lines = text.split("\n")
	# Look at each line above this one to find the next title line
	for i in range(line_number, -1, -1):
		# Comprueba lines[i].begins_with("~ "); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if lines[i].begins_with("~ "):
			# Emite la senal active_title_change con estos datos: lines[i].replace("~ ", "").
			active_title_change.emit(lines[i].replace("~ ", ""))
			# Termina el metodo sin devolver un valor.
			return

	# Emite la senal active_title_change con estos datos: "".
	active_title_change.emit("")


# Move the caret line to match a given title
func go_to_title(title: String) -> void:
	# Crea lines e inicializa su valor con text.split("\n").
	var lines = text.split("\n")
	# Recorre range(0, lines.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, lines.size()):
		# Comprueba lines[i].strip_edges() == "~ " + title; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if lines[i].strip_edges() == "~ " + title:
			# Llama al metodo set_caret_line para realizar esta accion en este punto.
			set_caret_line(i)
			# Llama al metodo center_viewport_to_caret para realizar esta accion en este punto.
			center_viewport_to_caret()


# Define el metodo get_character_names para agrupar esta accion del script.
func get_character_names(beginning_with: String) -> PackedStringArray:
	# Crea names e inicializa su valor con [].
	var names: PackedStringArray = []
	# Crea lines e inicializa su valor con text.split("\n").
	var lines = text.split("\n")
	# Recorre lines y asigna cada elemento a line en cada vuelta.
	for line in lines:
		# Comprueba ": " in line; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if ": " in line:
			# Crea name e inicializa su valor con WEIGHTED_RANDOM_PREFIX.sub(line.split(": ")[0].strip_edges(), "").
			var name: String = WEIGHTED_RANDOM_PREFIX.sub(line.split(": ")[0].strip_edges(), "")
			# Comprueba not name in names and matches_prompt(beginning_with, name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not name in names and matches_prompt(beginning_with, name):
				# Llama al metodo names.append para realizar esta accion en este punto.
				names.append(name)
	# Termina el metodo y devuelve names a quien lo llamo.
	return names


# Mark a line as an error or not
func mark_line_as_error(line_number: int, is_error: bool) -> void:
	# Lines display counting from 1 but are actually indexed from 0
	line_number -= 1

	# Ejecuta esta instruccion: if line_number < 0: return.
	if line_number < 0: return

	# Comprueba is_error; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_error:
		# Llama al metodo set_line_background_color para realizar esta accion en este punto.
		set_line_background_color(line_number, theme_overrides.error_line_color)
		# Llama al metodo set_line_gutter_icon para realizar esta accion en este punto.
		set_line_gutter_icon(line_number, 0, get_theme_icon("StatusError", "EditorIcons"))
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo set_line_background_color para realizar esta accion en este punto.
		set_line_background_color(line_number, theme_overrides.background_color)
		# Llama al metodo set_line_gutter_icon para realizar esta accion en este punto.
		set_line_gutter_icon(line_number, 0, null)


# Insert or wrap some bbcode at the caret/selection
func insert_bbcode(open_tag: String, close_tag: String = "") -> void:
	# Comprueba close_tag == ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if close_tag == "":
		# Llama al metodo insert_text_at_caret para realizar esta accion en este punto.
		insert_text_at_caret(open_tag)
		# Llama al metodo grab_focus para realizar esta accion en este punto.
		grab_focus()
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Crea selected_text e inicializa su valor con get_selected_text().
		var selected_text = get_selected_text()
		# Llama al metodo insert_text_at_caret para realizar esta accion en este punto.
		insert_text_at_caret("%s%s%s" % [open_tag, selected_text, close_tag])
		# Llama al metodo grab_focus para realizar esta accion en este punto.
		grab_focus()
		# Llama al metodo set_caret_column para realizar esta accion en este punto.
		set_caret_column(get_caret_column() - close_tag.length())

# Insert text at current caret position
# Move Caret down 1 line if not => END
func insert_text_at_cursor(text: String) -> void:
	# Comprueba text != "=> END"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if text != "=> END":
		# Llama al metodo insert_text_at_caret para realizar esta accion en este punto.
		insert_text_at_caret(text+"\n")
		# Llama al metodo set_caret_line para realizar esta accion en este punto.
		set_caret_line(get_caret_line()+1)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo insert_text_at_caret para realizar esta accion en este punto.
		insert_text_at_caret(text)
	# Llama al metodo grab_focus para realizar esta accion en este punto.
	grab_focus()


# Toggle the selected lines as comments
func toggle_comment() -> void:
	# Llama al metodo begin_complex_operation para realizar esta accion en este punto.
	begin_complex_operation()

	# Crea comment_delimiter e inicializa su valor con delimiter_comments[0].
	var comment_delimiter: String = delimiter_comments[0]
	# Crea is_first_line e inicializa su valor con true.
	var is_first_line: bool = true
	# Crea will_comment e inicializa su valor con true.
	var will_comment: bool = true
	# Crea selections e inicializa su valor con [].
	var selections: Array = []
	# Crea line_offsets e inicializa su valor con {}.
	var line_offsets: Dictionary = {}

	# Recorre range(0, get_caret_count()) y asigna cada elemento a caret_index en cada vuelta.
	for caret_index in range(0, get_caret_count()):
		# Crea from_line e inicializa su valor con get_caret_line(caret_index).
		var from_line: int = get_caret_line(caret_index)
		# Crea from_column e inicializa su valor con get_caret_column(caret_index).
		var from_column: int = get_caret_column(caret_index)
		# Crea to_line e inicializa su valor con get_caret_line(caret_index).
		var to_line: int = get_caret_line(caret_index)
		# Crea to_column e inicializa su valor con get_caret_column(caret_index).
		var to_column: int = get_caret_column(caret_index)

		# Comprueba has_selection(caret_index); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if has_selection(caret_index):
			# Guarda en from_line el resultado de get_selection_from_line(caret_index).
			from_line = get_selection_from_line(caret_index)
			# Guarda en to_line el resultado de get_selection_to_line(caret_index).
			to_line = get_selection_to_line(caret_index)
			# Guarda en from_column el resultado de get_selection_from_column(caret_index).
			from_column = get_selection_from_column(caret_index)
			# Guarda en to_column el resultado de get_selection_to_column(caret_index).
			to_column = get_selection_to_column(caret_index)

		# Llama al metodo selections.append para realizar esta accion en este punto.
		selections.append({
			# Guarda en from_line el resultado de from_line,.
			from_line = from_line,
			# Guarda en from_column el resultado de from_column,.
			from_column = from_column,
			# Guarda en to_line el resultado de to_line,.
			to_line = to_line,
			# Guarda en to_column el resultado de to_column.
			to_column = to_column
		# Ejecuta esta instruccion: }).
		})

		# Recorre range(from_line, to_line + 1) y asigna cada elemento a line_number en cada vuelta.
		for line_number in range(from_line, to_line + 1):
			# Ejecuta esta instruccion: if line_offsets.has(line_number): continue.
			if line_offsets.has(line_number): continue

			# Crea line_text e inicializa su valor con get_line(line_number).
			var line_text: String = get_line(line_number)

			# The first line determines if we are commenting or uncommentingg
			if is_first_line:
				# Guarda en is_first_line el resultado de false.
				is_first_line = false
				# Guarda en will_comment el resultado de not line_text.strip_edges().begins_with(comment_delimiter).
				will_comment = not line_text.strip_edges().begins_with(comment_delimiter)

			# Only comment/uncomment if the current line needs to
			if will_comment:
				# Llama al metodo set_line para realizar esta accion en este punto.
				set_line(line_number, comment_delimiter + line_text)
				# Ejecuta esta instruccion: line_offsets[line_number] = 1.
				line_offsets[line_number] = 1
			# Comprueba line_text.begins_with(comment_delimiter) si las condiciones anteriores resultaron falsas.
			elif line_text.begins_with(comment_delimiter):
				# Llama al metodo set_line para realizar esta accion en este punto.
				set_line(line_number, line_text.substr(comment_delimiter.length()))
				# Ejecuta esta instruccion: line_offsets[line_number] = -1.
				line_offsets[line_number] = -1
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Ejecuta esta instruccion: line_offsets[line_number] = 0.
				line_offsets[line_number] = 0

	# Recorre range(0, get_caret_count()) y asigna cada elemento a caret_index en cada vuelta.
	for caret_index in range(0, get_caret_count()):
		# Crea selection e inicializa su valor con selections[caret_index].
		var selection: Dictionary = selections[caret_index]
		# Llama al metodo select para realizar esta accion en este punto.
		select(
			# Ejecuta esta instruccion: selection.from_line,.
			selection.from_line,
			# Ejecuta esta instruccion: selection.from_column + line_offsets[selection.from_line],.
			selection.from_column + line_offsets[selection.from_line],
			# Ejecuta esta instruccion: selection.to_line,.
			selection.to_line,
			# Ejecuta esta instruccion: selection.to_column + line_offsets[selection.to_line],.
			selection.to_column + line_offsets[selection.to_line],
			# Ejecuta esta instruccion: caret_index.
			caret_index
		)
		# Llama al metodo set_caret_column para realizar esta accion en este punto.
		set_caret_column(selection.from_column + line_offsets[selection.from_line], false, caret_index)

	# Llama al metodo end_complex_operation para realizar esta accion en este punto.
	end_complex_operation()

	# Emite la senal text_set con estos datos: ninguno.
	text_set.emit()
	# Emite la senal text_changed con estos datos: ninguno.
	text_changed.emit()


# Remove the current line
func delete_current_line() -> void:
	# Crea cursor e inicializa su valor con get_cursor().
	var cursor = get_cursor()
	# Comprueba get_line_count() == 1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if get_line_count() == 1:
		# Llama al metodo select_all para realizar esta accion en este punto.
		select_all()
	# Comprueba cursor.y == 0 si las condiciones anteriores resultaron falsas.
	elif cursor.y == 0:
		# Llama al metodo select para realizar esta accion en este punto.
		select(0, 0, 1, 0)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo select para realizar esta accion en este punto.
		select(cursor.y - 1, get_line_width(cursor.y - 1), cursor.y, get_line_width(cursor.y))
	# Llama al metodo delete_selection para realizar esta accion en este punto.
	delete_selection()
	# Emite la senal text_changed con estos datos: ninguno.
	text_changed.emit()


# Move the selected lines up or down
func move_line(offset: int) -> void:
	# Guarda en offset el resultado de clamp(offset, -1, 1).
	offset = clamp(offset, -1, 1)

	# Crea starting_scroll e inicializa su valor con scroll_vertical.
	var starting_scroll := scroll_vertical
	# Crea cursor e inicializa su valor con get_cursor().
	var cursor = get_cursor()
	# Crea reselect e inicializa su valor con false.
	var reselect: bool = false
	# Crea from e inicializa su valor con cursor.y.
	var from: int = cursor.y
	# Crea to e inicializa su valor con cursor.y.
	var to: int = cursor.y
	# Comprueba has_selection(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if has_selection():
		# Guarda en reselect el resultado de true.
		reselect = true
		# Guarda en from el resultado de get_selection_from_line().
		from = get_selection_from_line()
		# Guarda en to el resultado de get_selection_to_line().
		to = get_selection_to_line()

	# Crea lines e inicializa su valor con text.split("\n").
	var lines := text.split("\n")

	# Prevent the lines from being out of bounds
	if from + offset < 0 or to + offset >= lines.size(): return

	# Crea target_from_index e inicializa su valor con from - 1 if offset == -1 else to + 1.
	var target_from_index = from - 1 if offset == -1 else to + 1
	# Crea target_to_index e inicializa su valor con to if offset == -1 else from.
	var target_to_index = to if offset == -1 else from
	# Crea line_to_move e inicializa su valor con lines[target_from_index].
	var line_to_move = lines[target_from_index]
	# Llama al metodo lines.remove_at para realizar esta accion en este punto.
	lines.remove_at(target_from_index)
	# Llama al metodo lines.insert para realizar esta accion en este punto.
	lines.insert(target_to_index, line_to_move)

	# Guarda en text el resultado de "\n".join(lines).
	text = "\n".join(lines)

	# Suma a cursor.y el valor offset respecto de su valor anterior.
	cursor.y += offset
	# Llama al metodo set_cursor para realizar esta accion en este punto.
	set_cursor(cursor)
	# Suma a from el valor offset respecto de su valor anterior.
	from += offset
	# Suma a to el valor offset respecto de su valor anterior.
	to += offset
	# Comprueba reselect; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if reselect:
		# Llama al metodo select para realizar esta accion en este punto.
		select(from, 0, to, get_line_width(to))

	# Emite la senal text_changed con estos datos: ninguno.
	text_changed.emit()
	# Guarda en scroll_vertical el resultado de starting_scroll + offset.
	scroll_vertical = starting_scroll + offset


#endregion

#region Signals


# Define el metodo _on_project_settings_changed para agrupar esta accion del script.
func _on_project_settings_changed() -> void:
	# Guarda en _autoloads el resultado de {}.
	_autoloads = {}
	# Crea project e inicializa su valor con ConfigFile.new().
	var project = ConfigFile.new()
	# Llama al metodo project.load para realizar esta accion en este punto.
	project.load("res://project.godot")
	# Recorre project.get_section_keys("autoload") y asigna cada elemento a autoload en cada vuelta.
	for autoload in project.get_section_keys("autoload"):
		# Comprueba autoload != "DialogueManager"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if autoload != "DialogueManager":
			# Ejecuta esta instruccion: _autoloads[autoload] = project.get_value("autoload", autoload).substr(1).
			_autoloads[autoload] = project.get_value("autoload", autoload).substr(1)


# Define el metodo _on_code_edit_symbol_validate para agrupar esta accion del script.
func _on_code_edit_symbol_validate(symbol: String) -> void:
	# Comprueba symbol.begins_with("res://") and symbol.ends_with(".dialogue"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if symbol.begins_with("res://") and symbol.ends_with(".dialogue"):
		# Llama al metodo set_symbol_lookup_word_as_valid para realizar esta accion en este punto.
		set_symbol_lookup_word_as_valid(true)
		# Termina el metodo sin devolver un valor.
		return

	# Recorre get_titles() y asigna cada elemento a title en cada vuelta.
	for title in get_titles():
		# Comprueba symbol == title; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if symbol == title:
			# Llama al metodo set_symbol_lookup_word_as_valid para realizar esta accion en este punto.
			set_symbol_lookup_word_as_valid(true)
			# Termina el metodo sin devolver un valor.
			return
	# Llama al metodo set_symbol_lookup_word_as_valid para realizar esta accion en este punto.
	set_symbol_lookup_word_as_valid(false)


# Define el metodo _on_code_edit_symbol_lookup para agrupar esta accion del script.
func _on_code_edit_symbol_lookup(symbol: String, line: int, column: int) -> void:
	# Comprueba symbol.begins_with("res://") and symbol.ends_with(".dialogue"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if symbol.begins_with("res://") and symbol.ends_with(".dialogue"):
		# Emite la senal external_file_requested con estos datos: symbol, "".
		external_file_requested.emit(symbol, "")
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo go_to_title para realizar esta accion en este punto.
		go_to_title(symbol)


# Define el metodo _on_code_edit_text_changed para agrupar esta accion del script.
func _on_code_edit_text_changed() -> void:
	# Llama al metodo request_code_completion para realizar esta accion en este punto.
	request_code_completion(true)


# Define el metodo _on_code_edit_text_set para agrupar esta accion del script.
func _on_code_edit_text_set() -> void:
	# Llama al metodo queue_redraw para realizar esta accion en este punto.
	queue_redraw()


# Define el metodo _on_code_edit_caret_changed para agrupar esta accion del script.
func _on_code_edit_caret_changed() -> void:
	# Llama al metodo check_active_title para realizar esta accion en este punto.
	check_active_title()
	# Guarda en last_selected_text el resultado de get_selected_text().
	last_selected_text = get_selected_text()


# Define el metodo _on_code_edit_gutter_clicked para agrupar esta accion del script.
func _on_code_edit_gutter_clicked(line: int, gutter: int) -> void:
	# Crea line_errors e inicializa su valor con errors.filter(func(error): return error.line_number == line).
	var line_errors = errors.filter(func(error): return error.line_number == line)
	# Comprueba line_errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if line_errors.size() > 0:
		# Emite la senal error_clicked con estos datos: line.
		error_clicked.emit(line)


#endregion
