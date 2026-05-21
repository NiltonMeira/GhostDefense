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
	var enemies = get_tree().get_nodes_in_group("Enemy")

	if enemies.is_empty():
		return

	var enemy = enemies[0]
	var direction = (enemy.global_position - shooting_point.global_position).normalized()

	var projectile = projectile_scene.instantiate()
	projectile.global_position = shooting_point.global_position
	projectile.direction = direction
	projectile.rotation = direction.angle() + deg_to_rad(180)

	get_tree().current_scene.add_child(projectile)
