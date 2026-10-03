# Ejecuta esta instruccion: @icon("./assets/icon.svg").
@icon("./assets/icon.svg")

# Ejecuta esta instruccion: @tool.
@tool

## A RichTextLabel specifically for use with [b]Dialogue Manager[/b] dialogue.
class_name DialogueLabel extends RichTextLabel


## Emitted for each letter typed out.
signal spoke(letter: String, letter_index: int, speed: float)

## Emitted when typing paused for a `[wait]`
signal paused_typing(duration: float)

## Emitted when the player skips the typing of dialogue.
signal skipped_typing()

## Emitted when typing finishes.
signal finished_typing()


# The action to press to skip typing.
@export var skip_action: StringName = &"ui_cancel"

## The speed with which the text types out.
@export var seconds_per_step: float = 0.02

## Automatically have a brief pause when these characters are encountered.
@export var pause_at_characters: String = ".?!"

## Don't auto pause if the character after the pause is one of these.
@export var skip_pause_at_character_if_followed_by: String = ")\""

## Don't auto pause after these abbreviations (only if "." is in `pause_at_characters`).[br]
## Abbreviations are limitted to 5 characters in length [br]
## Does not support multi-period abbreviations (ex. "p.m.")
@export var skip_pause_at_abbreviations: PackedStringArray = ["Mr", "Mrs", "Ms", "Dr", "etc", "eg", "ex"]

## The amount of time to pause when exposing a character present in `pause_at_characters`.
@export var seconds_per_pause_step: float = 0.3

# Crea _already_mutated_indices e inicializa su valor con [].
var _already_mutated_indices: PackedInt32Array = []


## The current line of dialogue.
var dialogue_line:
	# Llama al metodo set para realizar esta accion en este punto.
	set(next_dialogue_line):
		# Guarda en dialogue_line el resultado de next_dialogue_line.
		dialogue_line = next_dialogue_line
		# Guarda en custom_minimum_size el resultado de Vector2.ZERO.
		custom_minimum_size = Vector2.ZERO
		# Guarda en text el resultado de "".
		text = ""
		# Guarda en text el resultado de dialogue_line.text.
		text = dialogue_line.text
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve dialogue_line a quien lo llamo.
		return dialogue_line

## Whether the label is currently typing itself out.
var is_typing: bool = false:
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Crea is_finished e inicializa su valor con is_typing != value and value == false.
		var is_finished: bool = is_typing != value and value == false
		# Guarda en is_typing el resultado de value.
		is_typing = value
		# Comprueba is_finished; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if is_finished:
			# Emite la senal finished_typing con estos datos: ninguno.
			finished_typing.emit()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve is_typing a quien lo llamo.
		return is_typing

# Crea _last_wait_index e inicializa su valor con -1.
var _last_wait_index: int = -1
# Crea _last_mutation_index e inicializa su valor con -1.
var _last_mutation_index: int = -1
# Crea _waiting_seconds e inicializa su valor con 0.
var _waiting_seconds: float = 0
# Crea _is_awaiting_mutation e inicializa su valor con false.
var _is_awaiting_mutation: bool = false


# Define el metodo _process para agrupar esta accion del script.
func _process(delta: float) -> void:
	# Comprueba self.is_typing; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if self.is_typing:
		# Type out text
		if visible_ratio < 1:
			# See if we are waiting
			if _waiting_seconds > 0:
				# Guarda en _waiting_seconds el resultado de _waiting_seconds - delta.
				_waiting_seconds = _waiting_seconds - delta
			# If we are no longer waiting then keep typing
			if _waiting_seconds <= 0:
				# Llama al metodo _type_next para realizar esta accion en este punto.
				_type_next(delta, _waiting_seconds)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Make sure any mutations at the end of the line get run
			_mutate_inline_mutations(get_total_character_count())
			# Guarda en self.is_typing el resultado de false.
			self.is_typing = false


# Define el metodo _unhandled_input para agrupar esta accion del script.
func _unhandled_input(event: InputEvent) -> void:
	# Note: this will no longer be reached if using Dialogue Manager > 2.32.2. To make skip handling
	# simpler (so all of mouse/keyboard/joypad are together) it is now the responsibility of the
	# dialogue balloon.
	if self.is_typing and visible_ratio < 1 and InputMap.has_action(skip_action) and event.is_action_pressed(skip_action):
		# Llama al metodo get_viewport para realizar esta accion en este punto.
		get_viewport().set_input_as_handled()
		# Llama al metodo skip_typing para realizar esta accion en este punto.
		skip_typing()


