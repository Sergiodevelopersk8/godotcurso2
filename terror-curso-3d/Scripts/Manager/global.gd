# res://Scripts/Manager/global.gd
extends Node


@onready var dialogue_canvas_layer: CanvasLayer = $DialogueCanvasLayer
@onready var text_label: RichTextLabel = $DialogueCanvasLayer/TextDialogueRichTextLabel
@onready var name_label: RichTextLabel = $DialogueCanvasLayer/NameRichTextLabel

var is_dialogue_active := false
var player : Player = null



func _ready():
	dialogue_canvas_layer.hide()
	player = get_tree().get_first_node_in_group("Player")


func show_dialogue(name:String, text:String):
	if is_dialogue_active:
		return
	
	is_dialogue_active = true
	name_label.text = name
	text_label.text = text
	dialogue_canvas_layer.show()
	
	if player:
		player.canMoveAndRotate = false

func _unhandled_input(event):
	if not is_dialogue_active:
		return
	if Input.is_action_just_pressed("action_use"): # la E
		close_dialogue()


func close_dialogue():
	is_dialogue_active = false
	dialogue_canvas_layer.hide()
	if player:
		player.canMoveAndRotate = true
