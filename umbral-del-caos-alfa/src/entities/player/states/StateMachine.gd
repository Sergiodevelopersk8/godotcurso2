# res://src/entities/player/states/StateMachine.gd
extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# Guardamos todos los nodos hijos que sean de tipo State
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(target_state_name: String, msg: Dictionary = {}) -> void:
	if not states.has(target_state_name):
		print("[StateMachine ERROR] El estado '", target_state_name, "' no existe.")
		return
		
	if current_state:
		current_state.exit()
		
	current_state = states[target_state_name]
	current_state.enter(msg)
	print("[StateMachine] Estado cambiado a: ", target_state_name)

func get_state() -> String:
	return current_state.name if current_state else ""
