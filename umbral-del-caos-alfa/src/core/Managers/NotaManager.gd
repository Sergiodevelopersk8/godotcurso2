extends Node

@onready var ui_note: CanvasLayer = $UINote
@onready var img_nota: TextureRect = $UINote/IMGNota
@onready var nota_text: RichTextLabel = $UINote/RichTextLabel


var player: Player
var is_busy: bool = false

func _ready() -> void:
	ui_note.hide()
	player = get_tree().get_first_node_in_group("Player") as Player

func mostrar_nota(nueva_textura: Texture2D, texto: String = "" ) -> void:
	if is_busy:
		return
		
	# Asignamos la textura específica de la nota interactuada
	img_nota.texture = nueva_textura
	nota_text.text = texto
	action_use()


func action_use() -> void:
	if is_busy:
		return
	is_busy = true
	
	# Obtenemos al player en tiempo de ejecución por si no existía en _ready()
	if not player:
		player = get_tree().get_first_node_in_group("Player") as Player
		
	var abriendo = !ui_note.visible
	ui_note.visible = abriendo
	
	if player:
		if abriendo:
			if player.state_machine:
				player.state_machine.change_state("InDialogue")
			if player.ray_cast_interactuar:
				player.ray_cast_interactuar.enabled = false
		else:
			if player.state_machine:
				player.state_machine.change_state("Idle")
			await get_tree().create_timer(0.15).timeout
			if player.ray_cast_interactuar:
				player.ray_cast_interactuar.enabled = true
				
	is_busy = false

func _unhandled_input(event: InputEvent) -> void:
	if ui_note.visible and event.is_action_pressed("interact_dialogue"):
		get_viewport().set_input_as_handled()
		action_use()
