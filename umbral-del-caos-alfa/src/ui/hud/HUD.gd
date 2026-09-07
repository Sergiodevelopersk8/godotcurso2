extends Control
class_name GUIPlayer

@export var player : Player
@onready var description_label: Label = $GUIPlayer/description_label

func _ready() -> void:
	
	if not player and owner is Player:
		player = owner as Player
	
	if player :
		player.interactable_focused.connect(_on_interactable_focused)
	else:
		print("[HUD ERROR] No se encontró la referencia al Player para conectar la señal.")
	




func _on_interactable_focused(description: String):
	description_label.text = description
