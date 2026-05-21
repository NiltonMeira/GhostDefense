extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_delay: float = 1.5
@export var enemy_count: int = 10

func _ready():
	spawn_wave()

func spawn_wave():
	for i in enemy_count:

		var enemy = enemy_scene.instantiate()

		get_parent().get_node("Path2D").add_child(enemy)

		await get_tree().create_timer(spawn_delay).timeout
