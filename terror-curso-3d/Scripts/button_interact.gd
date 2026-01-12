extends Interact
class_name ButtonInteract

@onready var anim_button: AnimationPlayer = $AnimButton


var isActivated:bool = false :
	set(value):
		isActivated = value
		if isActivated:
			anim_button.play("use_anim")
		else:
			anim_button.play_backwards("use_anim")
 
func action_use():
	emit_signal("isInteracted")
	isActivated = not isActivated
	AudioStreamManager.play("res://AssetsModels/FlashLigth/FlashlightOn.ogg")
	pass
