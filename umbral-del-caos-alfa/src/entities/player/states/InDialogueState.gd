# res://src/entities/player/states/InDialogueState.gd
extends PlayerState
class_name InDialogueState

## Bloquea el movimiento y la rotacion del jugador durante el dialogo.
func enter(_msg := {}) -> void:
	if player:
		# Bloqueamos el movimiento y la rotación en el Player
		player.move_and_rotate_player = false
		player.velocity = Vector3.ZERO
		print("[InDialogueState] Jugador congelado correctamente.")

## Restaura el control del jugador al terminar el dialogo.
func exit() -> void:
	if player:
		# Restauramos la libertad de movimiento al salir del estado
		player.move_and_rotate_player = true
		print("[InDialogueState] Jugador descongelado.")
