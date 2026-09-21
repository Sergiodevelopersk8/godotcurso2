extends Interact
class_name Quesillo

var velocidad := Vector3.ZERO
@onready var ray: RayCast3D = $RayCast3D



func _ready() -> void:
	ray.collision_mask = 1   # la capa de tu suelo
	ray.enabled = true
	interact()
	can_be_loaded = true




func interact():
	super.interact()
	pass
