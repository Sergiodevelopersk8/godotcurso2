# res://src/entities/actors/customer_npc1.gd
extends Interact
class_name CustomerNPC1

@export var dialogue_resource: DialogueResource
var is_dialogue_active: bool = false
var current_player: Player = null

func _ready() -> void:
	can_be_loaded = false
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func interact() -> void:
	if is_dialogue_active:
		return
		
	super.interact()
	
	if dialogue_resource:
		is_dialogue_active = true
		
		# Buscamos al jugador en la escena si no lo tenemos guardado
		if not current_player:
			current_player = get_tree().get_first_node_in_group("player") as Player
			
		if current_player:
			current_player.set_talking_state(true)
			
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")
	else:
		push_warning("[CustomerNPC1] No se asignó dialogue_resource.")

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	is_dialogue_active = false
	
	if current_player:
		current_player.set_talking_state(false)
		
	print("[CustomerNPC1] Diálogo finalizado con éxito.")
