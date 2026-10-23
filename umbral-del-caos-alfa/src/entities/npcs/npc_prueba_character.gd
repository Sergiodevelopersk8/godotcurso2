# res://src/entities/actors/customer_npc1.gd
extends CharacterBody3D
class_name CharacterNPC

@export_group("Movimiento")
@export var movement_speed: float = 2.5
@export var dialogue_resource: DialogueResource
@export var idName: String

@onready var look_me: Marker3D = $look_me
@onready var interaccion: Interact = $Interact
@onready var nav_agent: NavigationAgent3D = $nav_agent

var is_dialogue_active: bool = false
var can_start_dialogue: bool = true
var current_player: Player = null

const DIALOGUE_COOLDOWN := 0.35

func _ready() -> void:
	# 1. Configuración de la interacción
	if interaccion:
		interaccion.id = idName
		interaccion.can_be_loaded = false
		interaccion.isInteract.connect(_on_interactuado)
		
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	# 2. Configuración esencial de NavigationAgent3D
	# Esperar un frame físico para que el NavigationServer3D se sincronice con el nivel
	await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	# A. Manejo de gravedad
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0.0

	# B. Si está en diálogo o ya llegó al destino, frena horizontalmente
	if is_dialogue_active or nav_agent.is_navigation_finished():
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
		move_and_slide()
		return

	# C. Obtener el siguiente punto en la malla de navegación
	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var new_dir: Vector3 = (next_path_pos - global_position).normalized()

	velocity.x = new_dir.x * movement_speed
	velocity.z = new_dir.z * movement_speed

	# D. Orientar suavemente el cuerpo hacia la dirección del movimiento
	if new_dir.length() > 0.1:
		var target_look := Vector3(next_path_pos.x, global_position.y, next_path_pos.z)
		look_at(target_look, Vector3.UP)

	move_and_slide()

# Función para asignarle un destino desde fuera (ej. un Manager o el mapa)
func set_destination(target_position: Vector3) -> void:
	nav_agent.target_position = target_position

# --- LÓGICA DE DIÁLOGOS E INTERACCIÓN ---

func _on_interactuado() -> void:
	if is_dialogue_active or not can_start_dialogue:
		return

	if not dialogue_resource:
		push_warning("[CharacterNPC] No se asignó dialogue_resource.")
		return

	is_dialogue_active = true

	if not current_player:
		current_player = get_tree().get_first_node_in_group("Player") as Player

	if current_player and current_player.state_machine:
		current_player.state_machine.change_state("InDialogue", {"focus_target": look_me.global_position})

	DialogueManager.show_dialogue_balloon(dialogue_resource, "start")

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	if not is_dialogue_active:
		return

	is_dialogue_active = false
	can_start_dialogue = false

	if current_player and current_player.state_machine:
		current_player.state_machine.change_state("Idle")

	await get_tree().process_frame
	await get_tree().create_timer(DIALOGUE_COOLDOWN).timeout
	can_start_dialogue = true
	print("[CharacterNPC] Diálogo cerrado y listo.")
