# Archivo: src/ui/hud/npc_ui_dialogue/balloon.gd
# Descripci?n: Controla el globo de di?logo que muestra texto e interacci?n con el jugador.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de CanvasLayer y reutiliza sus propiedades y comportamiento base.
extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

# Crea _locale e inicializa su valor con TranslationServer.get_locale().
var _locale: String = TranslationServer.get_locale()

## The current line
var dialogue_line: DialogueLine:
	# Llama al metodo set para realizar esta accion en este punto.
	set(value):
		# Comprueba value; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if value:
			# Guarda en dialogue_line el resultado de value.
			dialogue_line = value
			# Llama al metodo apply_dialogue_line para realizar esta accion en este punto.
			apply_dialogue_line()
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# The dialogue has finished so close the balloon
			queue_free()
	# Asocia la clave get con  dentro del diccionario.
	get:
		# Termina el metodo y devuelve dialogue_line a quien lo llamo.
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

## The base balloon anchor
@onready var balloon: Control = %Balloon

## The label showing the name of the currently speaking character
@onready var character_label: RichTextLabel = %CharacterLabel

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The menu of responses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu


# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Llama al metodo balloon.hide para realizar esta accion en este punto.
	balloon.hide()
	# Llama al metodo Engine.get_singleton para realizar esta accion en este punto.
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		# Guarda en responses_menu.next_action el resultado de next_action.
		responses_menu.next_action = next_action

	# Llama al metodo mutation_cooldown.timeout.connect para realizar esta accion en este punto.
	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	# Llama al metodo add_child para realizar esta accion en este punto.
	add_child(mutation_cooldown)


# Intercepta eventos de input que no fueron consumidos por otros nodos.
func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


# Recibe notificaciones del motor y responde a cambios de idioma o eventos del sistema.
func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		# Guarda en _locale el resultado de TranslationServer.get_locale().
		_locale = TranslationServer.get_locale()
		# Crea visible_ratio e inicializa su valor con dialogue_label.visible_ratio.
		var visible_ratio = dialogue_label.visible_ratio
		# Guarda en self.dialogue_line el resultado de await resource.get_next_dialogue_line(dialogue_line.id).
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		# Comprueba visible_ratio < 1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if visible_ratio < 1:
			# Llama al metodo dialogue_label.skip_typing para realizar esta accion en este punto.
			dialogue_label.skip_typing()


## Start some dialogue
# Inicia una conversaci?n o di?logo con el recurso indicado.
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	# Guarda en temporary_game_states el resultado de [self] + extra_game_states.
	temporary_game_states = [self] + extra_game_states
	# Guarda en is_waiting_for_input el resultado de false.
	is_waiting_for_input = false
	# Guarda en resource el resultado de dialogue_resource.
	resource = dialogue_resource
	# Guarda en self.dialogue_line el resultado de await resource.get_next_dialogue_line(title, temporary_game_states).
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Apply any changes to the balloon given a new [DialogueLine].
# Actualiza el globo de di?logo con la l?nea de texto actual.
func apply_dialogue_line() -> void:
	# Llama al metodo mutation_cooldown.stop para realizar esta accion en este punto.
	mutation_cooldown.stop()

	# Guarda en is_waiting_for_input el resultado de false.
	is_waiting_for_input = false
	# Guarda en balloon.focus_mode el resultado de Control.FOCUS_ALL.
	balloon.focus_mode = Control.FOCUS_ALL
	# Llama al metodo balloon.grab_focus para realizar esta accion en este punto.
	balloon.grab_focus()

	# Guarda en character_label.visible el resultado de not dialogue_line.character.is_empty().
	character_label.visible = not dialogue_line.character.is_empty()
	# Guarda en character_label.text el resultado de tr(dialogue_line.character, "dialogue").
	character_label.text = tr(dialogue_line.character, "dialogue")

	# Llama al metodo dialogue_label.hide para realizar esta accion en este punto.
	dialogue_label.hide()
	# Guarda en dialogue_label.dialogue_line el resultado de dialogue_line.
	dialogue_label.dialogue_line = dialogue_line

	# Llama al metodo responses_menu.hide para realizar esta accion en este punto.
	responses_menu.hide()
	# Guarda en responses_menu.responses el resultado de dialogue_line.responses.
	responses_menu.responses = dialogue_line.responses

	# Show our balloon
	balloon.show()
	# Guarda en will_hide_balloon el resultado de false.
	will_hide_balloon = false

	# Llama al metodo dialogue_label.show para realizar esta accion en este punto.
	dialogue_label.show()
	# Comprueba not dialogue_line.text.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not dialogue_line.text.is_empty():
		# Llama al metodo dialogue_label.type_out para realizar esta accion en este punto.
		dialogue_label.type_out()
		# Espera a que termine dialogue_label.finished_typing antes de continuar.
		await dialogue_label.finished_typing

	# Wait for input
	if dialogue_line.responses.size() > 0:
		# Guarda en balloon.focus_mode el resultado de Control.FOCUS_NONE.
		balloon.focus_mode = Control.FOCUS_NONE
		# Llama al metodo responses_menu.show para realizar esta accion en este punto.
		responses_menu.show()
	# Comprueba dialogue_line.time != "" si las condiciones anteriores resultaron falsas.
	elif dialogue_line.time != "":
		# Crea time e inicializa su valor con dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float().
		var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		# Espera a que termine get_tree().create_timer(time).timeout antes de continuar.
		await get_tree().create_timer(time).timeout
		# Llama al metodo next para realizar esta accion en este punto.
		next(dialogue_line.next_id)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en is_waiting_for_input el resultado de true.
		is_waiting_for_input = true
		# Guarda en balloon.focus_mode el resultado de Control.FOCUS_ALL.
		balloon.focus_mode = Control.FOCUS_ALL
		# Llama al metodo balloon.grab_focus para realizar esta accion en este punto.
		balloon.grab_focus()


