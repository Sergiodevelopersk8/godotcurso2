extends Node

signal note_opened(texture: Texture2D)
signal note_closed

var is_reading: bool = false
var can_close: bool = false # Bandera para evitar el cierre en el mismo frame

func open_note(texture: Texture2D) -> void:
	if is_reading:
		return
	is_reading = true
	can_close = false
	note_opened.emit(texture)
	
	# Damos un pequeño margen para que el motor limpie la entrada
	await get_tree().create_timer(0.15).timeout
	can_close = true

func close_note() -> void:
	if not is_reading:
		return
		
	is_reading = false
	can_close = false
	note_closed.emit()

func _input(event: InputEvent) -> void:
	# Solo cerramos si estamos leyendo Y ya pasó el frame de protección
	if is_reading and can_close and event.is_action_pressed("interact") and not event.is_echo():
		get_viewport().set_input_as_handled() # Consumimos el evento para que no se propague más
		close_note()
