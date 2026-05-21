extends PathFollow2D

const SPEED = 200.0
var reached_end = false

func _process(delta):
	if reached_end:
		return

	progress += SPEED * delta

	if progress_ratio >= 1.0:
		reached_end = true
		get_tree().current_scene.show_game_over()
		queue_free()
