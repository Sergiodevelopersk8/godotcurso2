extends Node3D
class_name LightCelling

@onready var spot_light_3d: OmniLight3D = $SpotLight3D
@onready var timer_parpadeo: Timer = $TimerParpadeo
@onready var flicker_light: AudioStreamPlayer3D = $FlickerLight

@export var flickering = false
@export var time_flicker = .5


func _ready() -> void:
	if flickering:
		if flickering:
			timer_parpadeo.wait_time = time_flicker
			timer_parpadeo.start()
			flicker_light.play()
	
	timer_parpadeo.connect("timeout",flicker)


func flicker():
	spot_light_3d.visible = not spot_light_3d.visible
