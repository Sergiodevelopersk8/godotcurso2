extends Area3D
class_name Interact


@export var id : String = "Interact" 

#segun yo obtengo la posicion del objeto
@export var pos_obj:Vector3 = Vector3(0, 0, -0.5)
@export var scale_obj: float = 1.0
var can_be_loaded: bool = false

signal isInteract

# Guardamos el estado original para restaurarlo al soltar
var _original_collision_layer: int
var _original_collision_mask: int

var falling := false
var velocity := Vector3.ZERO
var graviti := 12.0
var ground_y := 0.0

func begin_fall() -> void:
	falling = true
	velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not falling:
		return

	velocity.y -= gravity * delta
	global_position += velocity * delta

	if global_position.y <= ground_y:
		global_position.y = ground_y
		velocity = Vector3.ZERO
		falling = false


func _ready() -> void:
	_original_collision_layer = collision_layer
	_original_collision_mask = collision_mask


func interact():
	# Al llamar a emit(), cualquier cosa conectada se enterará
	isInteract.emit()
