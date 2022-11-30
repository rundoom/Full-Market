extends Spare


func _ready() -> void:
	if !is_inside_tree(): return
	$"Капли".frame = randi_range(0, $"Капли".hframes - 1)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	linear_velocity = Vector2(randf_range(-500, 500), randf_range(-500, 500))
	tween.tween_property(self, "gravity_scale", 0, 0.5)
	tween.finished.connect(change_to_puddle)


func _integrate_forces(state):
	rotation = position.angle_to(linear_velocity)


func change_to_puddle():
	$"Капли".visible = false
	$"ЛужиКрови".frame = randi_range(0, $"ЛужиКрови".hframes - 1)
	var tween = create_tween()
	tween.tween_property($"ЛужиКрови", "scale", Vector2(0.1, 0.1), 0.5)
	tween.tween_interval(1)
	tween.tween_property($"ЛужиКрови", "scale", Vector2.ZERO, 3)
	tween.finished.connect(queue_free)
