# res://src/entities/actors/customer_npc1.gd
extends CharacterBody3D
class_name CharacterNPC

@export var dialogue_resource: DialogueResource
@onready var look_me: Marker3D = $look_me
@onready var interaccion: Interact = $Interact

var is_dialogue_active: bool = false
var can_start_dialogue: bool = true
var current_player: Player = null

const DIALOGUE_COOLDOWN := 0.35

func _ready() -> void:
	if interaccion:
		interaccion.id = "Cliente 2"
		interaccion.can_be_loaded = false
		# El padre escucha la señal del área hija
		interaccion.isInteract.connect(_on_interactuado)
		
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

# Esta función se ejecuta CUANDO el área hija emite la señal 'interacted'
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
