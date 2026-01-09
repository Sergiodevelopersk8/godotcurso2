# res://Scripts/States/Crouch.gd
extends PlayerState
class_name Crouch


@onready var raycast_crouch: RayCast3D = $"../../Raycasts/RaycastCrouch"
@onready var camera_3d: Camera3D = $"../../Camera3D"
@onready var pcap: CollisionShape3D = $"../../CollisionShape3D"


var hasCrouched := false
var crouchSpeed := 20


func enter(_msg = {}) -> void:
	hasCrouched = false
	pass


func update(delta: float) -> void:
	if !hasCrouched:
		if pcap.shape.height >= 1.5:
			#interpolacion lineal
			pcap.shape.height -= crouchSpeed * delta
		
		camera_3d.position.y = lerp(camera_3d.position.y, .3, crouchSpeed * delta)
		
		if pcap.shape.height <= 1.5 : #limite hasta donde se agacha 
			hasCrouched = true
	else: #esta agachado
		camera_bob(delta)
	
	if !raycast_crouch.is_colliding() and !Input.is_action_pressed("action_crouch"):
		pcap.shape.height += crouchSpeed * delta
		camera_3d.position.y = lerp(camera_3d.position.y,1.0, crouchSpeed * delta)
		
		if pcap.shape.height >= 2.5:
			state_machine.transition_to("Idle",{}) 
	
	#if !player.is_on_floor():
		#state_machine.transition_to("Air",{})
	
	

func camera_bob(delta):
	player._delta += delta
	
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.camBobSpeed
	var objCam = camera_3d.position + Vector3.UP * sin(cam_bob) * player.camBobUpDown 
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0

func physics_update(delta: float) -> void:
	player.process_input(delta)
	player.velocity = player.velocity.lerp(player.direction * player.speed * .3, player.accel * delta)
	player.velocity.y -= player.GRAVITY * delta
	player.move_and_slide()
