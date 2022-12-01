extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and visible:
		get_tree().paused = false
		get_tree().reload_current_scene()
