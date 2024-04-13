extends Node2D

@onready var credits: Control = $CanvasLayer/Credits
@onready var how_to_play: Control = $"CanvasLayer/How To Play"


func _on_main_menu_start_game() -> void:
	get_tree().change_scene_to_file("res://src/levels/test_level.tscn")


func _on_main_menu_quit_game() -> void:
	get_tree().quit()


func _on_main_menu_credits() -> void:
	credits.visible = true


func _on_main_menu_how_to_play() -> void:
	how_to_play.visible = true
