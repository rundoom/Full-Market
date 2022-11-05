extends AnimatableBody2D


const speed = 1000


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2.RIGHT.rotated(rotation) * delta * speed)
	if collision != null:
		queue_free()
		if "current_hp" in collision.get_collider():
			collision.get_collider().current_hp -= 1
