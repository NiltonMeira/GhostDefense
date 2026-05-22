extends Node2D

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene

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
		"spawn_delay": 1.8
	}, # tutorial

	{
		"count": 3,
		"speed": 45.0,
		"spawn_delay": 1.6
	},

	{
		"count": 5,
		"speed": 50.0,
		"spawn_delay": 1.4
	},

	{
		"count": 6,
		"speed": 55.0,
		"spawn_delay": 1.3
	},

	{
		"count": 8,
		"speed": 60.0,
		"spawn_delay": 1.2
	},

	{
		"count": 10,
		"speed": 70.0,
		"spawn_delay": 1.0
	},

	{
		"count": 12,
		"speed": 80.0,
		"spawn_delay": 0.9
	},

	{
		"count": 14,
		"speed": 90.0,
		"spawn_delay": 0.8
	},

	{
		"count": 16,
		"speed": 100.0,
		"spawn_delay": 0.7
	},

	{
		"count": 1,
		"speed": 50.0,
		"spawn_delay": 0.2,
		"boss": true
	} 
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

		await get_tree().create_timer(0).timeout

	get_tree().current_scene.show_you_win()

func spawn_wave(wave, wave_index):

	for i in range(wave["count"]):

		var enemy

		if wave.has("boss") and wave["boss"]:
			enemy = boss_scene.instantiate()
		else:
			enemy = enemy_scene.instantiate()

		enemy.speed = wave["speed"]

		var body = enemy.get_child(0)

		body.health += wave_index * 5

		var selected_path = paths.pick_random()

		selected_path.add_child(enemy)

		await get_tree().create_timer(
			wave["spawn_delay"]
		).timeout
