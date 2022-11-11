extends AnimatableBody2D


const speed = 1000


func _physics_process(delta: float) -> void:
	move_and_collide(Vector2.RIGHT.rotated(rotation) * delta * speed)
