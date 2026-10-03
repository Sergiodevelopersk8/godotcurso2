# Ejecuta esta instruccion: @tool.
@tool
# Hereda de HBoxContainer y reutiliza sus propiedades y comportamiento base.
extends HBoxContainer


# Declara la seerror_pressed1al error_pressed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal error_pressed(line_number)


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")


# Obtiene la referencia error_button cuando el nodo ya esta listo.
@onready var error_button: Button = $ErrorButton
# Obtiene la referencia next_button cuando el nodo ya esta listo.
@onready var next_button: Button = $NextButton
# Obtiene la referencia count_label cuando el nodo ya esta listo.
@onready var count_label: Label = $CountLabel
# Obtiene la referencia previous_button cuando el nodo ya esta listo.
@onready var previous_button: Button = $PreviousButton

## The index of the current error being shown
var error_index: int = 0:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_error_index):
		# Guarda en error_index el resultado de wrap(next_error_index, 0, errors.size()).
		error_index = wrap(next_error_index, 0, errors.size())
		# Llama al metodo show_error para realizar esta accion en este punto.
		show_error()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve error_index a quien lo llamo.
		return error_index

## The list of all errors
var errors: Array = []:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_errors):
		# Guarda en errors el resultado de next_errors.
		errors = next_errors
		# Guarda en self.error_index el resultado de 0.
		self.error_index = 0
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve errors a quien lo llamo.
		return errors


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()
	# Llama al metodo hide para realizar esta accion en este punto.
	hide()


## Set up colors and icons
func apply_theme() -> void:
	# Llama al metodo error_button.add_theme_color_override para realizar esta accion en este punto.
	error_button.add_theme_color_override("font_color", get_theme_color("error_color", "Editor"))
	# Llama al metodo error_button.add_theme_color_override para realizar esta accion en este punto.
	error_button.add_theme_color_override("font_hover_color", get_theme_color("error_color", "Editor"))
	# Guarda en error_button.icon el resultado de get_theme_icon("StatusError", "EditorIcons").
	error_button.icon = get_theme_icon("StatusError", "EditorIcons")
	# Guarda en previous_button.icon el resultado de get_theme_icon("ArrowLeft", "EditorIcons").
	previous_button.icon = get_theme_icon("ArrowLeft", "EditorIcons")
	# Guarda en next_button.icon el resultado de get_theme_icon("ArrowRight", "EditorIcons").
	next_button.icon = get_theme_icon("ArrowRight", "EditorIcons")


## Move the error index to match a given line
func show_error_for_line_number(line_number: int) -> void:
	# Recorre range(0, errors.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, errors.size()):
		# Comprueba errors[i].line_number == line_number; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if errors[i].line_number == line_number:
			# Guarda en self.error_index el resultado de i.
			self.error_index = i


## Show the current error
func show_error() -> void:
	# Comprueba errors.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if errors.size() == 0:
		# Llama al metodo hide para realizar esta accion en este punto.
		hide()
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo show para realizar esta accion en este punto.
		show()
		# Guarda en count_label.text el resultado de DialogueConstants.translate(&"n_of_n").format({ index = error_index + 1, total = errors.size() }).
		count_label.text = DialogueConstants.translate(&"n_of_n").format({ index = error_index + 1, total = errors.size() })
		# Crea error e inicializa su valor con errors[error_index].
		var error = errors[error_index]
		# Guarda en error_button.text el resultado de DialogueConstants.translate(&"errors.line_and_message").format({ line = error.line_number, column = error.column_number, message = DialogueConstants.get_error_message(error.error) }).
		error_button.text = DialogueConstants.translate(&"errors.line_and_message").format({ line = error.line_number, column = error.column_number, message = DialogueConstants.get_error_message(error.error) })
		# Comprueba error.has("external_error"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if error.has("external_error"):
			# Suma a error_button.text el valor " " + DialogueConstants.get_error_message(error.external_error) respecto de su valor anterior.
			error_button.text += " " + DialogueConstants.get_error_message(error.external_error)


### Signals


# Define el metodo _on_errors_panel_theme_changed para agrupar esta accion del script.
func _on_errors_panel_theme_changed() -> void:
	# Llama al metodo apply_theme para realizar esta accion en este punto.
	apply_theme()


# Define el metodo _on_error_button_pressed para agrupar esta accion del script.
func _on_error_button_pressed() -> void:
	# Emite la senal error_pressed con estos datos: errors[error_index].line_number, errors[error_index].column_number.
	error_pressed.emit(errors[error_index].line_number, errors[error_index].column_number)


# Define el metodo _on_previous_button_pressed para agrupar esta accion del script.
func _on_previous_button_pressed() -> void:
	# Resta de self.error_index el valor 1 respecto de su valor anterior.
	self.error_index -= 1
	# Llama al metodo _on_error_button_pressed para realizar esta accion en este punto.
	_on_error_button_pressed()


# Define el metodo _on_next_button_pressed para agrupar esta accion del script.
func _on_next_button_pressed() -> void:
	# Suma a self.error_index el valor 1 respecto de su valor anterior.
	self.error_index += 1
	# Llama al metodo _on_error_button_pressed para realizar esta accion en este punto.
	_on_error_button_pressed()
