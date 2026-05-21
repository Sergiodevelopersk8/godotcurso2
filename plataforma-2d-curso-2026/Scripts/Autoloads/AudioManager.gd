extends Node
#Manager de audio
const BIT_BIT_LOOP = preload("uid://g5wo0i6g08ce")
const BUTTON_FOCUS = preload("res://assets/audio/sfx/button_focus.wav")
const ENEMY_DIE = preload("res://assets/audio/sfx/enemy_die.wav")
const JUMP = preload("res://assets/audio/sfx/jump.wav")
const PICKUP = preload("res://assets/audio/sfx/pickup.wav")
const PLAYER_DIE = preload("res://assets/audio/sfx/player_die.wav")
const SUCCESS = preload("res://assets/audio/sfx/success.wav")


var is_sfx_active = true
var is_music_active = true


func toggle_sfx():
	is_sfx_active = not is_sfx_active

func toggle_music():
	is_music_active = not is_music_active

func play_music(audio_stream,music):
	if is_music_active:
		audio_stream.stream = music
		audio_stream.play()

#funcion para reproducir sonidos 
func play_sfx(audio_stream_player, sfx):
	if is_sfx_active:
		audio_stream_player.stream = sfx
		audio_stream_player.play()
	


func reset_audio():
	is_sfx_active = true
	is_music_active = true
