extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		visible = false
