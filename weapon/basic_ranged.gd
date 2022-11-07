extends Node2D


const Bullet := preload("res://weapon/bullet.tscn")
@onready var shoot_cooldown := $ShootCooldown
@onready var sound_variation: Array[AudioStreamWAV] = [
	preload("res://weapon/пистолет 1.wav"),
	preload("res://weapon/пистолет 2.wav"),
	preload("res://weapon/пистолет 3.wav")
	]


func _physics_process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	global_rotation = global_position.direction_to(mouse_pos).angle()
	scale.y = 1 if cos(rotation) > 0 else -1

	if Input.is_action_pressed("mouse_left") and shoot_cooldown.is_stopped():
		var bullet := Bullet.instantiate()
		add_child(bullet)
		bullet.global_transform = $BulletOuput.global_transform
		$ShootSound.stream = sound_variation.pick_random()
		$ShootSound.pitch_scale = randf_range(0.5, 1.5)
		$ShootSound.play()
		shoot_cooldown.start()
