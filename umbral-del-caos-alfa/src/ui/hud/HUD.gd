# Archivo: src/ui/hud/HUD.gd
# Descripci?n: Muestra informaci?n de la interfaz del jugador y mensajes de interacci?n.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Control y reutiliza sus propiedades y comportamiento base.
extends Control
# Registra GUIPlayer como nombre de clase global para usarlo en otros scripts.
class_name GUIPlayer

# Expone player en el Inspector para configurarlo desde la escena.
@export var player: Player
# Expone description_label en el Inspector para configurarlo desde la escena.
@export var description_label: Label

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Esperamos a que el nodo raíz de la escena termine de cargarse por completo
	await owner.ready
	# Llama al metodo _setup_connections para realizar esta accion en este punto.
	_setup_connections()

# Conecta se?ales y callbacks de la interfaz para actualizar la HUD.
func _setup_connections() -> void:
	# Comprueba not player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not player:
		# Comprueba owner is Player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if owner is Player:
			# Guarda en player el resultado de owner as Player.
			player = owner as Player
		# Comprueba get_parent() is Player si las condiciones anteriores resultaron falsas.
		elif get_parent() is Player:
			# Guarda en player el resultado de get_parent() as Player.
			player = get_parent() as Player

	# Comprueba player and player.ray_cast_interactuar; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player and player.ray_cast_interactuar:
		# Conectamos la señal de forma segura
		if not player.ray_cast_interactuar.interactable_focused.is_connected(_on_interactable_focused):
			# Llama al metodo player.ray_cast_interactuar.interactable_focused.connect para realizar esta accion en este punto.
			player.ray_cast_interactuar.interactable_focused.connect(_on_interactable_focused)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo print para realizar esta accion en este punto.
		print("[HUD ERROR] No se pudo conectar Interactor3D.")

# Actualiza la descripci?n visible del objeto interactivo enfocado por el jugador.
func _on_interactable_focused(description: String) -> void:
	# Comprueba description_label; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if description_label:
		# Guarda en description_label.text el resultado de description.
		description_label.text = description
