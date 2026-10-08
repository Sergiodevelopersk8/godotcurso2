# res://src/entities/player/states/in_dialogue.gd
class_name  InDialogue
# res://src/entities/player/states/in_dialogue.gd
extends PlayerState

var original_camera_rotation: Vector3
var original_player_rotation: Vector3

func enter(_msg := {}) -> void:
	can_rotate_camera = false
	can_move = false
	
	if player:
		player.direction = Vector3.ZERO
		player.velocity = Vector3.ZERO
		
		if player.ray_cast_interactuar:
			player.ray_cast_interactuar.enabled = false
			
		if player.camera_3d:
			original_camera_rotation = player.camera_3d.rotation
			original_player_rotation = player.rotation
		
		if _msg.has("focus_target") and _msg["focus_target"] is Vector3:
			enfocar_camara_hacia(_msg["focus_target"])

func enfocar_camara_hacia(target_position: Vector3) -> void:
	if not player or not player.camera_3d:
		return

	# 1. Guardamos las rotaciones iniciales
	var start_player_rot = player.rotation
	var start_cam_rot = player.camera_3d.rotation

	# 2. Calculamos hacia dónde debe mirar el Player (solo eje Y)
	# Duplicamos la transformación del player para calcular la rotación deseada sin moverlo aún
	var player_target_transform = player.global_transform.looking_at(
		Vector3(target_position.x, player.global_position.y, target_position.z), 
		Vector3.UP
	)
	var target_player_rot_y = player_target_transform.basis.get_euler().y

	# 3. Calculamos la inclinación vertical deseada para la Camera3D (eje X)
	var cam_target_transform = player.camera_3d.global_transform.looking_at(target_position, Vector3.UP)
	var target_cam_rot_x = cam_target_transform.basis.get_euler().x

	# 4. Creamos el Tween para animar suavemente ambos ejes
	var tween = create_tween().set_parallel(true)
	
	# Anima la rotación del Player en Y
	tween.tween_property(player, "rotation:y", target_player_rot_y, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	# Anima la inclinación de la Camera3D en X
	tween.tween_property(player.camera_3d, "rotation:x", target_cam_rot_x, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)




func exit() -> void:
	if player:
		if player.ray_cast_interactuar:
			player.ray_cast_interactuar.enabled = true
		if player.camera_3d:
			var tween = create_tween()
			tween.tween_property(player.camera_3d, "rotation", original_camera_rotation, 0.4)
