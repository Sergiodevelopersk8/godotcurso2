extends Area3D
class_name Coin

const rotation_speed = 4





func _physics_process(delta: float) :
	#rota la moneda
	rotate_y(deg_to_rad(rotation_speed))




func _on_body_entered(body: Node3D) -> void:
	if body is Player :
		Eventmanager.addCoins.emit()
		queue_free()
	
