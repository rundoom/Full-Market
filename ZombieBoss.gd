extends "res://zombie/zombie.gd"


const Zombie := preload("res://zombie/zombie.tscn")
@onready var level = get_tree().get_first_node_in_group("level") 


func _ready() -> void:
#	Avoid stuck in walls
	current_hp = 200
	move_and_slide()


func lose_hp(hp_val):
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.1)
		tween.tween_property(self, "modulate", Color.WHITE, 0.1)
		var blood_drop = BloodDrop.instantiate()
		var level = get_tree().get_first_node_in_group("level")
		level.add_child.call_deferred(blood_drop)
		blood_drop.global_position = global_position
		if hp_val <= 0:
			release_spare()
			$WinScreen.visible = true
			get_tree().paused = true


func _on_timer_timeout() -> void:
	var zombie = Zombie.instantiate()
	$ZombieSpawner/PathFollow2D.progress_ratio = randf()
	zombie.global_position = $ZombieSpawner/PathFollow2D.global_position
	level.add_child(zombie)


func _on_tree_exiting() -> void:
	pass
