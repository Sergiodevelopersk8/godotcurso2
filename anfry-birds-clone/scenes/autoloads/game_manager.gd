extends Node #game manager

#escena main
const MAIN = preload("res://scenes/ui/main/main.tscn")


#diccionario que carga los niveles
const LEVELS = {
	1:preload("uid://c8na6cydev3ei"),
	2:preload("uid://cs7bj7yjexqqe")
}

# pantalla de puntajes
const SCORE_SCREEN = preload("uid://div82qfwv8mlu")


var launches = 0
var current_level = 0
var enemies_left
var level_launches = {}

func add_level_launches():
	#se crea la clave del nivel y el valor asociado es lo que
	#se lanzo
	level_launches[current_level] = launches
	print(level_launches)



func increase_launches():
	launches += 1

func set_enemies_left(enemies):
	enemies_left = enemies
	

func decrease_enemies_left():
	enemies_left -= 1
	if enemies_left == 0:
		add_level_launches()
		SignalManager.level_completed.emit()

func load_next_level():
	current_level += 1
	
	if current_level <= LEVELS.size():
		#CARGA LA ESCENA DEL NIVEL 2
		get_tree().change_scene_to_packed(LEVELS[current_level])
		launches = 0
	else:
		# pasa a la pantalla de cargar los puntajes
		get_tree().change_scene_to_packed(SCORE_SCREEN)
