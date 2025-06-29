extends Node

#referencia de los sonidos
const COINS = preload("res://Idle Tycoon Assets/Sound/coins.wav")
const NORMAL_SFX = preload("res://Idle Tycoon Assets/Sound/normal sfx.mp3")

#arreglo para guardar la referencia de los audiostreamplayer
@export var stream_players : Array[AudioStreamPlayer] 

#funcion de play
func play_audio(clip: AudioStream, volumen: float):
	#obtemos el audio streamplayer que este disponible 
	var free_player := get_free_audio_player()
	if free_player == null:
		return
	#sonido que va a reoriducir
	free_player.stream = clip
	#ajustar el volumen
	free_player.volume_db = volumen
	free_player.play()
	

func play_coins():
	play_audio(COINS, 20)

#funcion para el ui
func play_ui():
	play_audio(NORMAL_SFX, 0.5)




#funcion para saber que audio esta disponible
func get_free_audio_player()-> AudioStreamPlayer:
	#recorremos para saber si existe un audio sin reproducir
	for audio: AudioStreamPlayer in stream_players:
		#si encuentra uno libre lo retorna
		if not audio.playing:
			return audio
	#si no encuentra uno libre retorna un nulo
	return null
