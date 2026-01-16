extends State
class_name ChaseStateEnemy


func _handled_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void :
	pass


func physics_update(_delta: float) -> void:
	owner.anim_enemy.play("runloop")

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass
