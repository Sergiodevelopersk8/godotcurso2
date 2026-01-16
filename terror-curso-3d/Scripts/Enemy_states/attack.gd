extends State
class_name AttackStateEnemy


func _handled_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void :
	pass


func physics_update(_delta: float) -> void:
	owner.anim_enemy.play("attack")

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass
