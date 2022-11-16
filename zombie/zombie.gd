extends CharacterBody2D


var speed := randf_range(80, 150) 
var current_speed := 0.0
var is_hero_visible := false
var Money = preload("res://valuables/money.tscn")


var current_hp := 4:
	set(value):
		current_hp = value
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.1)
		tween.tween_property(self, "modulate", Color.WHITE, 0.1)
		if value <= 0:
			queue_free()


func _physics_process(delta: float) -> void:
	current_speed = speed
	var attractor := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
	if attractor != null and is_hero_visible == true:
		var target_rotation = global_position.direction_to(attractor.global_position).angle()
		$CenterPos.scale.x = -1 if cos(target_rotation) > 0 else 1
		velocity = Vector2.RIGHT.rotated(target_rotation) * current_speed
		move_and_slide()


func _on_tree_exiting() -> void:
	var hero := get_tree().get_first_node_in_group("zombie_attractor") as Node2D
	if hero != null:
		hero.combo_counter += 1
	var loot = Money.instantiate()
	loot.global_position = global_position
	get_tree().get_first_node_in_group("level").add_child.call_deferred(loot)


func _on_dmg_sponge_body_entered(body: Node2D) -> void:
		body.queue_free()
		current_hp -= 1
