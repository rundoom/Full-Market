extends RigidBody2D


var spare_sprite: Sprite2D


func _ready() -> void:
	if !is_inside_tree(): return
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	angular_velocity = randf_range(-50, 50)
	linear_velocity = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
	tween.tween_property(self, "gravity_scale", 0, 0.5)
	tween.tween_interval(2)
	tween.tween_property(spare_sprite, "scale", Vector2.ZERO, 2)
	tween.finished.connect(queue_free)
