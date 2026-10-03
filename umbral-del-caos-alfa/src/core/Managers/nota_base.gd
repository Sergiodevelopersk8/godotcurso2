
# Archivo: src/core/Managers/nota_base.gd
# Descripci?n: Define la base para crear notas y referencias asociadas a la jugabilidad.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Interact y reutiliza sus propiedades y comportamiento base.
extends Interact
# Registra Nota como nombre de clase global para usarlo en otros scripts.
class_name Nota

# Expone textura_nota en el Inspector para configurarlo desde la escena.
@export var textura_nota: Texture2D
# Expone texto en el Inspector para configurarlo desde la escena.
@export var texto : String

# Se ejecuta cuando el jugador interact?a con este objeto o NPC.
func interact() -> void:
	# Llama al metodo NotaManager.mostrar_nota para realizar esta accion en este punto.
	NotaManager.mostrar_nota(textura_nota,texto)
