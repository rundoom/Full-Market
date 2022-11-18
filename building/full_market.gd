extends StaticBody2D


func _on_shopping_area_body_entered(body: Node2D) -> void:
	body.is_shopping_avaliable = true


func _on_shopping_area_body_exited(body: Node2D) -> void:
	body.is_shopping_avaliable = false
