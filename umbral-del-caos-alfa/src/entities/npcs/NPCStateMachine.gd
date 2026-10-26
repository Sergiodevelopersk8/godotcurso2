# res://src/entities/npcs/npc_state_machine.gd
extends Node
class_name NPCStateMachine

@export var initial_state: NodePath
var current_state = null
var states = {}

func init(npc: CharacterBody3D) -> void:
	for child in get_children():
		if child.has_method("setup"):
			child.setup(npc)
		
		states[child.name.to_lower()] = child
		
		# Verificamos de forma segura si el nodo hijo tiene la señal 'transition'
		if child.has_signal("transition"):
			child.transition.connect(_on_child_transition)
		else:
			push_warning("El nodo hijo " + child.name + " no tiene declarada la señal 'transition'.")
	
	if initial_state:
		change_state(str(get_node(initial_state).name))



func change_state(new_state_name: String) -> void:
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func _on_child_transition(state_node, new_state_name: String) -> void:
	if state_node != current_state:
		return
	change_state(new_state_name)

func update(delta: float) -> void:
	if current_state and current_state.has_method("update"):
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state and current_state.has_method("physics_update"):
		current_state.physics_update(delta)
