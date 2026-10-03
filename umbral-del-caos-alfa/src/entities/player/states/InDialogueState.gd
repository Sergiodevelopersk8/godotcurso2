# res://src/entities/player/states/InDialogueState.gd
extends PlayerState
# Registra InDialogueState como nombre de clase global para usarlo en otros scripts.
class_name InDialogueState

## Bloquea el movimiento y la rotacion del jugador durante el dialogo.
# Entra a este estado y prepara variables, animaciones o condiciones.
func enter(_msg := {}) -> void:
	# Comprueba player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player:
		# Bloqueamos el movimiento y la rotación en el Player
		player.move_and_rotate_player = false
		# Guarda en player.velocity el resultado de Vector3.ZERO.
		player.velocity = Vector3.ZERO
		# Llama al metodo print para realizar esta accion en este punto.
		print("[InDialogueState] Jugador congelado correctamente.")

## Restaura el control del jugador al terminar el dialogo.
# Sale del estado actual y limpia recursos o flags asociados.
func exit() -> void:
	# Comprueba player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player:
		# Restauramos la libertad de movimiento al salir del estado
		player.move_and_rotate_player = true
		# Llama al metodo print para realizar esta accion en este punto.
		print("[InDialogueState] Jugador descongelado.")
