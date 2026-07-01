extends Interact
class_name NotaPedido

@onready var ui_note: CanvasLayer = $UINota
@onready var img_note: TextureRect = $UINota/IMGNota


var  player
var can_be_loaded = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	ui_note.hide()
	


func action_use():
	ui_note.visible = not ui_note.visible
	get_tree().paused = not get_tree().paused
#debo de ARREGLAR ESTO DEL MOVIMIENTO 
	player.move_and_rotate_player = not player.move_and_rotate_player
