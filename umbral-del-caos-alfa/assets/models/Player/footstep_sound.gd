# res://assets/models/Player/footstep_sound.gd
# Reproduce sonidos de pasos dependiendo del tipo de suelo sobre el que está el jugador.

# Hereda de AudioStreamPlayer y reutiliza sus propiedades y comportamiento base.
extends AudioStreamPlayer
# Registra FootstepPlayer como nombre de clase global para usarlo en otros scripts.
class_name FootstepPlayer

# Referencia al nodo del jugador para comprobar si está en el suelo.
@export var player: Player

# Raycast que detecta el objeto o superficie bajo los pies del personaje.
@export var ground_raycast: RayCast3D

# Sonido por defecto si no se detecta ningún tipo de suelo concreto.
const DEFAULT_FOOTSTEP = preload("res://assets/audio/SFX/footsteps/boots/0.ogg")

# Mapa que relaciona nombres de materiales/suelos con sus respectivos sonidos.
# Se usa para cambiar el audio según la superficie detectada.
const FOOTSTEP_AUDIO_MAP = {
	# Asocia la clave "Grass" con preload("res://assets/audio/SFX/footsteps/grass/0.ogg") dentro del diccionario.
	"Grass": preload("res://assets/audio/SFX/footsteps/grass/0.ogg"),
	# Asocia la clave "Metal" con preload("res://assets/audio/SFX/footsteps/metal/0.ogg") dentro del diccionario.
	"Metal": preload("res://assets/audio/SFX/footsteps/metal/0.ogg"),
	# Asocia la clave "Concrete" con preload("res://assets/audio/SFX/footsteps/wood/0.ogg") dentro del diccionario.
	"Concrete": preload("res://assets/audio/SFX/footsteps/wood/0.ogg"),
	# Asocia la clave "Terrazzo" con preload("res://assets/audio/SFX/footsteps/wood/0.ogg") dentro del diccionario.
	"Terrazzo": preload("res://assets/audio/SFX/footsteps/wood/0.ogg")
}

# Ejecuta el sonido del paso actual.
# Detecta el suelo bajo el jugador, selecciona el audio adecuado y lo reproduce con un tono aleatorio.
func play_footstep() -> void:
	# Si no hay jugador o el personaje no está tocando el suelo, no se reproduce nada.
	if not player or not player.is_on_floor():
		# Termina el metodo sin devolver un valor.
		return

	# Sonido inicial por defecto.
	var selected_stream: AudioStream = DEFAULT_FOOTSTEP

	# Si el raycast detecta algo bajo el jugador, revisamos su material para elegir el sonido correcto.
	if ground_raycast and ground_raycast.is_colliding():
		# Crea collider e inicializa su valor con ground_raycast.get_collider().
		var collider = ground_raycast.get_collider()
		# Comprueba collider; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if collider:
			# El collider suele estar en un nodo hijo; buscamos el padre para leer su mesh material.
			var ground_mesh = collider.get_parent()
			# Verifica que el padre sea una malla 3D y que tenga un material asignado en la superficie 0.
			if ground_mesh is MeshInstance3D and ground_mesh.get_active_material(0) != null:
				# Obtiene la ruta del recurso del material para identificar el tipo de suelo por su nombre.
				var mat_path = ground_mesh.get_active_material(0).resource_path
				# Revisa cada tipo de superficie definido en el mapa de sonidos.
				for key in FOOTSTEP_AUDIO_MAP.keys():
					# Comprueba key in mat_path; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if key in mat_path:
						# Selecciona el sonido asociado a esa superficie.
						selected_stream = FOOTSTEP_AUDIO_MAP[key]
						# Detiene la búsqueda porque ya se encontró el sonido correspondiente.
						break

	# Asignamos el clip y variamos la altura del sonido para que no se 
	# repita exactamente igual.
	stream = selected_stream

	# Elige una variación aleatoria del tono entre 0.8 y 1.2 para dar variedad a cada paso.
	pitch_scale = randf_range(0.8, 1.2)

	# Reproduce el sonido de paso que acabamos de seleccionar.
	play()
