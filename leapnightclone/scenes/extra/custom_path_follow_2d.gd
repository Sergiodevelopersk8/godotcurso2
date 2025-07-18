extends PathFollow2D
class_name CustomPathFollow

@export var move_speed := 0.5

var direction := 1


var can_move := true


func _process(delta: float):
	if not can_move:
		return
	
	progress_ratio += move_speed * direction * delta
	
	#si llega al lado derecho 
	if progress_ratio >= 1:
		#al llegar al lado derecho le restamos para que se mueva
		direction = -1
	#si se llega a izquiertdo 
	elif progress_ratio <= 0:
		#lo movemos al lado derecho
		direction = 1
	
