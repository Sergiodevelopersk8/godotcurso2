extends Control
class_name StartGameMain


@onready var start_button: Button = $VBoxContainer/StartButton
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sfx_button: Button = $VBoxContainer/SFXButton
@onready var music_button: Button = $VBoxContainer/MusicButton


func _ready() -> void:
	AudioManager.reset_audio()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_button.grab_focus()
	high_score_label.text = "High score: " + str(Autoload.high_score)


func _on_start_button_pressed() -> void:
	Autoload.load_next_level()


func _on_button_focus_entered() -> void:
	AudioManager.play_sfx(audio_stream_player_2d,AudioManager.BUTTON_FOCUS)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_sfx_button_pressed() -> void:
	AudioManager.toggle_sfx()
	if AudioManager.is_sfx_active:
		sfx_button.text = "SFX: ON"
	else:
		sfx_button.text = "SFX: OF"


func _on_music_button_pressed() -> void:
	AudioManager.toggle_music()
	if AudioManager.is_music_active:
		music_button.text = "MUSIC: ON"
	else:
		music_button.text = "MUSIC: OF"
