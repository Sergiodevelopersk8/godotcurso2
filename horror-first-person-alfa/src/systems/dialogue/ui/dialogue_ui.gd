extends Control
class_name DialogueUI  

@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/NameLabel
@onready var text_label: RichTextLabel = $Panel/TextLabel

var currentdata : DialogueData
var current_page_index

func _ready() -> void:
	panel.hide()
	DialogueManager.dialogue_request.connect(_on_dialogue_request)


func _on_dialogue_request(data:DialogueData):
	currentdata = data
	panel.show()
	current_page_index = 0
	update_dialogue_ui()


func update_dialogue_ui():
	currentdata.name_character
