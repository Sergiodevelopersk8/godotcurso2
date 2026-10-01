# Fragmento para Nota.gd
extends Interact
class_name Nota

@onready var ui_note: CanvasLayer = $UINote
@onready var img_nota: TextureRect = $UINote/IMGNota
@onready var text_note: RichTextLabel = $UINote/RichTextLabel

var player: Player
var is_busy: bool = false #es un cooldown para

func _ready() -> void:
	ui_note.hide()
	player = get_tree().get_first_node_in_group("Player") as Player

func interact() -> void:
	# Si ya está abierta o procesando un cambio, ignoramos
	if ui_note.visible or is_busy:
		return
	
	action_use()

func action_use() -> void:
	if is_busy:
		print(" busy 1->" , is_busy)
		return
	is_busy = true
	print(" busy 2 ->" , is_busy)
	var abriendo = !ui_note.visible
	ui_note.visible = abriendo
	print("ui_note.visible -> ", ui_note.visible)
	
	if player:
		if abriendo:
			if player.state_machine:
				player.state_machine.change_state("InDialogue")
			if player.ray_cast_interactuar:
				player.ray_cast_interactuar.enabled = false
		else:
			if player.state_machine:
				player.state_machine.change_state("Idle")
			# Esperamos un pequeño tiempo antes de reactivar el RayCast 
			# para que el clic de cierre no vuelva a detectar la nota
			await get_tree().create_timer(0.15).timeout
			if player.ray_cast_interactuar:
				player.ray_cast_interactuar.enabled = true
	is_busy = false
	print(" busy 3->" , is_busy)

func _unhandled_input(event: InputEvent) -> void:
	if ui_note.visible and event.is_action_pressed("interact_dialogue"):
		get_viewport().set_input_as_handled()
		action_use()
