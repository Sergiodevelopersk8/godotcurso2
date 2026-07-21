extends Control
class_name DialogueUI  

@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/NameLabel
@onready var text_label: RichTextLabel = $Panel/TextLabel

var currentdata : DialogueData
var current_page_index = 0
var player : Player 
var just_opened: bool = false



func _ready() -> void:
	panel.hide()
	DialogueManager.dialogue_request.connect(_on_dialogue_request)


func _unhandled_input(event: InputEvent):
	if not panel.visible:
		return
	if event.is_action_pressed("interact"):
		print("[UI] ¡Botón detectado en la UI!") # <-- RASTREO 1
		get_viewport().set_input_as_handled()
		if just_opened:
			print("[UI] Diálogo recién abierto. Ignorando primer frame.") # <-- RASTREO 2
			just_opened = false
			return
		print("[UI] Intentando avanzar de página. Índice actual antes del cambio: ", current_page_index) # <-- RASTREO 3
		current_page_index += 1
		if current_page_index< currentdata.pages.size():
			update_dialogue_ui()
		else:
			panel.hide()
			DialogueManager.finish_Dialogue()
	


func _on_dialogue_request(data:DialogueData):
	
	currentdata = data
	panel.show()
	current_page_index = 0
	update_dialogue_ui()
	just_opened = true


func update_dialogue_ui():
	name_label.text = currentdata.name_character
	text_label.text =  currentdata.pages[current_page_index]
