extends Area2D


var enabled = false


func _ready() -> void:
	$SwingAnimation.play("still")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and "current_hp" in body:
		body.current_hp -= 3


func _physics_process(delta: float) -> void:
	if enabled:
		var mouse_pos := get_global_mouse_position()
		global_rotation = global_position.direction_to(mouse_pos).angle()
		scale.y = 1 if cos(rotation) > 0 else -1

		if Input.is_action_pressed("mouse_left"):
			$SwingAnimation.play("swing")


func arm(is_arm: bool):
	enabled = is_arm
	if !enabled:
		$SwingAnimation.queue("still")


func randomize_sound_pitch():
	$SwingSound.pitch_scale = randf_range(0.9, 1.1)


func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.is_in_group("zombie") and "current_hp" in body:
		body.current_hp -= 3
		$ImpactSound.play()
		
