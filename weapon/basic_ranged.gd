extends Node2D


const Bullet := preload("res://weapon/bullet.tscn")
@onready var shoot_cooldown := $ShootCooldown


func _physics_process(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	global_rotation = global_position.direction_to(mouse_pos).angle()
	
	if Input.is_action_pressed("mouse_left") and shoot_cooldown.is_stopped():
		var bullet := Bullet.instantiate()
		add_child(bullet)
		bullet.global_transform = $BulletOuput.global_transform
		shoot_cooldown.start()
