extends CharacterBody2D

@export var health: int = 100
	
func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		get_parent().queue_free()
