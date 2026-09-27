extends Interact
class_name NotaPedidoTia

@onready var ui_note: CanvasLayer = $UINote
@onready var img_nota: TextureRect = $UINote/IMGNota

var player


func _ready() -> void:
	ui_note.hide()
	player = get_tree().get_first_node_in_group("player")

func action_use():
	#abrir o cerra 
	
	
	if not MissionManager.mision_completada and not MissionManager.tiene_memela:
		MissionManager.tiene_memela = true
		MissionManager.set_mission("- Entregar memela al vendedor")
	
	
	# Cambiamos el estado de visibilidad
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
	if ui_note.visible and event.is_action_pressed("interact_object"):
		get_viewport().set_input_as_handled()
		action_use()
