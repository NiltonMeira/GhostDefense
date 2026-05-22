extends Node2D

@onready var you_win = $you_win
@onready var game_over = $game_over

@export var hero_scene: PackedScene

@onready var pause_menu = $PauseMenu
@onready var continue_button = $PauseMenu/Panel/ContinueButton
@onready var quit_button = $PauseMenu/Panel/QuitButton

@onready var money_label = $MoneyLabel
@export var starting_money: int = 100
@export var hero_cost: int = 100


var money: int = 0

var placing_hero := false
var game_finished := false

func _ready():
	you_win.visible = false
	game_over.visible = false
	pause_menu.visible = false
	
	continue_button.pressed.connect(resume_game)
	quit_button.pressed.connect(quit_game)
	
	money = starting_money
	update_money_label()

func show_game_over():
	if game_finished:
		return

	game_finished = true
	game_over.visible = true
	get_tree().paused = true

func show_you_win():
	if game_finished:
		return

	game_finished = true
	you_win.visible = true
	get_tree().paused = true

func _process(_delta):
	if game_finished:
		return

	if Input.is_action_just_pressed("pause"):
		toggle_pause()

	if get_tree().paused:
		return
		
	if Input.is_action_just_pressed("place_hero"):
		placing_hero = true

func _unhandled_input(event):
	if get_tree().paused:
		return

	if placing_hero and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			place_hero(get_global_mouse_position())

func place_hero(spawn_position: Vector2):
	if hero_scene == null:
		print("Hero Scene não foi setada!")
		return

	if !spend_money(hero_cost):
		placing_hero = false
		return

	var hero = hero_scene.instantiate()
	hero.global_position = spawn_position
	add_child(hero)

	placing_hero = false
	print("Torre colocada em: ", hero.global_position)

func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	placing_hero = false
	get_tree().paused = true
	pause_menu.visible = true

func resume_game():
	get_tree().paused = false
	pause_menu.visible = false

func quit_game():
	get_tree().quit()
	
	
func add_money(amount: int):
	money += amount
	update_money_label()

func spend_money(amount: int) -> bool:
	if money < amount:
		print("Dinheiro insuficiente!")
		return false

	money -= amount
	update_money_label()
	return true

func update_money_label():
	money_label.text = "$ " + str(money)
