extends Node2D
class_name BasicRanged 


const Bullet := preload("res://weapon/bullet.tscn")
@onready var shoot_cooldown := $ShootCooldown as Timer
@export_range(0, PI, 0.1) var SPREAD : float
@export var BULLET_COUNT := 1
@export var BULLET_SPEED_SPRED := 0

@export var MAG_SIZE : int
@onready var current_mag := MAG_SIZE

@export var AUTOMATIC : bool :
	set(value):
		AUTOMATIC = value
		_decide_firemod(value)
		
var INPUT_ACTION := func() -> bool: return Input.is_action_just_pressed("mouse_left")

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
	if INPUT_ACTION.call():
		if current_mag > 0 and shoot_cooldown.is_stopped():
			var bullet_direction := $BulletOuput.global_rotation as float
			for i in BULLET_COUNT:
				var bullet := Bullet.instantiate()
				bullet.speed = randi_range(bullet.speed - BULLET_SPEED_SPRED, bullet.speed + BULLET_SPEED_SPRED) 
				bullet.global_position = $BulletOuput.global_position
				bullet.global_rotation = (randf_range(bullet_direction - SPREAD, bullet_direction + SPREAD) + randf_range(bullet_direction - SPREAD, bullet_direction + SPREAD)) / 2
				add_child(bullet)
			$ShootSound.pitch_scale = randf_range(0.8, 1.2)
			$ShootSound.play()
			shoot_cooldown.start()
			current_mag -= 1
			reload_bar.value += 1
		elif $ReloadTime.is_stopped() and current_mag <= 0:
			$ReloadTime.start()
			var reloader := create_tween()
			reloader.tween_property(reload_bar, "value", 0, $ReloadTime.wait_time)


func _on_reload_time_timeout() -> void:
	current_mag = MAG_SIZE


func arm(is_arm: bool):
	enabled = is_arm
	$Sprite2D.visible = is_arm


func _decide_firemod(is_automatic: bool):
		if is_automatic == true:
			INPUT_ACTION = func() -> bool: return Input.is_action_pressed("mouse_left")
		else:
			INPUT_ACTION = func() -> bool: return Input.is_action_just_pressed("mouse_left")
	
