extends Control

signal resume_game
signal restart_game
signal back_to_main_menu


func _on_restart_button_pressed() -> void:
	restart_game.emit()


func _on_resume_button_pressed() -> void:
	resume_game.emit()


func _on_main_menu_buttton_pressed() -> void:
	back_to_main_menu.emit()
