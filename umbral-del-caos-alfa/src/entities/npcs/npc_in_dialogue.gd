# res://src/entities/npcs/states/npc_in_dialogue.gd
extends Node
class_name NPCInDialogue

signal transition(state_node, new_state_name: String)
@onready var look_me: Marker3D = $"../../look_me"

@export var dialogue_resource: DialogueResource

var npc: CharacterBody3D
var current_player: Player = null
const DIALOGUE_COOLDOWN := 0.35

func setup(owner_npc: CharacterBody3D) -> void:
	npc = owner_npc

func enter() -> void:
	# 1. Verificación defensiva del NPC y su recurso de diálogo en la raíz
	if not npc or not "dialogue_resource" in npc or not npc.dialogue_resource:
		push_warning("[NPCInDialogue] El NPC raíz no tiene asignado un dialogue_resource.")
		return
	# 2. Detener el movimiento físico del NPC
	npc.velocity = Vector3.ZERO
	# 3. Obtener referencia del jugador y enfocar la mirada (look_me)
	if not current_player:
		current_player = get_tree().get_first_node_in_group("Player") as Player
	if current_player and current_player.state_machine :
		current_player.state_machine.change_state("InDialogue", {"focus_target": look_me.global_position})
	# 4. Conectar la señal de fin de diálogo y lanzarlo usando la fuente única de verdad
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon(npc.dialogue_resource, "start")

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	# Desconectamos para evitar llamadas duplicadas
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

	# Regresar al jugador a su estado Idle
	if current_player and current_player.state_machine:
		current_player.state_machine.change_state("Idle")

	# Notificar a la máquina de estados del NPC que regrese a Idle
	transition.emit(self, "Idle")
	print("[NPCInDialogue] Diálogo cerrado, regresando a Idle.")

# Dentro de NPCInDialogue.gd (o tus otros estados)
func update(delta: float) -> void:
	pass # O déjalo vacío si no requiere lógica por frame


func exit() -> void:
	current_player = null
