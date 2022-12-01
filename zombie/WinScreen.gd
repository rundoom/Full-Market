extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event is InputEventKey and visible:
		get_tree().paused = false
		get_tree().reload_current_scene()
