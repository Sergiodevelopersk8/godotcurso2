extends StaticBody3D

@export var id: String = "Interact"


func action_use():
	position += Vector3(1,1,1)
	pass
