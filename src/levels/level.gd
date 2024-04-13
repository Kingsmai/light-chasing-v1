extends Node2D

@onready var game_over: Control = $CanvasLayer/GameOver
@onready var pause_menu: Control = $CanvasLayer/PauseMenu


func _on_player_game_over() -> void:
	game_over.visible = true


func _on_game_over_restart() -> void:
	get_tree().reload_current_scene()


func _on_game_over_main_menu() -> void:
	get_tree().change_scene_to_file("res://src/gui/main_menu_scene.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		_open_pause_menu()


func _on_pause_menu_resume_game() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func _open_pause_menu() -> void:
	pause_menu.visible = true
	get_tree().paused = true


func _on_pause_menu_restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_pause_menu_back_to_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/gui/main_menu_scene.tscn")
