extends Node

#sound manager

#referencias a los sonidos
const CLICK_1 = preload("res://LeapNight Assets/Sound/click1.ogg")
const IMPACT_BELL_HEAVY_004 = preload("res://LeapNight Assets/Sound/impactBell_heavy_004.ogg")
const IMPACT_WOOD_MEDIUM_002 = preload("res://LeapNight Assets/Sound/impactWood_medium_002.ogg")
const JUMPING_SFX = preload("res://LeapNight Assets/Sound/jumping sfx.mp3")

#referencia al nodo
@onready var sfx_streams: Node = $SFXStreams


func play_fruit():
	play_audio(CLICK_1)

func play_impact():
	play_audio(IMPACT_WOOD_MEDIUM_002)

func play_jump():
	play_audio(JUMPING_SFX)


func play_audio(audio: AudioStream):
	var audio_stream := get_free_stream()
	audio_stream.stream = audio 
	audio_stream.play()


func get_free_stream()-> AudioStreamPlayer:
	#recorremos los hijos del nodo
	for stream: AudioStreamPlayer in sfx_streams.get_children():
		#si no hay nodo reproduciendo
		if not stream.playing :
			#regresa el nodo que esta libre
			return stream
	
	#si todo esta ocupado retorna un nulo
	return null
