extends StaticBody2D
class_name SpikeBlock

# cada cuanto va a rotar el bloque  
@export var rotation_interval := 2.0

#referencia del nodo visual
@onready var visuals: Node2D = $Visuals

# variable de tiempo
var timer : float


func _process(delta: float) :
	# aumenta el tiempo con el frame
	timer += delta
	#si el tiempo es  mayor o igual a la rotacion 
	if timer >= rotation_interval:
		#llamamos a la funcion de rotar
		do_rotation()
		#reseteamos el timer
		timer = 0.0




func do_rotation():
	# rotacion actual  igual a nodo visual
	var current_rot := visuals.rotation_degrees
	# alamacenamos la nueva rotacion 
	var desired_rot := current_rot -90
	# transiciones de animaciones                                                                                                               
	var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# aquien le pertenece la propiedades de animacion
	tween.tween_property(visuals, "rotation_degrees", desired_rot, 0.5)
	
