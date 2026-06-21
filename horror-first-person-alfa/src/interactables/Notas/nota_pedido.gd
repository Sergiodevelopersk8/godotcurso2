extends Interact
class_name NotaPedido

@onready var ui_note: CanvasLayer = $UINota
@onready var img_note: TextureRect = $UINota/IMGNota


var  player
var can_be_loaded = false

func _ready() -> void:
	ui_note.hide()
	player = get_tree().get_first_node_in_group("player")

func action_use():
	super.action_use()
	
	# 1. Si la UI está oculta, significa que la vamos a ABRIR
	if ui_note.visible == false:
		
		ui_note.show()
		get_tree().paused = true # Pausamos el mundo
		
		if player:
			player.move_and_rotate_player = false # Congelamos cámara
			player.direction = Vector3.ZERO       # Detenemos al player
		
	# 2. Si la UI ya estaba visible, significa que la vamos a CERRAR
	else:
		ui_note.hide()
		get_tree().paused = false # Despausamos el mundo
		
		if player:
			player.move_and_rotate_player = true # Devolvemos cámara
			




func _unhandled_input(event: InputEvent) -> void:
	if ui_note.visible and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		action_use()
