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

@onready var pause_restart_button = $PauseMenu/Panel/RestartPauseButton
@onready var game_over_restart_button = $game_over/RestartOverButton
@onready var you_win_restart_button = $you_win/RestartWinButton
@onready var game_over_quit_button = $game_over/QuitButton
@onready var you_win_quit_button = $you_win/QuitButton

@export var tower_check_radius: float = 32.0


var money: int = 0

var placing_hero := false
var game_finished := false

var preview_hero = null

func _ready():
	you_win.visible = false
	game_over.visible = false
	pause_menu.visible = false
	
	continue_button.pressed.connect(resume_game)

	quit_button.pressed.connect(quit_game)
	game_over_quit_button.pressed.connect(quit_game)
	you_win_quit_button.pressed.connect(quit_game)

	pause_restart_button.pressed.connect(restart_game)
	game_over_restart_button.pressed.connect(restart_game)
	you_win_restart_button.pressed.connect(restart_game)
	
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
		start_placing_hero()

	if placing_hero and preview_hero != null:
		var mouse_pos = get_global_mouse_position()
		preview_hero.global_position = mouse_pos

		var valid_position = can_place_tower(mouse_pos)
		preview_hero.can_place = valid_position
		preview_hero.queue_redraw()

func start_placing_hero():
	if hero_scene == null:
		return

	placing_hero = true

	if preview_hero != null:
		preview_hero.queue_free()

	preview_hero = hero_scene.instantiate()
	preview_hero.is_preview = true
	preview_hero.show_range = true
	preview_hero.placement_radius = tower_check_radius
	preview_hero.modulate = Color(1, 1, 1, 0.5)

	disable_collision(preview_hero)

	add_child(preview_hero)

func disable_collision(node):
	for child in node.get_children():
		if child is CollisionShape2D:
			child.disabled = true
		
		disable_collision(child)
		
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

	if !can_place_tower(spawn_position):
		print("Não pode colocar torre aqui!")
		return

	if !spend_money(hero_cost):
		placing_hero = false
		remove_preview_hero()
		return

	var hero = hero_scene.instantiate()
	hero.global_position = spawn_position
	add_child(hero)

	placing_hero = false
	remove_preview_hero()

func remove_preview_hero():
	if preview_hero != null:
		preview_hero.queue_free()
		preview_hero = null
		
func can_place_tower(position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var shape = CircleShape2D.new()
	shape.radius = tower_check_radius

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, position)
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_shape(query)

	return result.is_empty()
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
	
func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
