extends RigidBody2D


func _ready() -> void:
	if !is_inside_tree(): return
	freeze = false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	angular_velocity = randf_range(10, 50)
	$SmallSparcle.emitting = true
	tween.tween_property(self, "gravity_scale", 0, 0.5)
	tween.tween_interval(2)
	tween.tween_property($Bullet, "scale", Vector2.ZERO, 2)
	tween.finished.connect(queue_free)
