extends PlayerState
class_name InDialogue

func _ready() -> void:
	player = get_parent().get_parent() as Player
	
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_started(_resource) -> void:
	state_machine.change_state("InDialogue")

func enter(_msg := {}) -> void:
	if player:
		player.move_and_rotate_player = false
		player.velocity = Vector3.ZERO
		print("[InDialogue] Jugador CONGELADO.")

func _on_dialogue_ended(_resource) -> void:
	# Como la tecla de avanzar dialogo ahora es DIFERENTE a 'interact', 
	# podemos regresar a Idle directamente sin riesgo de bucle.
	state_machine.change_state("Idle")

func exit() -> void:
	if player:
		player.move_and_rotate_player = true
		print("[InDialogue] Jugador DESCONGELADO.")