## Start typing out the text
func type_out() -> void:
	# Guarda en text el resultado de dialogue_line.text.
	text = dialogue_line.text
	# Guarda en visible_characters el resultado de 0.
	visible_characters = 0
	# Guarda en visible_ratio el resultado de 0.
	visible_ratio = 0
	# Guarda en _waiting_seconds el resultado de 0.
	_waiting_seconds = 0
	# Guarda en _last_wait_index el resultado de -1.
	_last_wait_index = -1
	# Guarda en _last_mutation_index el resultado de -1.
	_last_mutation_index = -1
	# Llama al metodo _already_mutated_indices.clear para realizar esta accion en este punto.
	_already_mutated_indices.clear()

	# Guarda en self.is_typing el resultado de true.
	self.is_typing = true

	# Allow typing listeners a chance to connect
	await get_tree().process_frame

	# Comprueba get_total_character_count() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if get_total_character_count() == 0:
		# Guarda en self.is_typing el resultado de false.
		self.is_typing = false
	# Comprueba seconds_per_step == 0 si las condiciones anteriores resultaron falsas.
	elif seconds_per_step == 0:
		# Llama al metodo _mutate_remaining_mutations para realizar esta accion en este punto.
		_mutate_remaining_mutations()
		# Guarda en visible_characters el resultado de get_total_character_count().
		visible_characters = get_total_character_count()
		# Guarda en self.is_typing el resultado de false.
		self.is_typing = false


## Stop typing out the text and jump right to the end
func skip_typing() -> void:
	# Llama al metodo _mutate_remaining_mutations para realizar esta accion en este punto.
	_mutate_remaining_mutations()
	# Guarda en visible_characters el resultado de get_total_character_count().
	visible_characters = get_total_character_count()
	# Guarda en self.is_typing el resultado de false.
	self.is_typing = false
	# Emite la senal skipped_typing con estos datos: ninguno.
	skipped_typing.emit()


# Type out the next character(s)
func _type_next(delta: float, seconds_needed: float) -> void:
	# Ejecuta esta instruccion: if _is_awaiting_mutation: return.
	if _is_awaiting_mutation: return

	# Comprueba visible_characters == get_total_character_count(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if visible_characters == get_total_character_count():
		# Termina el metodo sin devolver un valor.
		return

	# Comprueba _last_mutation_index != visible_characters; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if _last_mutation_index != visible_characters:
		# Guarda en _last_mutation_index el resultado de visible_characters.
		_last_mutation_index = visible_characters
		# Llama al metodo _mutate_inline_mutations para realizar esta accion en este punto.
		_mutate_inline_mutations(visible_characters)
		# Ejecuta esta instruccion: if _is_awaiting_mutation: return.
		if _is_awaiting_mutation: return

	# Crea additional_waiting_seconds e inicializa su valor con _get_pause(visible_characters).
	var additional_waiting_seconds: float = _get_pause(visible_characters)

	# Pause on characters like "."
	if _should_auto_pause():
		# Suma a additional_waiting_seconds el valor seconds_per_pause_step respecto de su valor anterior.
		additional_waiting_seconds += seconds_per_pause_step

	# Pause at literal [wait] directives
	if _last_wait_index != visible_characters and additional_waiting_seconds > 0:
		# Guarda en _last_wait_index el resultado de visible_characters.
		_last_wait_index = visible_characters
		# Suma a _waiting_seconds el valor additional_waiting_seconds respecto de su valor anterior.
		_waiting_seconds += additional_waiting_seconds
		# Emite la senal paused_typing con estos datos: _get_pause(visible_characters).
		paused_typing.emit(_get_pause(visible_characters))
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Suma a visible_characters el valor 1 respecto de su valor anterior.
		visible_characters += 1
		# Comprueba visible_characters <= get_total_character_count(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if visible_characters <= get_total_character_count():
			# Emite la senal spoke con estos datos: get_parsed_text()[visible_characters - 1], visible_characters - 1, _get_speed(visible_characters).
			spoke.emit(get_parsed_text()[visible_characters - 1], visible_characters - 1, _get_speed(visible_characters))
		# See if there's time to type out some more in this frame
		seconds_needed += seconds_per_step * (1.0 / _get_speed(visible_characters))
		# Comprueba seconds_needed > delta; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if seconds_needed > delta:
			# Suma a _waiting_seconds el valor seconds_needed respecto de su valor anterior.
			_waiting_seconds += seconds_needed
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo _type_next para realizar esta accion en este punto.
			_type_next(delta, seconds_needed)


# Get the pause for the current typing position if there is one
func _get_pause(at_index: int) -> float:
	# Termina el metodo y devuelve dialogue_line.pauses.get(at_index, 0) a quien lo llamo.
	return dialogue_line.pauses.get(at_index, 0)


