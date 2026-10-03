# res://src/entities/actors/customer_npc1.gd
extends Interact
# Registra CustomerNPC1 como nombre de clase global para usarlo en otros scripts.
class_name CustomerNPC1

# Expone dialogue_resource en el Inspector para configurarlo desde la escena.
@export var dialogue_resource: DialogueResource

# Crea is_dialogue_active e inicializa su valor con false.
var is_dialogue_active: bool = false
# Crea can_start_dialogue e inicializa su valor con true.
var can_start_dialogue: bool = true
# Crea current_player e inicializa su valor con null.
var current_player: Player = null


# Define DIALOGUE_COOLDOWN con el valor fijo 0.35.
const DIALOGUE_COOLDOWN := 0.35

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Guarda en can_be_loaded el resultado de false.
	can_be_loaded = false
	# Llama al metodo DialogueManager.dialogue_ended.connect para realizar esta accion en este punto.
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

# Se ejecuta cuando el jugador interact?a con este objeto o NPC.
func interact() -> void:
	# Comprueba is_dialogue_active or not can_start_dialogue; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_dialogue_active or not can_start_dialogue:
		# Termina el metodo sin devolver un valor.
		return

	# Comprueba not dialogue_resource; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not dialogue_resource:
		# Llama al metodo push_warning para realizar esta accion en este punto.
		push_warning("[CustomerNPC1] No se asignó dialogue_resource.")
		# Termina el metodo sin devolver un valor.
		return

	# Llama a la implementacion heredada de la clase base.
	super.interact()

	# Guarda en is_dialogue_active el resultado de true.
	is_dialogue_active = true

	# Comprueba not current_player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not current_player:
		# Guarda en current_player el resultado de get_tree().get_first_node_in_group("Player") as Player.
		current_player = get_tree().get_first_node_in_group("Player") as Player

	# Comprueba current_player and current_player.state_machine; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_player and current_player.state_machine:
		# Llama al metodo current_player.state_machine.change_state para realizar esta accion en este punto.
		current_player.state_machine.change_state("InDialogue")

	# Llama al metodo DialogueManager.show_dialogue_balloon para realizar esta accion en este punto.
	DialogueManager.show_dialogue_balloon(dialogue_resource, "start")

# Se ejecuta cuando termina una conversaci?n y limpia el estado del di?logo.
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	# La señal es global: si este NPC no lanzó el diálogo, lo ignoramos
	if not is_dialogue_active:
		# Termina el metodo sin devolver un valor.
		return

	# Guarda en is_dialogue_active el resultado de false.
	is_dialogue_active = false
	# Guarda en can_start_dialogue el resultado de false.
	can_start_dialogue = false

	# Comprueba current_player and current_player.state_machine; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_player and current_player.state_machine:
		# Llama al metodo current_player.state_machine.change_state para realizar esta accion en este punto.
		current_player.state_machine.change_state("Idle")

	# Dejamos pasar frames + un pequeño margen para que el clic de cierre
	# no vuelva a disparar interact() en el mismo instante
	await get_tree().process_frame
	# Espera a que termine get_tree().create_timer(DIALOGUE_COOLDOWN).timeout antes de continuar.
	await get_tree().create_timer(DIALOGUE_COOLDOWN).timeout
	# Guarda en can_start_dialogue el resultado de true.
	can_start_dialogue = true

	# Llama al metodo print para realizar esta accion en este punto.
	print("[CustomerNPC1] Diálogo cerrado. Listo para reiniciar.")
