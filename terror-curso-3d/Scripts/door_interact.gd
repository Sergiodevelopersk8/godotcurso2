extends Interact
class_name DoorInteract

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door: MeshInstance3D = $door1/door

@export var needsKey := false #si necesita una llave 
@export var isOpen := false 
@export var key: Node3D  


func _ready() -> void:
	if isOpen:
		door.rotation = Vector3(0,80,0)
	else:
		door.rotation = Vector3(0,0,0)


func action_use():
	if !is_instance_valid(key) and needsKey:
		needsKey = false
		logicDoor()
		get_tree().get_nodes_in_group("Player")[0].deleteKeyFromUI()
	
	if !needsKey:
		logicDoor()
	else:
		animation_player.play("door_locked")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "door_locked":
		isOpen = not isOpen


func logicDoor():
	if isOpen:
		animation_player.play("door_close")
	else:
		animation_player.play("door_open")
