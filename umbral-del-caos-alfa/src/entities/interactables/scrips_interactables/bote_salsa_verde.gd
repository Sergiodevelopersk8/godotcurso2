# Archivo: src/entities/interactables/scrips_interactables/bote_salsa_verde.gd
# Descripci?n: Representa un objeto interactivo con salsa verde que puede usarse en el mundo.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Interact y reutiliza sus propiedades y comportamiento base.
extends Interact
# Registra Bote_de_Salsa_Verde como nombre de clase global para usarlo en otros scripts.
class_name Bote_de_Salsa_Verde

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Llama al metodo interact para realizar esta accion en este punto.
	interact()
	# Guarda en can_be_loaded el resultado de true.
	can_be_loaded = true


# Se ejecuta cuando el jugador interact?a con este objeto o NPC.
func interact():
	# Llama a la implementacion heredada de la clase base.
	super.interact()
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass
