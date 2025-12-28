extends Node2D
class_name PowerUpSpawner

@export var powerup_scene:PackedScene
@onready var timer: Timer = $Timer

var x_min = 0
var x_max 
var y_min = 0
var y_max 


func _ready() -> void:
	#dimensiones del ventana del juego
	#esto se hace en el ready por que se carga la escena
	x_max = get_viewport().size.x / 2
	y_max = get_viewport().size.y 


func _on_timer_timeout() -> void:
	create_power_up()


func create_power_up():
	if GameManager.is_game_over:
		timer.stop()
		return
	var powerup_instanciate = powerup_scene.instantiate()
	add_child(powerup_instanciate)
	var randomx_x = randf_range(x_min, x_max)
	var randomx_y = randf_range(y_min, y_max)
	powerup_instanciate.position = Vector2(randomx_x,randomx_y)
