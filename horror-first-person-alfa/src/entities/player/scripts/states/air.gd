extends PlayerState
class_name Air_Player_State


func update(_delta: float) -> void:
	if player.is_on_floor():
		state_machine.change_state("Idle") 


func physics_update(delta: float) -> void:
	if not player.process_input(delta) == Vector3.ZERO:
		player.velocity =  lerp(player.velocity, player.process_input(delta) * player.speed, player.ACCEL_AIR * delta)
	else:
		player.velocity = lerp(player.velocity, Vector3.ZERO, player.ACCEL_AIR * delta)
	
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()
