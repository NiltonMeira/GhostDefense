extends CharacterBody2D

@export var health: int = 5000
@export var reward: int = 30
	
func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		get_tree().current_scene.add_money(reward)
		get_parent().queue_free()
