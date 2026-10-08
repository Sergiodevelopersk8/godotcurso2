# res://src/entities/player/scripts/StateMachine.gd
extends Node
class_name StateMachine

signal transitioned(state_name)

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)
var current_state: State

func _ready() -> void:
	await owner.ready
	for node_child in get_children():
		if node_child is State:
			node_child.state_machine = self

	current_state = state
	current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# Función UNIFICADA que acepta un mensaje opcional
func change_state(state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(state_name):
		push_warning("[StateMachine] No existe el estado: %s" % state_name)
		return

	var new_state := get_node(state_name) as State
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	state = new_state
	
	# AQUÍ SE PASA EL DICCIONARIO 'msg' AL ESTADO
	current_state.enter(msg)
	transitioned.emit(current_state.name)

func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	change_state(state_name, msg)

func get_state() -> String:
	return current_state.name as String if current_state else ""
