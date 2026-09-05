# res://src/entities/player/states/InDialogueState.gd
extends PlayerState
class_name InDialogueState

func enter(_msg := {}) -> void:
	if player:
		# Bloqueamos el movimiento y la rotación en el Player
		player.move_and_rotate_player = false
		player.velocity = Vector3.ZERO
		print("[InDialogueState] Jugador congelado correctamente.")

func exit() -> void:
	if player:
		# Restauramos la libertad de movimiento al salir del estado
		player.move_and_rotate_player = true
		print("[InDialogueState] Jugador descongelado.")
