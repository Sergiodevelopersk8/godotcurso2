# res://src/core/Managers/GameManager.tscn
# script de gamemanager se creo una escena con un nodo blanco 
extends Node

# Señales globales para desacoplar sistemas
signal memela_entregada(total_actual: int)
signal minijuego_memelas_completado
signal player_health_changed(nueva_vida: int)

# Estado del Minijuego
const MEMELAS_OBJETIVO: int = 3
var memelas_entregadas: int = 0

# Atributos del Jugador
var player_health: int = 100

var is_following_player : bool = false 


func entregar_memela() -> void:
	memelas_entregadas += 1
	memela_entregada.emit(memelas_entregadas)
	print("[GameManager] Memela entregada. Total: ", memelas_entregadas)
	
	if memelas_entregadas >= MEMELAS_OBJETIVO:
		print("[GameManager] ¡Minijuego completado!")
		is_following_player = true # <--- Activamos la bandera aquí mismo
		minijuego_memelas_completado.emit()


func modificar_vida(cantidad: int) -> void:
	player_health = clamp(player_health + cantidad, 0, 100)
	player_health_changed.emit(player_health)
