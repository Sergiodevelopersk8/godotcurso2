extends State
class_name RoamEnemyState

var target_location : Vector3
var navRange := 100


func enter(_msg := {}) -> void:
	owner.anim_enemy.play("runloop")
	var nextLocation =  Vector3.ZERO
	while nextLocation == Vector3.ZERO:
		nextLocation = roamLocation()
		print(nextLocation)


func roamLocation() -> Vector3:
	var origPos = owner.global_position
	target_location = Vector3(origPos.x + (navRange * randf_range(-1.0,1.0)),origPos.y,origPos.z+(navRange * randf_range(-1.0,1.0)))
	owner.nav_agent.set_target_position(target_location)
	print(target_location, "Is reachable ", owner.nav_agent.is_target_reachable())
	if owner.nav_agent.is_target_reachable():
		return target_location
	else:
		return Vector3.ZERO


func physics_update(_delta: float) -> void:
	if owner.nav_agent.is_target_reachable() and not owner.nav_agent.is_target_reachable():
		var nextLocation = owner.nav_agent.get_next_path_position()
		owner.velocity = owner.global_position.direction_to(nextLocation) * owner.speed
		
		if !owner.is_on_floor():
			owner.velocity.y -= 10
		
		owner.move_and_slide()
		owner.look_at(Vector3(nextLocation.x,0,nextLocation.z))
	else:
		state_machine.transition_to("Idle",{})
