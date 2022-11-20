extends Area2D


var enabled = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and "current_hp" in body:
		body.current_hp -= 3


func _physics_process(delta: float) -> void:
	if enabled:
		if !$SwingAnimation.is_playing():
			var mouse_pos := get_global_mouse_position()
			global_rotation = global_position.direction_to(mouse_pos).angle()
			scale.y = 1 if cos(rotation) > 0 else -1

		if Input.is_action_pressed("mouse_left") and !$SwingAnimation.is_playing():
			$SwingAnimation.play("swing")


func arm(is_arm: bool):
	enabled = is_arm
	if !enabled:
		$SwingAnimation.queue("still")


func randomize_sound_pitch():
	$SwingSound.pitch_scale = randf_range(0.8, 1.2)
