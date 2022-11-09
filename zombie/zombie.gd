extends CharacterBody2D


const SPEED := 150.0
var current_speed := 0.0

var current_hp := 4:
	set(value):
		current_hp = value
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.2)
		tween.tween_property(self, "modulate", Color.WHITE, 0.2)
		if value <= 0: queue_free()

func _physics_process(delta: float) -> void:
	current_speed = SPEED
	var attractor := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
	if attractor != null:
		var target_rotation = global_position.direction_to(attractor.global_position).angle()
		$CenterPos.scale.x = -1 if cos(target_rotation) > 0 else 1
		velocity = Vector2.RIGHT.rotated(target_rotation) * current_speed
		move_and_slide()


func _on_tree_exiting() -> void:
	var hero := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
	if hero != null:
		hero.combo_counter += 1
