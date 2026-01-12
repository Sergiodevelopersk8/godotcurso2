extends Interact
class_name LigthSwitch

@onready var light_celling: LightCelling = $LightCelling


func action_use():
	light_celling.flicker()
	AudioStreamManager.play("res://AssetsSoundsModels/237944__supersnd__light-switch-off.wav")
	pass
