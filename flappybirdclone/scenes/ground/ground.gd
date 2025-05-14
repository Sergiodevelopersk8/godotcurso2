extends Node2D
class_name Ground

#señal para el area2d cuando entre 
signal on_player_crash 



#variable que es la velocidad
# es -150.0 por va la izquierda
@export var speed := -150.0

#referencia de los grounds 
@onready var ground_1: Area2D = $Ground_1
@onready var ground_2: Area2D = $Ground_2
@onready var sprite_2d : Sprite2D = %Sprite2D
@onready var game_over_sound: AudioStreamPlayer2D = $GameOverSound




#guarda el ancho de la imagen de los pisos
var width : float

func _ready() -> void:
	#obtiene el valor del ancho 
	width = sprite_2d.texture.get_width()

func _process(delta):
	#suma a x la velocidad multiplicado por delta
	ground_1.global_position.x += speed * delta
	ground_2.global_position.x += speed * delta
	
	#si el valor es mas de -404 entra al if
	if ground_1.global_position.x < -width / 2:
		#ground 1 se posiciona al final de ground 2 por la suma de width
		ground_1.global_position.x = ground_2.global_position.x + width
	
	if ground_2.global_position.x < -width / 2:
		#ground 2 se posiciona al final de ground 1 por la suma de width
		ground_2.global_position.x = ground_1.global_position.x + width
	


func _on_ground_body_entered(body: Node2D) -> void:
	#colisiono con el player
	on_player_crash.emit()
	speed = 0
	#referencia al parametro body
	var player := body as Player
	player.stop_movement()
	player.stop_gravity()
	game_over_sound.play()
