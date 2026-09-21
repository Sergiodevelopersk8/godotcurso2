# res://src/entities/actors/customer_npc1.gd
extends Interact
class_name CustomerNPC1

@export var dialogue_resource: DialogueResource

var is_dialogue_active: bool = false
var can_start_dialogue: bool = true
var current_player: Player = null


const DIALOGUE_COOLDOWN := 0.35

func _ready() -> void:
	can_be_loaded = false
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func interact() -> void:
	if is_dialogue_active or not can_start_dialogue:
		return

	if not dialogue_resource:
		push_warning("[CustomerNPC1] No se asignó dialogue_resource.")
		return

	super.interact()

	is_dialogue_active = true

	if not current_player:
		current_player = get_tree().get_first_node_in_group("Player") as Player

	if current_player and current_player.state_machine:
		current_player.state_machine.change_state("InDialogue")

	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	# La señal es global: si este NPC no lanzó el diálogo, lo ignoramos
	if not is_dialogue_active:
		return

	is_dialogue_active = false
	can_start_dialogue = false

	if current_player and current_player.state_machine:
		current_player.state_machine.change_state("Idle")

	# Dejamos pasar frames + un pequeño margen para que el clic de cierre
	# no vuelva a disparar interact() en el mismo instante
	await get_tree().process_frame
	await get_tree().create_timer(DIALOGUE_COOLDOWN).timeout
	can_start_dialogue = true

	print("[CustomerNPC1] Diálogo cerrado. Listo para reiniciar.")
