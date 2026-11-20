extends CharacterNPC # O la clase base que utilices para tus NPCs
class_name Gabriel_Customer

var memela_entregada_al_cliente: bool = false
@export var memela_pedido : String
# Exportamos el recurso de diálogo para asignarlo desde el Inspector

@export var dialogue_start_node: String = "start"

# Método que se ejecuta cuando el jugador interactúa con el cliente
# En Gabriel_Customer.gd
# Método que se ejecuta cuando el jugador presiona la tecla de interacción con Gabriel
func interact() -> void:
	print("[Gabriel] ¡Me hicieron clic o interactuaron conmigo!")
	
	if memela_entregada_al_cliente:
		return

	var player = get_tree().get_first_node_in_group("Player")	
	if player:
		print("[Jugador encontrado. Sostiene: ", player.held_object, "]")
		if player.held_object:
			receive_object(player.held_object)
		else:
			print("[Gabriel] El jugador no sostiene nada en la mano (held_object es null).")
	else:
		print("[Gabriel] No encontré al jugador en el grupo 'Player'.")

# Dentro de Gabriel_Customer (heredando de Interact)
func receive_object(object: Interact) -> bool:
	if memela_entregada_al_cliente:
		print("[Gabriel] Ya me entregaste mi pedido antes.")
		return false
	
	if object and object.id == memela_pedido:
		memela_entregada_al_cliente = true
		
		# Buscamos al jugador para limpiar su mano de forma segura
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.has_method("remover_memela_de_mano"):
			player.remover_memela_de_mano() # Esto hace queue_free() y deja held_object = null
		else:
			object.queue_free() # Resguardo por si el jugador no está disponible
		
		GameManager.entregar_memela()
		print("[Gabriel] ¡Gracias por la memela exacta! Recibí: ", object.id)
		return true
	else:
		var nombre_recibido = object.id if object else "nada"
		print("[Gabriel] Eso no es lo que pedí. Yo quería: ", memela_pedido, " y me diste: ", nombre_recibido)
		return false


func completar_pedido():
	print("ya se completo la mememla entregada")
