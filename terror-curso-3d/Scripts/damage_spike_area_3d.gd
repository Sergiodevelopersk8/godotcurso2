extends Area3D

var damage = 20




func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		print("es el player a damage")
		body.health -= damage
