extends PlayerState
class_name Crouch_Player_State

#------------VARIABLES----------

@onready var raycast_crouch: RayCast3D = $"../../Raycasts/RaycastCrouch"
@onready var camera_3d: Camera3D = $"../../Camera3D"
@onready var pcap: CollisionShape3D = $"../../CollisionShape3D"

var has_crouch := false
var crouch_speed := 20

const HEIGHT_NORMAL = 2.5
const HEIGHT_CROUCH = 1.5
const CAM_NORMAL = 1.0
const CAM_CROUCH = 0.3

#------------FUNCIONE PROPIAS----------

func enter(_msg := {}) -> void:
	has_crouch = false
	pass

func update(delta: float):
	if get_tree().paused:
		player.velocity = Vector3.ZERO
		return
	# (Agachado o Levantado)
	var lerp_speed = 10.0 * delta # Una velocidad constante y suave
	
	if Input.is_action_pressed("action_crouch"):
		# Se agacha
		pcap.shape.height = lerp(pcap.shape.height, HEIGHT_CROUCH, lerp_speed)
		camera_3d.position.y = lerp(camera_3d.position.y, CAM_CROUCH, lerp_speed)
	elif !raycast_crouch.is_colliding():
		# Se levanta (solo si no hay nada en la cabeza)
		pcap.shape.height = lerp(pcap.shape.height, HEIGHT_NORMAL, lerp_speed)
		camera_3d.position.y = lerp(camera_3d.position.y, CAM_NORMAL, lerp_speed)
		
		# Si ya está casi estirado, vuelve a Idle
		if pcap.shape.height > 2.4:
			state_machine.change_state("Idle")

	# 2. CAMBIO A AIRE (Si cae de una plataforma)
	if !player.is_on_floor():
		state_machine.change_state("Air")


func camera_bob(delta):
	player._delta += delta
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down * 1.5
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0


func physics_update(delta: float):
	
	player.process_input(delta)
	
	# Movimiento  lento al estar agachado
	var target_vel = player.direction * (player.speed * 0.4)
	player.velocity.x = lerp(player.velocity.x, target_vel.x, player.accel * delta)
	player.velocity.z = lerp(player.velocity.z, target_vel.z, player.accel * delta)
	
	# Gravedad 
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()
