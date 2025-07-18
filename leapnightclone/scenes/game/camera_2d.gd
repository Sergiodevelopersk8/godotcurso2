extends Camera2D

#hacemos el player como unico para que
#se lea la referencia
@onready var player: Player = %Player


func _process(delta: float) :
	 #objetivo posicion en  y
	var target_pos := player.global_position.y
	#guardar posicion actual en posicion y
	var current_pos := global_position.y
	
	#interpolamos la posicion
	var new_position = lerp(current_pos,target_pos,5 * delta)
	#aplicamos la nueva posicion
	global_position.y = new_position
