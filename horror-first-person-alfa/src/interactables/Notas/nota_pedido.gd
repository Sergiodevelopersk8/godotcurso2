extends Interact
class_name NotaPedido

@onready var ui_note: CanvasLayer = $CanvasLayer
@onready var img_note: TextureRect = $CanvasLayer/TextureRect

var player 


func _ready() -> void:
	ui_note.hide()
	player = get_tree().get_first_node_in_group("player")



func action_use():
	super.action_use()
	
	var abriendo = !ui_note.visible
	ui_note.visible = abriendo
	

	# Pausamos o despausamos el mundo
	get_tree().paused = abriendo
	
	if player:
		# Bloqueamos rotación
		player.move_and_rotate_player = !abriendo
		# Forzamos que la dirección sea cero para que no camine
		player.direction = Vector3.ZERO 
		
		# Mostramos/Ocultamos mouse
		if abriendo:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _unhandled_input(event: InputEvent) -> void:
	if ui_note.visible and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		action_use()
