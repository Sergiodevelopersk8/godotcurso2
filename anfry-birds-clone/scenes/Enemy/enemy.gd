extends RigidBody2D
class_name Enemy

@export var velocity_threshold  : float
@export var explosion_path : PackedScene
func _ready() -> void:
	body_entered.connect(_on_damage_enemy)


func _on_damage_enemy(body):
	if body.is_in_group("Player"):
		destroy_enemy()
		return
	
	
	#saber si un nodo es de un cierto tipo y eliminarlo
	#dependiendo de su velocidad elimina al enemigo
	if body is RigidBody2D and body.linear_velocity.length() > velocity_threshold:
		destroy_enemy()


func destroy_enemy():
	GameManager.decrease_enemies_left()
	createExposion()
	queue_free()




func createExposion():
	var explosion_instance = explosion_path.instantiate()
	add_sibling(explosion_instance)
	explosion_instance.position = position
	
