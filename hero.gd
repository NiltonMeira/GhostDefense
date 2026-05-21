extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var atack_speed: float = 2.0

@onready var shooting_point = $ShootingPoint

func _ready():
	atack_loop()
	
func atack_loop():
	while true:
		shoot()
		
		var cooldown = 1.0/max(atack_speed, 0.01)
		await get_tree().create_timer(cooldown).timeout

func shoot():
	if projectile_scene == null:
		return

	var enemy = get_target()

	if enemy == null:
		return

	var direction = (enemy.global_position - shooting_point.global_position).normalized()

	var projectile = projectile_scene.instantiate()
	projectile.global_position = shooting_point.global_position
	projectile.direction = direction
	projectile.rotation = direction.angle()

	get_tree().current_scene.add_child(projectile)

func get_target():
	var enemies = get_tree().get_nodes_in_group("Enemy")

	var best_enemy = null
	var best_progress = -1.0

	for enemy in enemies:
		if !is_instance_valid(enemy):
			continue

		if enemy.progress > best_progress:
			best_progress = enemy.progress
			best_enemy = enemy

	return best_enemy
