extends Path2D


const Zombie := preload("res://zombie/zombie.tscn")
const ZombieBoss := preload("res://zombie/zombie.tscn")
@onready var level = get_tree().get_first_node_in_group("level") 


func _on_timer_timeout() -> void:
	$Timer.wait_time = clampf($Timer.wait_time - 0.002, 0.2, 100)
	if $Timer.wait_time == 0.2:
		$Timer.stop()
	
	if get_tree().get_nodes_in_group("zombie").size() > 100: return
	
	var zombie = Zombie.instantiate()
	$PathFollow2D.progress_ratio = randf()
	zombie.global_position = $PathFollow2D.global_position
	level.add_child(zombie)
	
