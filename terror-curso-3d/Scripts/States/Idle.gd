# res://Scripts/States/Idle.gd
extends PlayerState
class_name Idle



func physics_update(delta: float) -> void:
	
	if not player.process_input(delta) != Vector3.ZERO:
		state_machine.transition_to("Walk",{})
		return
	
	player.velocity = player.velocity.lerp(Vector3.ZERO, player.friction * delta)
	player.move_and_slide()
	
	
