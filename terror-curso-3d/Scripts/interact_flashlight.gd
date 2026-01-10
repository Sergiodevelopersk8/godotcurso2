extends Interact
class_name FlashLightInteract


func action_use():
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.flashlightEquipped = true
	AudioStreamManager.play("res://Player/footsteps/bones/7.ogg")
	queue_free()
	pass
