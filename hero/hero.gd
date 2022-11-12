extends CharacterBody2D


const SPEED = 300.0

enum AttackType {MELEE, RANGED}
var current_attack_type := AttackType.RANGED
@onready var combo = %ComboCounter
var combo_tween: Tween
var xp_melee := 0
var xp_ranged := 0
@onready var current_ranged := $RangedSlot.get_child(0)
@onready var current_melee := $MeleeSlot.get_child(0)


var Shotgun := preload("res://weapon/shot_gun.tscn")
var Pistol := preload("res://weapon/pistol.tscn")


var combo_counter: int:
	set(value):
		combo_counter = value
		combo.value = combo.max_value
		combo.get_node(^"Label").text = str(combo_counter)
		
		match current_attack_type:
			AttackType.MELEE:
				xp_melee += value
				$UIContainer/XPMelee.text = str(xp_melee)
			AttackType.RANGED:
				xp_ranged += value
				$UIContainer/XPRanged.text = str(xp_ranged)
		
		if value != 0:
			if combo_tween != null: combo_tween.kill()
			combo_tween = create_tween()
			combo_tween.tween_property(combo, ^"value", 0, clampf(10/combo_counter, 1.0, 10))
			combo_tween.finished.connect(func(): combo_counter = 0)
		else:
			combo.value = 0


func _ready() -> void: combo_counter = 0


func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("w", "s")
	var direction_x := Input.get_axis("a", "d")

	velocity = Vector2(direction_x, direction_y).normalized() * SPEED
	
	var mouse_pos := get_global_mouse_position()
	$RayCast2D.global_rotation = global_position.direction_to(mouse_pos).angle()
	
	switch_weapon()
		
	$Label.text = str(current_attack_type)

	move_and_slide()


func switch_weapon():
	current_attack_type = AttackType.MELEE if $RayCast2D.is_colliding() else AttackType.RANGED
	match current_attack_type:
		AttackType.MELEE:
			current_ranged.arm(false)
			current_melee.arm(true)
		AttackType.RANGED:
			current_ranged.arm(true)
			current_melee.arm(false)


func _on_zombie_notify_body_entered(body: Node2D) -> void:
	if "is_hero_visible" in body: body.is_hero_visible = true


func _on_zombie_notify_body_exited(body: Node2D) -> void:
	if "is_hero_visible" in body: body.is_hero_visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		var old_ranged = current_ranged
		current_ranged = Pistol.instantiate()
		old_ranged.queue_free()
		$RangedSlot.add_child(current_ranged)
	elif event.is_action_pressed("2"):
		var old_ranged = current_ranged
		current_ranged = Shotgun.instantiate()
		old_ranged.queue_free()
		$RangedSlot.add_child(current_ranged)
		
