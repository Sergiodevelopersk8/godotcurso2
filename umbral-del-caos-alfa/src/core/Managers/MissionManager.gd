#res://src/core/Managers/MissionManager.gd
extends Node

signal mission_updated(text:String)


var misison_actual := ""
var tiene_memela := false
var mision_completada:= false

func set_mission(text:String):
	misison_actual = text
	mission_updated.emit(misison_actual)


func complete_mission():
	misison_actual = ""
	mision_completada = true
	mission_updated.emit("Mision Completada")
	#se borra el texto en 3 segundos
	await get_tree().create_timer(3.0).timeout
	mission_updated.emit("")
