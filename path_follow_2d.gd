extends PathFollow2D

const SPEED = 200.0

func _process(delta):
	progress += SPEED * delta
