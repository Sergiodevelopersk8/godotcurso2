extends Node #game manager

#escena main
const MAIN = preload("res://scenes/ui/main/main.tscn")


#diccionario que carga los niveles
const LEVELS = {
	1:preload("uid://c8na6cydev3ei"),
	2:preload("uid://cs7bj7yjexqqe")
}


var current_level = 0
var enemies_left


func set_enemies_left(enemies):
	enemies_left = enemies
	

func decrease_enemies_left():
	enemies_left -= 1
	if enemies_left == 0:
		load_next_level.call_deferred()

func load_next_level():
	current_level += 1
	
	if current_level <= LEVELS.size():
		#CARGA LA ESCENA DEL NIVEL 2
		get_tree().change_scene_to_packed(LEVELS[current_level])
	else:
		print("no existe el nivel" + str(current_level))
