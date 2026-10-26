# res://src/entities/npcs/states/npc_walk.gd
extends Node
class_name NPCWalk

# DECLARACIÓN OBLIGATORIA DE LA SEÑAL (Faltaba en este script)
signal transition(state_node, new_state_name: String)

# Variable para almacenar la referencia al CharacterBody3D del NPC
var npc: CharacterBody3D
@onready var nav_agent: NavigationAgent3D = $"../../nav_agent" 

const SPEED := 2.5

func setup(owner_npc: CharacterBody3D) -> void:
	npc = owner_npc

func enter() -> void:
	print("Entrando al estado Walk")

func physics_update(delta: float) -> void:
	if not npc:
		return

	if not npc.is_on_floor():
		npc.velocity.y -= 9.8 * delta
	else:
		npc.velocity.y = 0.0

	if nav_agent.is_navigation_finished():
		return

	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var new_dir: Vector3 = (next_path_pos - npc.global_position).normalized()

	npc.velocity.x = new_dir.x * SPEED
	npc.velocity.z = new_dir.z * SPEED

	npc.move_and_slide()

func exit() -> void:
	if npc:
		npc.velocity.x = 0.0
		npc.velocity.z = 0.0
