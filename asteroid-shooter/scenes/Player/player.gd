extends CharacterBody2D
class_name Player

@onready var player: CharacterBody2D = $"."
@export var speed = 500.0
@onready var sprite_nave: Sprite2D = $Sprite2D
#instanciar la escena del laser 
@export var laser_scene:PackedScene
#movimientos del player
var y_input 
var x_input



func _physics_process(delta) :
	if GameManager.is_game_over: return
	
	player_move(x_input,y_input)
	player_shoot()

func player_move(x,y):
	y = Input.get_axis("up","down")
	x = Input.get_axis("left","right")
	velocity = Vector2(x, y) * speed
	move_and_slide()

func player_shoot():
	if Input.is_action_just_pressed("shoot"):
		create_laser()
	

func create_laser():
	#guarda la instancia de la escena de laser
	var laser_instance = laser_scene.instantiate()
	#lo agrega a la escena pero no como el hijo del nodo raiz
	add_sibling(laser_instance)
	#obtiene la poscicion de la nave para que el laser
	#salga de la nave no importa donde se mueva la nave
	laser_instance.position = position
	


func _on_detection_area_area_entered(area: Area2D) -> void:
	#elimino la nave si esta colisiona con el asteroide  
	if area.is_in_group("asteroides"):
		GameManager.set_is_game_over(true)
		queue_free()
	
