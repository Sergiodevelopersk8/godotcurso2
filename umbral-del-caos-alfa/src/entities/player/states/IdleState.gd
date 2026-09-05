# res://src/entities/player/states/IdleState.gd
extends PlayerState
class_name IdleState

func enter(_msg := {}) -> void:
	if player:
		player.velocity = Vector3.ZERO

func physics_update(delta: float) -> void:
	if not player:
		return
		
	# Si detectamos entrada de movimiento, pasamos a Walk
	var input_dir = player.process_input(delta)
	if input_dir != Vector3.ZERO:
		state_machine.change_state("Walk")
