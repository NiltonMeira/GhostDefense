extends Node2D

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene

@onready var paths = [
	$"../Path2D",
	$"../Path2D2"
]

@onready var wave_label = $"../WaveLabel"

@export var reward: int = 25

var current_wave: int = 1


func _ready():
	start_waves()


func start_waves():
	while true:
		wave_label.text = "WAVE " + str(current_wave)

		var wave = generate_wave(current_wave)

		await spawn_wave(wave, current_wave)

		while get_tree().get_nodes_in_group("Enemy").size() > 0:
			await get_tree().create_timer(0.5).timeout

		get_tree().current_scene.add_money(reward + current_wave * 2)

		current_wave += 1

		await get_tree().create_timer(2.0).timeout


func generate_wave(wave_number: int) -> Dictionary:
	var is_boss_wave = wave_number % 10 == 0

	if is_boss_wave:
		return {
			"count": 1,
			"speed": 45.0 + wave_number * 2,
			"spawn_delay": 0.2,
			"boss": true,
			"health_bonus": wave_number * 20
		}

	return {
		"count": 2 + wave_number * 2,
		"speed": 35.0 + wave_number * 5,
		"spawn_delay": max(1.8 - wave_number * 0.08, 0.35),
		"boss": false,
		"health_bonus": wave_number * 5
	}


func spawn_wave(wave: Dictionary, wave_number: int):
	for i in range(wave["count"]):
		var enemy

		if wave["boss"]:
			enemy = boss_scene.instantiate()
		else:
			enemy = enemy_scene.instantiate()

		enemy.speed = wave["speed"]

		var body = enemy.get_child(0)

		if body.has_method("set_health"):
			body.set_health(body.health + wave["health_bonus"])
		else:
			body.health += wave["health_bonus"]

		var selected_path = paths.pick_random()
		selected_path.add_child(enemy)

		await get_tree().create_timer(wave["spawn_delay"]).timeout
