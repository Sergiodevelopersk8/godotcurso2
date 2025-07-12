extends StaticBody2D
class_name SpikeBlock


@export var rotation_interval := 2.0
@onready var visuals: Node2D = $Visuals

var timer : float

func _process(delta: float) :
	timer += delta
	if timer >= rotation_interval:
		do_rotation()
		timer = 0.0




func do_rotation():
	var current_rot := visuals.rotation_degrees
	var desired_rot := current_rot -90
	var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(visuals, "rotation_degrees", desired_rot, 0.5)
	
