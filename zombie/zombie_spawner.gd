extends Path2D


const Zombie := preload("res://zombie/zombie.tscn")
@onready var level = get_tree().get_first_node_in_group("level") 


func _on_timer_timeout() -> void:
	var zombie = Zombie.instantiate()
	$PathFollow2D.progress_ratio = randf()
	zombie.global_position = $PathFollow2D.global_position
	level.add_child(zombie)
