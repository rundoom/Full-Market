extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if "current_hp" in body:
		body.current_hp -= 1


func _physics_process(delta: float) -> void:
	if !$SwingAnimation.is_playing():
		var mouse_pos := get_global_mouse_position()
		global_rotation = global_position.direction_to(mouse_pos).angle()
		scale.y = 1 if cos(rotation) > 0 else -1

	if Input.is_action_pressed("mouse_left") and !$SwingAnimation.is_playing():
		$SwingAnimation.play("swing")
