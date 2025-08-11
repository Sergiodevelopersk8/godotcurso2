extends Node3D
class_name Game

var takecoins : int

@onready var coinstxt: Label = $Control/coinstxt



func _ready() -> void:
	Eventmanager.addCoins.connect(_add_coins)


func _add_coins():
	takecoins += 1
	print(takecoins)
	coinstxt.text = str(takecoins)
