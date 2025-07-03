extends CharacterBody2D
class_name Player

#variables
@export var max_speed := 180
@export var jump_force := 450
@export var max_jumps := 2
@export var gravity := 1600.0

#referencias al nodo de visuals animaciones y raycast
@onready var visuals: Node2D = $Visuals
@onready var anim_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var ray_cast: RayCast2D = $Visuals/RayCast2D
