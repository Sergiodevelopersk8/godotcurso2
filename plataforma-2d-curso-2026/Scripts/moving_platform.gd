extends AnimatableBody2D

@export var target: Marker2D
@export var duration:float

func _ready() -> void:
	#guardo la posicion inicial
	var start_position = position
	#crea un tween en esta variable para 
	#crear animaciones 
	var tween = get_tree().create_tween()
	#suavisado d etransicion
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position",target.global_position,duration)
	tween.tween_property(self,"position",start_position,duration)
	tween.set_loops() #loop infinito para que no se detenga
