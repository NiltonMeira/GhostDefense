extends CharacterBody2D

@export var health: int = 1000000

func _ready():
	add_to_group("Enemy")
	print("Inimigo entrou no grupo Enemy")
	
func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		queue_free()
