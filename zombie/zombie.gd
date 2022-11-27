extends CharacterBody2D


var speed := randf_range(80, 150) 
var current_speed := 0.0
var is_hero_visible := false
var Money = preload("res://valuables/money.tscn")


var current_hp := 6:
	set(value):
		current_hp = value
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.1)
		tween.tween_property(self, "modulate", Color.WHITE, 0.1)
		if value <= 0:
			queue_free()
			

func _ready() -> void:
#	Avoid stuck in walls
	move_and_slide()


func _physics_process(delta: float) -> void:
	current_speed = speed
	var attractor := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
	if attractor != null and is_hero_visible == true:
		var target_rotation = global_position.direction_to(attractor.global_position).angle()
		$CenterPos.scale.x = -1 if cos(target_rotation) > 0 else 1
		velocity = Vector2.RIGHT.rotated(target_rotation) * current_speed
		move_and_slide()
		if get_slide_collision_count() == 0: $AnimationPlayer.current_animation = "Walk"
		for i in get_slide_collision_count():
			var collider = get_slide_collision(i).get_collider() as Node2D
			if collider.is_in_group("zombie_attractor"):
				collider.current_hp -= 0.2
				$AnimationPlayer.current_animation = "Attack"
			else:
				$AnimationPlayer.current_animation = "Walk"
	else :
		$AnimationPlayer.current_animation = "RESET"


func _on_tree_exiting() -> void:
	var hero := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
	var loot = Money.instantiate()
	var level = get_tree().get_first_node_in_group("level")
	loot.global_position = global_position
	level.add_child.call_deferred(loot)
	
	


func on_bullet_entered(bullet: Node2D) -> void:
		if bullet.is_in_group("bullet"):
			current_hp -= 1
