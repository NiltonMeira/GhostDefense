extends PathFollow2D

const SPEED = 100.0

@onready var game_over = $'../../game_over'

func _process(delta):
	progress += SPEED * delta
	
	if progress_ratio >= 1.0:
		game_over.visible = true
		
		get_tree().paused = true
		
