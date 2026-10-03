#  Nota.gd
extends Interact
# Registra Nota_pedido como nombre de clase global para usarlo en otros scripts.
class_name Nota_pedido

# Expone textura_nota en el Inspector para configurarlo desde la escena.
@export var textura_nota: Texture2D
# Expone texto en el Inspector para configurarlo desde la escena.
@export var texto : String

# Se ejecuta cuando el jugador interact?a con este objeto o NPC.
func interact() -> void:
	# Llama al metodo NotaManager.mostrar_nota para realizar esta accion en este punto.
	NotaManager.mostrar_nota(textura_nota,texto)
