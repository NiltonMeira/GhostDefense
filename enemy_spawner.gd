extends Node2D

@export var enemy_scene: PackedScene

@onready var paths = [
	$"../Path2D",
	$"../Path2D2"
]
@onready var wave_label = $"../WaveLabel"

@export var reward: int = 25

var waves = [
	{
		"count": 2,
		"speed": 40.0,
		"spawn_delay": 1.5
	},
	{
		"count": 2,
		"speed": 55.0,
		"spawn_delay": 1.2
	},
	{
		"count": 4,
		"speed": 70.0,
		"spawn_delay": 1.0
	},
	{
		"count": 6,
		"speed": 90.0,
		"spawn_delay": 0.8
	},
	{
		"count": 8,
		"speed": 90.0,
		"spawn_delay": 0.8
	},
	{
		"count": 10,
		"speed": 90.0,
		"spawn_delay": 0.8
	},
	{
		"count": 5,
		"speed": 200.0,
		"spawn_delay": 0.2
	},
]

func _ready():
	start_waves()

func start_waves():

	for i in range(waves.size()):

		var wave = waves[i]

		wave_label.text = "WAVE " + str(i + 1)

		await spawn_wave(wave, i)

		while get_tree().get_nodes_in_group("Enemy").size() > 0:
			await get_tree().create_timer(0.5).timeout
			
		get_tree().current_scene.add_money(reward)

		await get_tree().create_timer(2.0).timeout

	get_tree().current_scene.show_you_win()

func spawn_wave(wave, wave_index):
	for i in range(wave["count"]):

		var enemy = enemy_scene.instantiate()

		enemy.speed = wave["speed"]

		var skeleton = enemy.get_node("Skeleton")

		# aumenta 5 de vida por rodada
		skeleton.health += wave_index * 5

		var selected_path = paths.pick_random()
		selected_path.add_child(enemy)

		await get_tree().create_timer(
			wave["spawn_delay"]
		).timeout
