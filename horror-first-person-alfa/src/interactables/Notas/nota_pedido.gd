extends Interact
class_name NotaPedido


@export var nota_texture: Texture2D


func _ready()-> void :
	can_be_loaded = false

func interact() -> void:
	if nota_texture != null:
		NoteManager.open_note(nota_texture)
	else:
		print("[NotaPedido Error] No se ha asignado ninguna textura en el Inspector.")
