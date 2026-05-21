extends Node2D

@onready var you_win = $you_win
@onready var game_over = $game_over

var game_finished = false

func _process(delta):

	if game_finished:
		return

	var enemies = get_tree().get_nodes_in_group("Enemy")

	if enemies.is_empty():
		game_finished = true
		you_win.visible = true

func show_game_over():
	if game_finished:
		return

	game_finished = true
	game_over.visible = true
