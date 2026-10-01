extends Interact
class_name Nota

@export var textura_nota: Texture2D
@export var texto : String

func interact() -> void:
	NotaManager.mostrar_nota(textura_nota,texto)
