extends Interact
class_name KeyInteract

signal keyTaken

func action_use():
	emit_signal("keyTaken")
	queue_free()
