extends BasicRanged


var starting = false


func handle_shoot():
	if Input.is_action_just_released("mouse_left"):
		$ShootSound.stop()
		starting = false
		if current_mag > 0: $EndSound.play_if_not_yet()
	if INPUT_ACTION.call():
		if !starting and !$StartSound.playing and $ReloadTime.is_stopped():
			$StartSound.finished.connect(func(): if INPUT_ACTION.call(): starting = true)
			$StartSound.play_if_not_yet()
			
		if current_mag > 0 and shoot_cooldown.is_stopped() and starting:
			var bullet_direction := $BulletOuput.global_rotation as float
			for i in BULLET_COUNT:
				var bullet := Bullet.instantiate()
				bullet.speed = randi_range(bullet.speed - BULLET_SPEED_SPRED, bullet.speed + BULLET_SPEED_SPRED) 
				bullet.global_position = $BulletOuput.global_position
				bullet.global_rotation = (randf_range(bullet_direction - SPREAD, bullet_direction + SPREAD) + randf_range(bullet_direction - SPREAD, bullet_direction + SPREAD)) / 2
				var level = get_tree().get_first_node_in_group("level")
				level.add_child(bullet)
			$ShootSound.pitch_scale = randf_range(0.9, 1.1)
			$ShootSound.play_if_not_yet()
			shoot_cooldown.start()
			current_mag -= 1
			reload_bar.value += 1
		elif $ReloadTime.is_stopped() and current_mag <= 0:
			$EndSound.play_if_not_yet()
			$ShootSound.stop()
			$ReloadTime.start()
			var reloader := create_tween()
			reloader.tween_property(reload_bar, "value", 0, $ReloadTime.wait_time)
