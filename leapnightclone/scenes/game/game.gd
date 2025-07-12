extends Node2D
class_name Game

@onready var player: Player = $Player



func _ready() -> void:
	EventManager.on_played_dead.connect(_on_played_dead)


func _on_played_dead():
	player.player_dead()
	
