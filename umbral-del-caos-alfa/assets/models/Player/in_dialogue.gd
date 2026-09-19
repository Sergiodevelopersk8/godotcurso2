# res://assets/models/Player/States/in_dialogue.gd
extends PlayerState

const DIALOGUE_BOB_SPEED := 0.8   # más lento que caminar, se siente como respiración
const DIALOGUE_BOB_HEIGHT := 0.03 # sutil, no queremos que distraiga del diálogo


func enter(_msg := {}) -> void:
	can_rotate_camera = false
	can_move = false

	if player:
		player.direction = Vector3.ZERO
		player.velocity = Vector3.ZERO
		if player.ray_cast_interactuar:
			player.ray_cast_interactuar.enabled = false

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func exit() -> void:
	if player and player.ray_cast_interactuar:
		player.ray_cast_interactuar.enabled = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func update(_delta: float) -> void:
	camera_bob(_delta)

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.friction * delta)
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()


func camera_bob(delta):
	player._delta += delta
	
	var cam_bob = player._delta * DIALOGUE_BOB_SPEED
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * DIALOGUE_BOB_HEIGHT
	
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta * 2.0)
	
	if player._delta > 20:
		player._delta = 0
