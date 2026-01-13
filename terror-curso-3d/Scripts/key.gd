@tool
extends StaticBody3D
class_name Key

@onready var label_3d: Label3D = $Label3D

@export var number : String = "." : 
	set(value):
		number = value
		if number != ".":
			label_3d.text = number

signal on_interact

func action_use():
	emit_signal("on_interact", number)