## Go to the next line
# Avanza a la siguiente l?nea del di?logo.
func next(next_id: String) -> void:
	# Guarda en self.dialogue_line el resultado de await resource.get_next_dialogue_line(next_id, temporary_game_states).
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


# Finaliza la ocultaci?n del globo cuando termina el tiempo de espera.
func _on_mutation_cooldown_timeout() -> void:
	# Comprueba will_hide_balloon; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if will_hide_balloon:
		# Guarda en will_hide_balloon el resultado de false.
		will_hide_balloon = false
		# Llama al metodo balloon.hide para realizar esta accion en este punto.
		balloon.hide()


# Detecta mutaciones del sistema de di?logo y prepara la siguiente acci?n.
func _on_mutated(_mutation: Dictionary) -> void:
	# Guarda en is_waiting_for_input el resultado de false.
	is_waiting_for_input = false
	# Guarda en will_hide_balloon el resultado de true.
	will_hide_balloon = true
	# Llama al metodo mutation_cooldown.start para realizar esta accion en este punto.
	mutation_cooldown.start(0.1)


# Procesa la interacci?n del usuario con el globo de di?logo.
func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		# Crea mouse_was_clicked e inicializa su valor con event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed().
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		# Crea skip_button_was_pressed e inicializa su valor con event.is_action_pressed(skip_action).
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		# Comprueba mouse_was_clicked or skip_button_was_pressed; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if mouse_was_clicked or skip_button_was_pressed:
			# Llama al metodo get_viewport para realizar esta accion en este punto.
			get_viewport().set_input_as_handled()
			# Llama al metodo dialogue_label.skip_typing para realizar esta accion en este punto.
			dialogue_label.skip_typing()
			# Termina el metodo sin devolver un valor.
			return

	# Ejecuta esta instruccion: if not is_waiting_for_input: return.
	if not is_waiting_for_input: return
	# Ejecuta esta instruccion: if dialogue_line.responses.size() > 0: return.
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	# Comprueba event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		# Llama al metodo next para realizar esta accion en este punto.
		next(dialogue_line.next_id)
	# Comprueba event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon si las condiciones anteriores resultaron falsas.
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		# Llama al metodo next para realizar esta accion en este punto.
		next(dialogue_line.next_id)


# Responde a la opci?n elegida por el jugador en el men? de respuestas.
func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	# Llama al metodo next para realizar esta accion en este punto.
	next(response.next_id)


#endregion
