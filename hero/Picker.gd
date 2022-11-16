extends Area2D



func _on_body_entered(body: Node2D) -> void:
	body.gravity_scale = 2


func _on_body_exited(body: Node2D) -> void:
	body.gravity_scale = 0
