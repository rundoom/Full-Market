extends Area2D


@export_node_path(Node2D) var transparency_reciever_path: NodePath
@onready var transparency_reciever = get_node(transparency_reciever_path)


func _on_body_entered(body: Node2D) -> void:
	var transparency := create_tween()
	transparency.tween_property(transparency_reciever, "modulate", Color(1, 1, 1, 0.5), 0.5)


func _on_body_exited(body: Node2D) -> void:
	var transparency := create_tween()
	transparency.tween_property(transparency_reciever, "modulate", Color.WHITE, 0.5)
