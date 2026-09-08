extends Control
class_name GUIPlayer

@export var player: Player
# Ajustado según tu jerarquía: Hud -> GUIPlayer -> description_label
@onready var description_label: Label = $GUIPlayer/description_label

func _ready() -> void:
	# Como 'Hud' está instanciado dentro de CharacterBody3D (Player):
	if not player and get_parent() is Player:
		player = get_parent() as Player
	elif not player and owner is Player:
		player = owner as Player
		
	if player:
		# Conexión limpia mediante el Patrón Observador
		player.interactable_focused.connect(_on_interactable_focused)
	else:
		print("[HUD ERROR] No se encontró la referencia al Player para conectar la señal.")

func _on_interactable_focused(description: String) -> void:
	if description_label:
		description_label.text = description
