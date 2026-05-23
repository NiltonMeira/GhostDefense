extends PathFollow2D

@export var speed: float = 50.0

@onready var animated_sprite: AnimatedSprite2D = $Skeleton/AnimatedSprite2D

var reached_end = false

func _ready():
	progress = 0
	add_to_group("Enemy")

	if animated_sprite:
		animated_sprite.play("walk")
	else:
		print("AnimatedSprite2D não encontrado")

func _process(delta):
	progress += speed * delta

	if progress_ratio >= 1.0 and !reached_end:
		reached_end = true

		var wave_manager = get_tree().get_first_node_in_group("WaveManager")

		if wave_manager:
			wave_manager.lose_life(100)

		queue_free()
