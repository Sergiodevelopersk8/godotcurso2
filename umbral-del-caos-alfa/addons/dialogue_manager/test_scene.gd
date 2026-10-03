# Registra BaseDialogueTestScene como nombre de clase global para usarlo en otros scripts.
class_name BaseDialogueTestScene extends Node2D


# Define DialogueSettings con el valor fijo preload("./settings.gd").
const DialogueSettings = preload("./settings.gd")
# Define DialogueResource con el valor fijo preload("./dialogue_resource.gd").
const DialogueResource = preload("./dialogue_resource.gd")


# Obtiene la referencia title cuando el nodo ya esta listo.
@onready var title: String = DialogueSettings.get_user_value("run_title")
# Obtiene la referencia resource cuando el nodo ya esta listo.
@onready var resource: DialogueResource = load(DialogueSettings.get_user_value("run_resource_path"))


# Define el metodo _ready para agrupar esta accion del script.
func _ready():
	# Comprueba not Engine.is_embedded_in_editor; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not Engine.is_embedded_in_editor:
		# Crea window e inicializa su valor con get_viewport().
		var window: Window = get_viewport()
		# Crea screen_index e inicializa su valor con DisplayServer.get_primary_screen().
		var screen_index: int = DisplayServer.get_primary_screen()
		# Guarda en window.position el resultado de Vector2(DisplayServer.screen_get_position(screen_index)) + (DisplayServer.screen_get_size(screen_index) - window.size) * 0.5.
		window.position = Vector2(DisplayServer.screen_get_position(screen_index)) + (DisplayServer.screen_get_size(screen_index) - window.size) * 0.5
		# Guarda en window.mode el resultado de Window.MODE_WINDOWED.
		window.mode = Window.MODE_WINDOWED

	# Normally you can just call DialogueManager directly but doing so before the plugin has been
	# enabled in settings will throw a compiler error here so I'm using `get_singleton` instead.
	var dialogue_manager = Engine.get_singleton("DialogueManager")
	# Llama al metodo dialogue_manager.dialogue_ended.connect para realizar esta accion en este punto.
	dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)
	# Llama al metodo dialogue_manager.show_dialogue_balloon para realizar esta accion en este punto.
	dialogue_manager.show_dialogue_balloon(resource, title if not title.is_empty() else resource.first_title)


# Define el metodo _enter_tree para agrupar esta accion del script.
func _enter_tree() -> void:
	# Llama al metodo DialogueSettings.set_user_value para realizar esta accion en este punto.
	DialogueSettings.set_user_value("is_running_test_scene", false)


#region Signals


# Define el metodo _on_dialogue_ended para agrupar esta accion del script.
func _on_dialogue_ended(_resource: DialogueResource):
	# Llama al metodo get_tree para realizar esta accion en este punto.
	get_tree().quit()


#endregion
