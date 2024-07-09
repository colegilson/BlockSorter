extends Control

@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var help = $MarginContainer/HBoxContainer/VBoxContainer/help as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button
@onready var start_level = preload("res://scenes/Levels/level_1.tscn") as PackedScene

func _ready():
	start.button_down.connect(on_start_pressed)
	help.button_down.connect(on_help_pressed)
	exit.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Help screen/help.tscn")
	
func on_exit_pressed() -> void:
	get_tree().quit()
