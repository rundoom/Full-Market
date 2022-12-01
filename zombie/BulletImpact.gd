extends AudioStreamPlayer2D


func _on_finished() -> void:
	var level = get_tree().get_first_node_in_group("level")
	if get_parent() == level:
		queue_free()
