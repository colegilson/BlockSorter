extends Control

@onready var home = $home as Button
@onready var main_menu = preload("res://scenes/mainmenu/main_menu.tscn") as PackedScene

func _on_home_button_down():
	get_tree().change_scene_to_packed(main_menu)
