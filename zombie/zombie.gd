extends CharacterBody2D


const SPEED := 150.0
var current_speed := 0.0

func _physics_process(delta: float) -> void:
	if !check_hero_collide():
		current_speed = SPEED
		var attractor := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
			
		var target_rotation = global_position.direction_to(attractor.global_position).angle()
		rotation = lerp_angle(rotation, target_rotation, 0.1)
		
		velocity = Vector2.RIGHT.rotated(rotation) * current_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func check_hero_collide():
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().is_in_group("zombie_attractor"):
			return true
