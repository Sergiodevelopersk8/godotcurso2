class_name Enemy
extends CharacterBody2D

@export var speed : float
@export var gravity :float

var player 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
