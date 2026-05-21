extends Area2D

@export var speed = 800.0
@export var damage: int = 25

var direction: Vector2 = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		queue_free()
