extends Node2D


const Bullet := preload("res://weapon/bullet.tscn")
@onready var shoot_cooldown := $ShootCooldown as Timer
const MAG_SIZE := 15
var current_mag := MAG_SIZE
var enabled = false
@onready var reload_bar := $UI/ReloadBar


func _ready() -> void:
	reload_bar.max_value = MAG_SIZE


func _physics_process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	global_rotation = global_position.direction_to(mouse_pos).angle()
	scale.y = 1 if cos(rotation) > 0 else -1

	if enabled: handle_shoot()


func handle_shoot():
	if Input.is_action_just_pressed("mouse_left") and shoot_cooldown.is_stopped():
		if current_mag > 0:
			var bullet := Bullet.instantiate()
			add_child(bullet)
			bullet.global_transform = $BulletOuput.global_transform
			$ShootSound.pitch_scale = randf_range(0.8, 1.2)
			$ShootSound.play()
			shoot_cooldown.start()
			current_mag -= 1
			reload_bar.value += 1
		elif $ReloadTime.is_stopped():
			$ReloadTime.start()
			var reloader := create_tween()
			reloader.tween_property(reload_bar, "value", 0, $ReloadTime.wait_time)


func _on_reload_time_timeout() -> void:
	current_mag = MAG_SIZE


func arm(is_arm: bool):
	enabled = is_arm
	$Polygon2D.visible = is_arm
