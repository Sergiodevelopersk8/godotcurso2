extends Node

var score = 0
var is_game_over = false



func _process(delta):
	if is_game_over and Input.is_action_just_pressed("shoot"):
		restar_game()

func restar_game():
	get_tree().reload_current_scene()
	score = 0
	is_game_over = false
	

func add_score(points):
	if not is_game_over:
		score += points

func set_is_game_over(value):
	is_game_over = value
