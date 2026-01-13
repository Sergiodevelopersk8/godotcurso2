extends Node3D
class_name KeyPad

@export var correct_password := "1234"

@onready var keys: Node3D = $Keys
@onready var password_label: Label3D = $password_Label

var password = "" 

signal on_correct_pass
signal on_wrong_pass
signal on_clear_pass
signal on_keypad_press


func _ready() -> void:
	for child in keys.get_children():
		if child is StaticBody3D:
			child.connect("on_interact",on_key_interact)
	
	password_label.text = ""


func on_key_interact(value):
	if value == ".":
		if password == correct_password:
			AudioStreamManager.play("res://AssetsModels/Numpad/correct_password.wav")
			emit_signal("on_correct_pass")
		else:
			AudioStreamManager.play("res://AssetsModels/Numpad/wrong_password.wav")
			emit_signal("on_wrong_pass")
		password = ""
	elif value == "C": 
		emit_signal("on_clear_pass",password)
		password = ""
	else:
		if password.length() == correct_password.length():
			return
		password += value 
		emit_signal("on_keypad_press",password)
	password_label.text = password
