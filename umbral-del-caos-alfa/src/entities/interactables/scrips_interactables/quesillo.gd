extends Interact
class_name Quesillo

var velocidad := Vector3.ZERO
@onready var ray: RayCast3D = $RayCast3D



func _ready() -> void:
	ray.collision_mask = 1   # la capa de tu suelo
	ray.enabled = true
	interact()
	can_be_loaded = true


func _physics_process(delta: float) -> void:
	ray.is_colliding()
	if ray.collision_mask == 2:
		gravity = 0
		print("si choque con el objeto" )
	velocidad.y -= gravity * delta


func interact():
	super.interact()
	pass
