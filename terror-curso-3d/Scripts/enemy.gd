extends CharacterBody3D

@onready var anim_enemy: AnimationPlayer = $EnemyWAnimGLTF/AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_machine: StateMachine = $StateMachine

var player:Player
var speed := 3.0 
var speedWalk := 3.0 
var speedRun := 9.0 

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	anim_enemy.play("runloop")
