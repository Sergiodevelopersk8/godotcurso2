# res://src/entities/npcs/states/npc_walk.gd
extends Node
class_name NPCWalk

signal transition(state_node, new_state_name: String)

# Ya no necesitamos @export var waypoints aquí
@export var waypoint_nodes: Array[Node3D] = []
var current_index: int = 0
var player : Player
var npc: CharacterBody3D
const SPEED := 2.5
const MIN_DISTANCE := 0.5

func setup(owner_npc: CharacterBody3D) -> void:
	npc = owner_npc
	player = npc.get_tree().get_first_node_in_group("Player")
	# Buscamos automáticamente todos los nodos en el nivel que pertenezcan al grupo "waypoints_tia"
	var nodes = npc.get_tree().get_nodes_in_group("waypoints_tia")
	for node in nodes:
		if node is Node3D:
			waypoint_nodes.append(node)

func enter() -> void:
	if waypoint_nodes.is_empty():
		push_warning("[NPCWalk] No hay waypoints asignados.")

func physics_update(delta: float) -> void:
	if not waypoint_nodes.is_empty():
		walk_points(delta)
	else:
		follow_player()

func follow_player():
	var distance_to_player = npc.global_position.distance_to(player.global_position)
	var direccion = (player.global_position - npc.global_position).normalized()
	npc.velocity = direccion * SPEED
	if distance_to_player <= 2.0:
		npc.velocity = Vector3.ZERO
		transition.emit(self, "InDialogue")
	npc.move_and_slide()

func exit() -> void:
	if npc:
		npc.velocity.x = 0.0
		npc.velocity.z = 0.0

func walk_points(delta: float):
	if not npc or waypoint_nodes.is_empty():
		return

	# Aplicar gravedad básica
	if not npc.is_on_floor():
		npc.velocity.y -= 9.8 * delta
	else:
		npc.velocity.y = 0.0

	# Obtener el objetivo actual
	var target_marker = waypoint_nodes[current_index]
	var target_pos = target_marker.global_position
	target_pos.y = npc.global_position.y # Mantener la altura del NPC

	# Calcular dirección y distancia
	var direction = (target_pos - npc.global_position)
	var distance = direction.length()
	direction = direction.normalized()

	# Si llegamos al waypoint actual, pasamos al siguiente
	if distance <= MIN_DISTANCE:
		current_index = (current_index + 1) % waypoint_nodes.size() # Ciclo infinito
		return

	# Mover al NPC
	npc.velocity.x = direction.x * SPEED
	npc.velocity.z = direction.z * SPEED
	npc.move_and_slide()
