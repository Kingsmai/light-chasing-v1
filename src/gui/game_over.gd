extends Control

signal restart
signal main_menu


func _on_restart_button_pressed() -> void:
	restart.emit()


func _on_main_menu_buttton_pressed() -> void:
	main_menu.emit()
