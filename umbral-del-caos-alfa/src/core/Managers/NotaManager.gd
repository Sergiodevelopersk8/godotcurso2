# Archivo: src/core/Managers/NotaManager.gd
# Descripci?n: Administra notas y textos de la interfaz relacionados con objetivos o mensajes.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Node y reutiliza sus propiedades y comportamiento base.
extends Node

# Obtiene la referencia ui_note cuando el nodo ya esta listo.
@onready var ui_note: CanvasLayer = $UINote
# Obtiene la referencia img_nota cuando el nodo ya esta listo.
@onready var img_nota: TextureRect = $UINote/IMGNota
# Obtiene la referencia nota_text cuando el nodo ya esta listo.
@onready var nota_text: RichTextLabel = $UINote/RichTextLabel


# Declara player para guardar un dato utilizado por este script.
var player: Player
# Crea is_busy e inicializa su valor con false.
var is_busy: bool = false

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Llama al metodo ui_note.hide para realizar esta accion en este punto.
	ui_note.hide()
	# Guarda en player el resultado de get_tree().get_first_node_in_group("Player") as Player.
	player = get_tree().get_first_node_in_group("Player") as Player

# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func mostrar_nota(nueva_textura: Texture2D, texto: String = "" ) -> void:
	# Comprueba is_busy; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_busy:
		# Termina el metodo sin devolver un valor.
		return
		
	# Asignamos la textura específica de la nota interactuada
	img_nota.texture = nueva_textura
	# Guarda en nota_text.text el resultado de texto.
	nota_text.text = texto
	# Llama al metodo action_use para realizar esta accion en este punto.
	action_use()


# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func action_use() -> void:
	# Comprueba is_busy; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_busy:
		# Termina el metodo sin devolver un valor.
		return
	# Guarda en is_busy el resultado de true.
	is_busy = true
	
	# Obtenemos al player en tiempo de ejecución por si no existía en _ready()
	if not player:
		# Guarda en player el resultado de get_tree().get_first_node_in_group("Player") as Player.
		player = get_tree().get_first_node_in_group("Player") as Player
		
	# Crea abriendo e inicializa su valor con !ui_note.visible.
	var abriendo = !ui_note.visible
	# Guarda en ui_note.visible el resultado de abriendo.
	ui_note.visible = abriendo
	
	# Comprueba player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player:
		# Comprueba abriendo; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if abriendo:
			# Comprueba player.state_machine; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if player.state_machine:
				# Llama al metodo player.state_machine.change_state para realizar esta accion en este punto.
				player.state_machine.change_state("InDialogue")
			# Comprueba player.ray_cast_interactuar; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if player.ray_cast_interactuar:
				# Guarda en player.ray_cast_interactuar.enabled el resultado de false.
				player.ray_cast_interactuar.enabled = false
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Comprueba player.state_machine; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if player.state_machine:
				# Llama al metodo player.state_machine.change_state para realizar esta accion en este punto.
				player.state_machine.change_state("Idle")
			# Espera a que termine get_tree().create_timer(0.15).timeout antes de continuar.
			await get_tree().create_timer(0.15).timeout
			# Comprueba player.ray_cast_interactuar; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if player.ray_cast_interactuar:
				# Guarda en player.ray_cast_interactuar.enabled el resultado de true.
				player.ray_cast_interactuar.enabled = true
				
	# Guarda en is_busy el resultado de false.
	is_busy = false

# Intercepta eventos de input que no fueron consumidos por otros nodos.
func _unhandled_input(event: InputEvent) -> void:
	# Comprueba ui_note.visible and event.is_action_pressed("interact_dialogue"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if ui_note.visible and event.is_action_pressed("interact_dialogue"):
		# Llama al metodo get_viewport para realizar esta accion en este punto.
		get_viewport().set_input_as_handled()
		# Llama al metodo action_use para realizar esta accion en este punto.
		action_use()
