@tool
extends StaticBody3D
class_name Key
@export var id: String = "Key"

@export var number : String = "." : 
	set(value):
		number = value
		if number != ".":
			$Label3D.text = number

signal on_interact

func action_use():
	AudioStreamManager.play("res://AssetsModels/Numpad/pressed_key.wav")
	emit_signal("on_interact", number)
