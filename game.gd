extends Node2D

@onready var you_win = $you_win
@onready var game_over = $game_over

@export var hero_scene: PackedScene

var placing_hero := false
var game_finished = false

func _ready():
	you_win.visible = false
	game_over.visible = false

func show_game_over():
	if game_finished:
		return

	game_finished = true
	game_over.visible = true

func show_you_win():
	if game_finished:
		return

	game_finished = true
	you_win.visible = true
	
func _process(_delta):
	if Input.is_action_just_pressed("place_hero"):
		placing_hero = true
		print("Modo colocar torre ativado")
	
func _unhandled_input(event):
	if placing_hero and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			place_hero(get_global_mouse_position())

func place_hero(spawn_position: Vector2):
	if hero_scene == null:
		print("Hero Scene não foi setada!")
		return

	var hero = hero_scene.instantiate()
	hero.global_position = get_global_mouse_position()
	add_child(hero)

	placing_hero = false
	print("Torre colocada em: ", hero.global_position)
		
		
