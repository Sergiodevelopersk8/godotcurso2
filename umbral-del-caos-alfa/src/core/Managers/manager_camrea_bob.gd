extends Node

const DIALOGUE_BOB_SPEED := 0.8   # más lento que caminar, se siente como respiración
const DIALOGUE_BOB_HEIGHT := 0.1 # sutil, no queremos que distraiga del diálogo

# Pasamos 'target_player' como argumento para no depender de referencias nulas
func camera_bob(target_player: Player, delta: float) -> void:
	if not target_player:
		return
		
	target_player._delta += delta
	
	var cam_bob = floor(abs(target_player.direction.z) + abs(target_player.direction.x)) * target_player._delta * target_player.cam_Bob_Speed
	var objCam = target_player.origCamPos + Vector3.UP * sin(cam_bob) * target_player.cam_Bob_Up_Down
	target_player.camera_3d.position = target_player.camera_3d.position.lerp(objCam, delta)
	
	if target_player._delta > 20.0:
		target_player._delta = 0.0


func camera_bob_dialogue(target_player: Player, delta: float) -> void:
	if not target_player:
		return
		
	target_player._delta += delta
	var cam_bob = target_player._delta * DIALOGUE_BOB_SPEED
	var objCam = target_player.origCamPos + Vector3.UP * sin(cam_bob) * DIALOGUE_BOB_HEIGHT
	
	target_player.camera_3d.position = target_player.camera_3d.position.lerp(objCam, delta * 2.0)
	
	if target_player._delta > 20.0:
		target_player._delta = 0.0
