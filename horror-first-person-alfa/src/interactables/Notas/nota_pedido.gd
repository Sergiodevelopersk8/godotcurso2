extends Interact
class_name NotaPedido

@onready var ui_note: CanvasLayer = $UINota
@onready var img_note: TextureRect = $UINota/IMGNota


var  player

func _ready() -> void:
	#referencia al player buscando su grupo
	player = get_tree().get_first_node_in_group("Player")
	#oculta la nota 
	ui_note.hide()
	can_be_loaded = false
	


func interact():
	ui_note.visible = not ui_note.visible
	if ui_note.visible:
		
		player.reading_note = true
		player.move_and_rotate_player = false
	else:
		player.reading_note = false
		player.move_and_rotate_player = true


func interact2():
	ui_note.visible = not ui_note.visible
	get_tree().paused = not get_tree().paused
#debo de ARREGLAR ESTO DEL MOVIMIENTO 
	
	player.move_and_rotate_player = not player.move_and_rotate_player
