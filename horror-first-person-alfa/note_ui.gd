extends CanvasLayer # o Control, según el nodo donde lo coloques

@onready var img_note: TextureRect = $IMGNote



func _ready() -> void:
	hide() # Aseguramos que empiece oculto
	
	# Nos suscribimos a las señales del Autoload (Observer Pattern)
	NoteManager.note_opened.connect(_on_note_opened)
	NoteManager.note_closed.connect(_on_note_closed)

func _on_note_opened(texture: Texture2D) -> void:
	img_note.texture = texture
	show()

func _on_note_closed() -> void:
	hide()
