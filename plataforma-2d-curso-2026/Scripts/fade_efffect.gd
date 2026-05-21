extends Control
class_name FadeEffect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	visible = true
	animation_player.play("fade_in")
	Signalmanager.level_completed.connect(_on_level_completed)


func _on_level_completed():
	animation_player.play("fade_out")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		Autoload.load_next_level()
