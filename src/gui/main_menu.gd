extends Control

signal start_game
signal how_to_play
signal quit_game
signal credits


func _on_start_game_button_pressed() -> void:
	start_game.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()


func _on_credits_button_pressed() -> void:
	credits.emit()


func _on_how_to_play_button_pressed() -> void:
	how_to_play.emit()
