extends Control

func _ready():
	$StartButton.pressed.connect(_on_start_pressed)
	$Options.pressed.connect(_on_options_pressed)
	$Quit.pressed.connect(_on_quit_pressed)


func _on_start_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game.tscn")


func _on_options_pressed():
	print("Opções ainda não implementadas")


func _on_quit_pressed():
	get_tree().quit()
