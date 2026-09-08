extends Control
class_name GUIPlayer

@export var player: Player
@export var description_label: Label

func _ready() -> void:
	# Esperamos a que el nodo raíz de la escena termine de cargarse por completo
	await owner.ready
	_setup_connections()

func _setup_connections() -> void:
	if not player:
		if owner is Player:
			player = owner as Player
		elif get_parent() is Player:
			player = get_parent() as Player

	if player and player.ray_cast_interactuar:
		# Conectamos la señal de forma segura
		if not player.ray_cast_interactuar.interactable_focused.is_connected(_on_interactable_focused):
			player.ray_cast_interactuar.interactable_focused.connect(_on_interactable_focused)
	else:
		print("[HUD ERROR] No se pudo conectar Interactor3D.")

func _on_interactable_focused(description: String) -> void:
	if description_label:
		description_label.text = description
