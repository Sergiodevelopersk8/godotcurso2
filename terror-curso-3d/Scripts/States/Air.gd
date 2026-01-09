extends PlayerState
class_name Air

func enter(msg = {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = player.jumpForce
		
	pass


func update(_delta: float) -> void:
	
	pass


func physics_update(_delta: float) -> void:
	pass
