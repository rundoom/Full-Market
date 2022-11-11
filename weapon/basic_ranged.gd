extends Node2D


const Bullet := preload("res://weapon/bullet.tscn")
@onready var shoot_cooldown := $ShootCooldown


func _physics_process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	global_rotation = global_position.direction_to(mouse_pos).angle()
	scale.y = 1 if cos(rotation) > 0 else -1

	if Input.is_action_just_pressed("mouse_left") and shoot_cooldown.is_stopped():
		var bullet := Bullet.instantiate()
		add_child(bullet)
		bullet.global_transform = $BulletOuput.global_transform
		$ShootSound.pitch_scale = randf_range(0.8, 1.2)
		$ShootSound.play()
		shoot_cooldown.start()
