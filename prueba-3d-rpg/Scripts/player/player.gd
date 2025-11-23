extends CharacterBody3D
class_name Player

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var player_mesh = $Knight
@onready var camrot_h = $camroot/h
@onready var gameover_overlay: CanvasLayer = $"../gameover_overlay"


# --- parámetros exportados ---
@export var gravity: float = 9.8
@export var jump_force: float = 9.0
@export var walk_speed: float = 3.0
@export var run_speed: float = 10.0
@export var fall_limit: float = -100.0

# --- movimiento / estado ---
var direction: Vector3 = Vector3.ZERO
var horizontal_velocity: Vector3 = Vector3.ZERO
var vertical_velocity: Vector3 = Vector3.ZERO

var movement_speed: float = 0.0
var acceleration: float = 15.0
var angular_acceleration: float = 10.0

var is_attacking: bool 
var is_walking:bool
var is_running:bool
var is_dying: bool 
var aim_turn: float = 0.0

#nombre de las animaciones (nodos) 
var idle_node_name:String = "Idle"
var walk_node_name:String = "Walk"
var run_node_name:String = "Run"
var jump_node_name:String = "Jump"
var attack1_node_name:String = "Attack1"
var death_node_name:String = "Death"



func _ready() :
	vertical_velocity = Vector3.ZERO
	horizontal_velocity = Vector3.ZERO
	direction = Vector3.ZERO
	

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015

func _physics_process(delta: float) :
	if is_dying:
		
		return
	if global_transform.origin.y < fall_limit:
		reset_player_position()
		return
	var on_floor = is_on_floor()
	# ---------- GRAVEDAD ----------
	if on_floor:
		if vertical_velocity.y < 0:
			vertical_velocity.y = -gravity * 0.1
	else:
		vertical_velocity.y -= gravity * delta * 2.0
	 # ---------- SALTO ----------
	if Input.is_action_just_pressed("jump") and on_floor and not is_attacking:
		vertical_velocity.y = jump_force
		attack1()
		# ---------- DIRECCIÓN (inputs) ----------
	if(attack1_node_name in playback.get_current_node()):
		is_attacking = true
	else:
		is_attacking = false
	direction = Vector3.ZERO
	var h_rot = camrot_h.global_transform.basis.get_euler().y
	if Input.is_action_pressed("forward") or Input.is_action_pressed("backward") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),0,Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		if direction != Vector3.ZERO:
			direction = direction.normalized()
			direction = direction.rotated(Vector3.UP, h_rot)
		# sprint
		if Input.is_action_pressed("sprint"):
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
	else:
		movement_speed = 0.0
	# ---------- ROTACIÓN MESH ----------
	is_running = movement_speed == run_speed and direction != Vector3.ZERO
	is_walking = movement_speed == walk_speed and direction != Vector3.ZERO
	
	if Input.is_action_just_pressed("death_button"):
		is_dying = true
		await get_tree().create_timer(1).timeout
		gameover_overlay.game_over()
	
	
	# ---------- ataque ----------
	if Input.is_action_just_pressed("attack") and not is_attacking and on_floor:
		attack1()
	if attack1_node_name in playback.get_current_node():
		is_attacking = true
	else:
		is_attacking = false
	# ---------- ROTACIÓN MESH ----------
	if Input.is_action_pressed("aim"):
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, camrot_h.global_transform.basis.get_euler().y, delta * angular_acceleration)
	elif direction != Vector3.ZERO:
		var target_angle = atan2(direction.x, direction.z)
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, target_angle, delta * angular_acceleration)
	# ---------- HORIZONTAL VELOCITY (suavizado) ----------
	var target_h = direction * (0.01 if is_attacking else movement_speed)
	horizontal_velocity = horizontal_velocity.lerp(target_h, acceleration * delta)
	# ---------- ASIGNAR VELOCIDADES FINALES ----------
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	velocity.y = vertical_velocity.y
	move_and_slide()
	
	# seguridad extra: evitar NaN o inf
	if not is_vector_finite(velocity):
		reset_player_position()
		return
	
	# ---------- ASIGNAR VELOCIDADES FINALES ----------
	if is_attacking:
		playback.travel(attack1_node_name)
	elif not on_floor:
		playback.travel(jump_node_name)
	elif is_running:
		playback.travel(run_node_name)
	elif is_walking:
		playback.travel(walk_node_name)
	else:
		playback.travel(idle_node_name)
	
	
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsInAir"] = !on_floor
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	animation_tree["parameters/conditions/is_dying"] = is_dying
	






func reset_player_position():
	
	global_transform.origin = Vector3(0, 2, 0) # ajústalo a tu punto de respawn
	horizontal_velocity = Vector3.ZERO
	vertical_velocity = Vector3.ZERO
	velocity = Vector3.ZERO

func is_vector_finite(v: Vector3) -> bool:
	return is_finite(v.x) and is_finite(v.y) and is_finite(v.z)

func is_finite(x: float) -> bool:
	return not (x != x or x == INF or x == -INF) # NaN check + infinity

func attack1():
	if(idle_node_name in playback.get_current_node()) or (walk_node_name in playback.get_current_node()) or (run_node_name in playback.get_current_node()):
		if Input.is_action_just_pressed("attack"):
			if !is_attacking:
				playback.travel(attack1_node_name)
	pass
