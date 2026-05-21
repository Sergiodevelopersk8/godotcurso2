class_name Enemy
extends CharacterBody2D

@export var speed : float
@export var gravity :float
@onready var hurtbox: Area2D = $Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var points:int
@onready var audio_enemy: AudioStreamPlayer2D = $Audio_enemy
var player 


func _ready() -> void:
	Signalmanager.level_completed.connect(_on_level_completed)
	player = get_tree().get_first_node_in_group("Player")
	set_physics_process(false)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if player.position.y < hurtbox.global_position.y:
		animation_player.play("dissapear")
		set_physics_process(false) #pausa la fisica del enemigo cuando no este en pantalla
		animated_sprite_2d.pause()
		Autoload.update_score(points)
		AudioManager.play_sfx(audio_enemy, AudioManager.ENEMY_DIE)
		Signalmanager.score_update.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_physics_process(true) #reactiva el movimiento del enemigo cuando entre en pantallaa


func _on_level_completed():
	set_physics_process(false)
