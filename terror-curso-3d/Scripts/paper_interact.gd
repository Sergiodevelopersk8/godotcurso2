extends Interact
class_name PaperInteract

@export_multiline var text : String
@onready var label_note: Label = $UIPaper/LabelNote
@onready var ui_paper: CanvasLayer = $UIPaper

var player


func _ready() -> void:
	note_hide()

func note_hide():
	label_note.text = text
	ui_paper.hide()
	player = get_tree().get_first_node_in_group("Player")


func action_use():
	ui_paper.visible = not ui_paper.visible
	get_tree().paused = not get_tree().paused
	player.canMoveAndRotate = not player.canMoveAndRotate
