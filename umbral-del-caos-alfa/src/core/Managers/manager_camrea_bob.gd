# Archivo: src/core/Managers/manager_camrea_bob.gd
# Descripci?n: Aplica un peque?o movimiento de c?mara para simular la sensaci?n de caminar o dialogar.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Node y reutiliza sus propiedades y comportamiento base.
extends Node

# Define DIALOGUE_BOB_SPEED con el valor fijo 0.8.
const DIALOGUE_BOB_SPEED := 0.8   # más lento que caminar, se siente como respiración
# Define DIALOGUE_BOB_HEIGHT con el valor fijo 0.1.
const DIALOGUE_BOB_HEIGHT := 0.1 # sutil, no queremos que distraiga del diálogo

# Pasamos 'target_player' como argumento para no depender de referencias nulas
# Genera un ligero movimiento de c?mara para reforzar la sensaci?n de caminar o hablar.
func camera_bob(target_player: Player, delta: float) -> void:
	# Comprueba not target_player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not target_player:
		# Termina el metodo sin devolver un valor.
		return
	#Incrementamos el delta acumulado del jugador para el efecto de bobbing	
	target_player._delta += delta
	
	#Calculamos el desplazamiento vertical de la cámara basado en la dirección del jugador y la velocidad de bobbing
	var cam_bob = floor(abs(target_player.direction.z) + abs(target_player.direction.x)) * target_player._delta * target_player.cam_Bob_Speed
	#Calculamos la nueva posición de la cámara aplicando un desplazamiento vertical basado en una función seno para simular el movimiento de bobbing
	var objCam = target_player.origCamPos + Vector3.UP * sin(cam_bob) * target_player.cam_Bob_Up_Down
	#Interpolamos suavemente la posición de la cámara hacia la nueva posición calculada para un efecto más natural
	target_player.camera_3d.position = target_player.camera_3d.position.lerp(objCam, delta)
	
	#Reseteamos el delta acumulado si supera un cierto umbral para evitar valores demasiado grandes que puedan afectar la suavidad del movimiento
	if target_player._delta > 20.0:
		#Reseteamos el delta acumulado para evitar que el efecto de bobbing se vuelva demasiado pronunciado o errático
		target_player._delta = 0.0


# Función específica para el efecto de bobbing durante diálogos, que es más lento y sutil que el bobbing normal
# Aplica un efecto de c?mara m?s suave durante el di?logo.
func camera_bob_dialogue(target_player: Player, delta: float) -> void:
	#Si no hay un jugador objetivo, salimos de la función para evitar errores
	if not target_player:
		#Si no hay un jugador objetivo, salimos de la función para evitar errores
		return
	#Incrementamos el delta acumulado del jugador para el efecto de bobbing durante el diálogo
	target_player._delta += delta
	#Calculamos el desplazamiento vertical de la cámara basado en la velocidad de bobbing específica para diálogos
	var cam_bob = target_player._delta * DIALOGUE_BOB_SPEED
	#Calculamos la nueva posición de la cámara aplicando un desplazamiento vertical basado en una función seno para simular el movimiento de bobbing
	var objCam = target_player.origCamPos + Vector3.UP * sin(cam_bob) * DIALOGUE_BOB_HEIGHT
	#Interpolamos suavemente la posición de la cámara hacia la nueva posición calculada para un efecto más natural durante el diálogo
	target_player.camera_3d.position = target_player.camera_3d.position.lerp(objCam, delta * 2.0)
	#si el delta acumulado supera el umbral, lo reiniciamos
	if target_player._delta > 20.0:
		# Reiniciamos el delta acumulado
		target_player._delta = 0.0
