extends CharacterNPC # O la clase base que uses para tus NPCs
class_name Gabriel_Customer

var memela_entregada: bool = false

# Se ejecuta cuando el jugador interactúa con este cliente
func interact() -> void:
	if memela_entregada:
		# Si ya le entregó su memela, solo muestra un diálogo de agradecimiento genérico
		DialogueManager.show_dialogue_balloon(dialogue_resource, "gracias")
		return

	# Aquí verificarías si el jugador lleva la memela lista en la mano
	# (Por ejemplo, consultando el estado del inventario o la mano del jugador)
	var player = get_tree().get_first_node_in_group("Player")
	
	if player and player.tiene_memela_lista(): # Método hipotético de tu jugador
		memela_entregada = true
		player.remover_memela_de_mano() # El jugador entrega el objeto
		
		# ¡Avisamos al GameManager que una memela fue entregada!
		GameManager.entregar_memela()
		
		DialogueManager.show_dialogue_balloon(dialogue_resource, "entrega_exitosa")
	else:
		# Diálogo de que el cliente sigue esperando su memela
		DialogueManager.show_dialogue_balloon(dialogue_resource, "pedido_pendiente")
