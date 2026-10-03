# res://autoloads/mission_manager.gd
extends Node

# Declara la semission_updated1al mission_updated; otros nodos pueden conectarse para reaccionar cuando se emita.
signal mission_updated(text: String)
# Declara la semission_completed1al mission_completed; otros nodos pueden conectarse para reaccionar cuando se emita.
signal mission_completed(mission_id: String)

# Diccionario simple de flags de progreso
var flags: Dictionary = {}

# Texto de la misión actual, para mostrar en HUD
var current_mission_text: String = ""

# Establece la misi?n activa y su texto visible para el jugador.
func set_mission(text: String) -> void:
	# Guarda en current_mission_text el resultado de text.
	current_mission_text = text
	# Emite la senal mission_updated con estos datos: text.
	mission_updated.emit(text)

# Guarda un valor booleano para la misi?n y sus condiciones.
func set_flag(flag_name: String, value: bool = true) -> void:
	# Ejecuta esta instruccion: flags[flag_name] = value.
	flags[flag_name] = value

# Consulta si una bandera espec?fica ya fue activada por la l?gica del juego.
func has_flag(flag_name: String) -> bool:
	# Termina el metodo y devuelve flags.get(flag_name, false) a quien lo llamo.
	return flags.get(flag_name, false)

# Marca la misi?n como completada y emite la se?al correspondiente.
func complete_mission(mission_id: String) -> void:
	# Llama al metodo set_flag para realizar esta accion en este punto.
	set_flag(mission_id + "_completada")
	# Emite la senal mission_completed con estos datos: mission_id.
	mission_completed.emit(mission_id)
