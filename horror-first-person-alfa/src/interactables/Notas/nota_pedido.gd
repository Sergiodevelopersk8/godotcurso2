extends Interact
class_name NotaPedido

@onready var ui_note: CanvasLayer = $UINota
@onready var img_note: TextureRect = $UINota/IMGNota


var  player
var can_be_loaded = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	ui_note.hide()
	player = get_tree().get_first_node_in_group("player")

func action_use1():
	super.action_use()
	
	# 1. Si la UI está oculta, significa que la vamos a ABRIR
	if ui_note.visible == false:
		ui_note.show()
		
		if player:
			player.move_and_rotate_player = false # Congelamos cámara y proceso del mouse
			player.direction = Vector3.ZERO       # Detenemos al player
			player.leyendo_nota = true            # 🚨 LE AVISAMOS AL PLAYER QUE SE QUEDE SORDO
		
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# 2. Si la UI ya estaba visible, significa que la vamos a CERRAR
	else:
		ui_note.hide()
		
		if player:
			player.move_and_rotate_player = true  # Devolvemos cámara
			player.leyendo_nota = false           # 🚨 LE PERMITIMOS VOLVER A INTERACTUAR
			


func action_use():
	ui_note.visible = not ui_note.visible
	get_tree().paused = not get_tree().paused
#debo de ARREGLAR ESTO DEL MOVIMIENTO 
#	player.move_and_rotate_player = not player.move_and_rotate_player






#func _unhandled_input(event: InputEvent) -> void:
#	if ui_note.visible and event.is_action_pressed("interact"):
#		get_viewport().set_input_as_handled()
#		action_use()
