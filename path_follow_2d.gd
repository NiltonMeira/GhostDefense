extends PathFollow2D

@export var speed: float = 50.0
var reached_end = false

func _ready():
	progress = 0
	add_to_group("Enemy")

func _process(delta):
	progress += speed * delta

	if progress_ratio >= 1.0:
		reached_end = true
		get_tree().current_scene.show_game_over()
		queue_free()
