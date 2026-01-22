# res://Scripts/Manager/global.gd
extends Node

@onready var dialogue_canvas_layer: CanvasLayer = $DialogueCanvasLayer
@onready var text_label: RichTextLabel = $DialogueCanvasLayer/TextDialogueRichTextLabel
@onready var name_label: RichTextLabel = $DialogueCanvasLayer/NameRichTextLabel

signal option_selected(Index:int) # opciones 0 -> a, 1 -> b

var is_dialogue_active := false
var is_waiting_for_option := false



# ------------FUNCIONES PROPIAS----------

# funcion cuando el NPC quiere preguntar algo
func show_question(name:String, text:String, option_a:String, option_b:String):
	show_dialogue(name,text)
	is_waiting_for_option = true
	


func show_dialogue(name,text):
	pass
