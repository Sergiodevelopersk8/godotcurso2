extends RigidBody3D
class_name RigidInteract

@export var id: String = "Pelota"
@export var pos_obj: Vector3 = Vector3(0, 0, -0.5)
var can_be_loaded: bool = true
var is_carried: bool = false

func interact() -> void:
	print("[Pelota] Interactuó con la pelota")


# Llamado desde Interactor3D cuando el jugador toma la pelota
func on_pickup() -> void:
	is_carried = true
	freeze = true # 👈 Congela la física para que no colisione con el jugador ni caiga

# Llamado desde Interactor3D cuando el jugador suelta la pelota
func on_drop(impulse_force: Vector3 = Vector3.ZERO) -> void:
	is_carried = false
	freeze = false # 👈 Reactiva la física
	
	# Opcional: Si quieres lanzarla hacia adelante al soltarla
	if impulse_force != Vector3.ZERO:
		apply_central_impulse(impulse_force)