# Get the speed for the current typing position
func _get_speed(at_index: int) -> float:
	# Crea speed e inicializa su valor con 1.
	var speed: float = 1
	# Recorre dialogue_line.speeds y asigna cada elemento a index en cada vuelta.
	for index in dialogue_line.speeds:
		# Comprueba index > at_index; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if index > at_index:
			# Termina el metodo y devuelve speed a quien lo llamo.
			return speed
		# Guarda en speed el resultado de dialogue_line.speeds[index].
		speed = dialogue_line.speeds[index]
	# Termina el metodo y devuelve speed a quien lo llamo.
	return speed


# Run any inline mutations that haven't been run yet
func _mutate_remaining_mutations() -> void:
	# Recorre range(visible_characters, get_total_character_count() + 1) y asigna cada elemento a i en cada vuelta.
	for i in range(visible_characters, get_total_character_count() + 1):
		# Llama al metodo _mutate_inline_mutations para realizar esta accion en este punto.
		_mutate_inline_mutations(i)


# Run any mutations at the current typing position
func _mutate_inline_mutations(index: int) -> void:
	# Recorre dialogue_line.inline_mutations y asigna cada elemento a inline_mutation en cada vuelta.
	for inline_mutation in dialogue_line.inline_mutations:
		# inline mutations are an array of arrays in the form of [character index, resolvable function]
		if inline_mutation[0] > index:
			# Termina el metodo sin devolver un valor.
			return
		# Comprueba inline_mutation[0] == index and not _already_mutated_indices.has(index); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if inline_mutation[0] == index and not _already_mutated_indices.has(index):
			# Guarda en _is_awaiting_mutation el resultado de true.
			_is_awaiting_mutation = true
			# The DialogueManager can't be referenced directly here so we need to get it by its path
			await Engine.get_singleton("DialogueManager")._mutate(inline_mutation[1], dialogue_line.extra_game_states, true)
			# Guarda en _is_awaiting_mutation el resultado de false.
			_is_awaiting_mutation = false

	# Llama al metodo _already_mutated_indices.append para realizar esta accion en este punto.
	_already_mutated_indices.append(index)


# Determine if the current autopause character at the cursor should qualify to pause typing.
func _should_auto_pause() -> bool:
	# Ejecuta esta instruccion: if visible_characters == 0: return false.
	if visible_characters == 0: return false

	# Crea parsed_text e inicializa su valor con get_parsed_text().
	var parsed_text: String = get_parsed_text()

	# Avoid outofbounds when the label auto-translates and the text changes to one shorter while typing out
	# Note: visible characters can be larger than parsed_text after a translation event
	if visible_characters >= parsed_text.length(): return false

	# Ignore pause characters if they are next to a non-pause character
	if parsed_text[visible_characters] in skip_pause_at_character_if_followed_by.split():
		# Termina el metodo y devuelve false a quien lo llamo.
		return false

	# Ignore "." if it's between two numbers
	if visible_characters > 3 and parsed_text[visible_characters - 1] == ".":
		# Crea possible_number e inicializa su valor con parsed_text.substr(visible_characters - 2, 3).
		var possible_number: String = parsed_text.substr(visible_characters - 2, 3)
		# Comprueba str(float(possible_number)).pad_decimals(1) == possible_number; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if str(float(possible_number)).pad_decimals(1) == possible_number:
			# Termina el metodo y devuelve false a quien lo llamo.
			return false

	# Ignore "." if it's used in an abbreviation
	# Note: does NOT support multi-period abbreviations (ex. p.m.)
	if "." in pause_at_characters and parsed_text[visible_characters - 1] == ".":
		# Recorre skip_pause_at_abbreviations y asigna cada elemento a abbreviation en cada vuelta.
		for abbreviation in skip_pause_at_abbreviations:
			# Comprueba visible_characters >= abbreviation.length(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if visible_characters >= abbreviation.length():
				# Crea previous_characters e inicializa su valor con parsed_text.substr(visible_characters - abbreviation.length() - 1, abbreviation.length()).
				var previous_characters: String = parsed_text.substr(visible_characters - abbreviation.length() - 1, abbreviation.length())
				# Comprueba previous_characters == abbreviation; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if previous_characters == abbreviation:
					# Termina el metodo y devuelve false a quien lo llamo.
					return false

	# Ignore two non-"." characters next to each other
	var other_pause_characters: PackedStringArray = pause_at_characters.replace(".", "").split()
	# Comprueba visible_characters > 1 and parsed_text[visible_characters - 1] in other_pause_characters and parsed_text[visible_characters] in other_pause_characters; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if visible_characters > 1 and parsed_text[visible_characters - 1] in other_pause_characters and parsed_text[visible_characters] in other_pause_characters:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false

	# Termina el metodo y devuelve parsed_text[visible_characters - 1] in pause_at_characters.split() a quien lo llamo.
	return parsed_text[visible_characters - 1] in pause_at_characters.split()
