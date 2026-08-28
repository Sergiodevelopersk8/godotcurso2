extends Interact
class_name NPCCliente1

# Exportamos el recurso de diálogo para asignarlo desde el Inspector de Godot
@export var dialogue_resource: DialogueResource
@export var dialogue_start_title: String = "start"

func _ready() -> void:
	can_be_loaded = false

func interact() -> void:
	if dialogue_resource != null:
		# Invocamos la ventana/balloon por defecto que incluye Dialogue Manager
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start_title)
	else:
		print("[NPC ERROR] No se ha asignado ningún DialogueResource en el inspector.")
