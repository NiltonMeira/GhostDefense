extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var atack_speed: float = 1
@export var attack_range: float = 200.0

@onready var shooting_point = $ShootingPoint

@export var is_preview: bool = false
@export var show_range: bool = false

@export var placement_radius: float = 30.0
@export var can_place: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var shoot_frame: int = 4

var arrow_spawned := false
var is_shooting := false

func _ready():
	queue_redraw()

	if is_preview:
		return

	animated_sprite.play("idle")
	atack_loop()
	
func atack_loop():
	while true:
		shoot()

		var cooldown = 1.0 / max(atack_speed, 0.01)

		await get_tree().create_timer(cooldown).timeout

func shoot():
	if projectile_scene == null:
		return

	var enemy = get_target()

	if enemy == null:
		if animated_sprite.animation != "idle":
			animated_sprite.speed_scale = 1.0
			animated_sprite.play("idle")
		return

	# VIRAR PARA O INIMIGO
	if enemy.global_position.x < global_position.x:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true

	arrow_spawned = false

	animated_sprite.speed_scale = clamp(atack_speed / 2.0, 1.0, 8.0)
	animated_sprite.play("shoot")
	animated_sprite.set_frame_and_progress(0, 0.0)
	
func _on_animated_sprite_2d_frame_changed():
	if animated_sprite.animation != "shoot":
		return

	if animated_sprite.frame != shoot_frame:
		return

	if arrow_spawned:
		return

	arrow_spawned = true

	var enemy = get_target()

	if enemy == null:
		return

	create_projectile(enemy)

func create_projectile(enemy):
	if !is_instance_valid(enemy):
		return

	var target_position = enemy.global_position + Vector2(0, -15)

	var direction = (
		target_position - shooting_point.global_position
	).normalized()

	var projectile = projectile_scene.instantiate()
	projectile.global_position = shooting_point.global_position
	projectile.direction = direction
	projectile.rotation = direction.angle() + deg_to_rad(180)

	get_tree().current_scene.add_child(projectile)
	
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "shoot":
		animated_sprite.speed_scale = 1.0
		animated_sprite.play("idle")

func get_target():
	var enemies = get_tree().get_nodes_in_group("Enemy")

	var best_enemy = null
	var best_progress = -1.0

	for enemy in enemies:
		if !is_instance_valid(enemy):
			continue
		
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance > attack_range:
			continue

		if enemy.progress > best_progress:
			best_progress = enemy.progress
			best_enemy = enemy

	return best_enemy
	
func _draw():
	if !show_range:
		return

	var center = Vector2.ZERO
	var color = Color.WHITE

	if !can_place:
		color = Color.RED

	draw_arc(
		center,
		attack_range,
		0,
		TAU,
		180,
		color,
		2.5,
		true
	)

	draw_arc(
		Vector2.ZERO,
		placement_radius,
		0,
		TAU,
		120,
		color,
		2.5,
		true
	)
