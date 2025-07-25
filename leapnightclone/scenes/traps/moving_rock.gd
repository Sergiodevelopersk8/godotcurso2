extends StaticBody2D
class_name MovingRock

#cantidad de tiempo que indica la espera
#para  regresar a su posicion inicial
@export var reset_timer := 0.5

#distancia
@export var move_distance : float


#referencia a la animacion
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

#posicion inicial
var start_posiction: Vector2


func _ready() -> void:
	#guardamos la posicion original
	start_posiction = global_position


func move_bottom():
	var tween := create_tween()
	#mover el objeto de su posicion en y
	tween.tween_property(self, "global_position:y", start_posiction.y + move_distance, 0.5)
	#esperar para regresa
	tween.tween_interval(reset_timer)
	#regresar el objeto a su posicion
	tween.tween_property(self,"global_position:y", start_posiction.y, 0.5)


func _on_action_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	move_bottom()


func _on_kill_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	EventManager.on_played_dead.emit()
