extends Node

@onready var spike: Area3D = $floor_adn_wall/DamageSpikeArea3D

func _on_button_interact_is_interacted() -> void:
	spike.global_position = Vector3(-0.2,0.0,2.3)


func _on_keypad_on_correct_pass() -> void:
	if is_instance_valid($floor_adn_wall/cubo_destruir):
		$floor_adn_wall/cubo_destruir.queue_free()
