extends PathFollow2D

@export var speed: float = 50.0

@onready var animated_sprite: AnimatedSprite2D = $boss/AnimatedSprite2D

var reached_end = false

func _ready():
	progress = 0
	add_to_group("Enemy")

	if animated_sprite != null:
		animated_sprite.play("walk")
	else:
		print("AnimatedSprite2D não encontrado no Boss")

func _process(delta):
	progress += speed * delta

	if progress_ratio >= 1.0:
		reached_end = true
		get_tree().current_scene.show_game_over()
		queue_free()
