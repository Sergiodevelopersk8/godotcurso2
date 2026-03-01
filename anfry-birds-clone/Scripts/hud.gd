extends Control

@onready var launches_label: Label = $MarginContainer/LaunchesLabel
@onready var level_completed_label: Label = $MarginContainer/Level_completed_Label

func _ready() -> void:
	#señal del signal manager se conecta a la funcion de aqui del _on_player_launched
	SignalManager.player_launch.connect(_on_player_launched) 
	SignalManager.level_completed.connect(_on_level_completed)

func _on_player_launched():
	launches_label.text = "Launches : " + str(GameManager.launches)

func _on_level_completed():
	level_completed_label.visible = true
	
