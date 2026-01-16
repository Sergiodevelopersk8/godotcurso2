extends State
class_name IdleStateEnemy

@onready var idle_timer: Timer = $IdleTimer


func enter(_msg := {}) -> void:
	owner.anim_enemy.play("idle")
	$"../../Area3D/CollisionShape3D".set_deferred("disabled",true)
	$"../../Area3D/CollisionShape3D".set_deferred("disabled",false)
	idle_timer.start()


func _on_idle_timer_timeout() -> void:
	print("enemigo de idle a roam ahora")
	state_machine.transition_to("Roam",{})
