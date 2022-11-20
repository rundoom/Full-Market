extends CharacterBody2D


const SPEED = 300.0

enum AttackType {MELEE, RANGED}
var current_attack_type := AttackType.RANGED
@onready var combo = %ComboCounter
var combo_tween: Tween
var xp_melee := 0
var xp_ranged := 0
@onready var animation := %AnimationPlayer as AnimationPlayer
var money := 5000:
	set(value):
		money = value
		$UIContainer/MoneyCount.text = str(value)
		
var is_shopping_avaliable := false:
	set(value):
		is_shopping_avaliable = value
		$UIContainer.is_shopping_avaliable = value
		$UIContainer/ShoppingReminder.visible = value

@onready var current_ranged := %RangedSlot.get_child(0) as Node2D
@onready var current_melee := %MeleeSlot.get_child(0)

@export var MAX_HP: int
@onready var current_hp: float:
	set(value):
		if value <= 0: get_tree().reload_current_scene()
		current_hp = value
		$UIContainer/HP.value = value

var Shotgun := preload("res://weapon/shot_gun.tscn")
var Pistol := preload("res://weapon/pistol.tscn")
var AssaultRifle := preload("res://weapon/assault_rifle.tscn")
var Minigun := preload("res://weapon/minigun.tscn")

var weapon_upgrades := {
	"Pistol" : {"scene": Pistol, "cost": 0, "next": "AssaultRifle"},
	"AssaultRifle" : {"scene": AssaultRifle, "cost": 100, "next": "Shotgun"},
	"Shotgun" : {"scene": Shotgun, "cost": 300, "next": "Minigun"},
	"Minigun" : {"scene": Minigun, "cost": 1000, "next": null}
}

var combo_counter: int:
	set(value):
		combo_counter = value
		update_combo(value)


func _ready() -> void:
	combo_counter = 0
	current_hp = MAX_HP
	money = money

func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("w", "s")
	var direction_x := Input.get_axis("a", "d")

	velocity = Vector2(direction_x, direction_y).normalized() * SPEED
	
	var mouse_pos := get_global_mouse_position()
	%MeleeDetector.global_rotation = global_position.direction_to(mouse_pos).angle()
	
	switch_weapon()

	move_and_slide()
	
	if get_real_velocity() == Vector2.ZERO:
		animation.current_animation = "stand"
	else:
		animation.current_animation = "run"
			
	var angle_to_mouse = global_position.direction_to(mouse_pos).angle()
	$Rotator.scale.x = 1 if cos(angle_to_mouse) > 0 else -1
		
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider() as Node2D
		if collider.is_in_group("zombie"):
			current_hp -= 0.5
		

func switch_weapon():
	current_attack_type = AttackType.MELEE if %MeleeDetector.is_colliding() else AttackType.RANGED
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


func upgrade_weapon():
	var old_ranged = current_ranged
	var current_entity = weapon_upgrades[old_ranged.name]
	var next_entity = weapon_upgrades[current_entity["next"]]
	if money >= next_entity["cost"]:
		money -= next_entity["cost"]
		current_ranged = next_entity["scene"].instantiate()
		old_ranged.queue_free()
		%RangedSlot.add_child(current_ranged)
		var yet_next_entity = weapon_upgrades.get(next_entity["next"])
		if yet_next_entity != null:
			$UIContainer/Shopping/UpgradeWeapon.text = "Buy " + next_entity["next"] + " for " + str(yet_next_entity["cost"]) + "$"
		else:
			$UIContainer/Shopping/UpgradeWeapon.text = "Maximum upgrade reached!"
			$UIContainer/Shopping/UpgradeWeapon.disabled = true


func update_combo(value: int):
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


func _on_zombie_charge_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		var margin_tween := create_tween()
		margin_tween.tween_property(body, "safe_margin", 0, 0.5)


func _on_zombie_charge_body_exited(body: Node2D) -> void:
		if body.is_in_group("zombie"):
			var margin_tween := create_tween()
			margin_tween.tween_property(body, "safe_margin", 20, 1)


func _on_collector_body_entered(body: Node2D) -> void:
	body.queue_free()
	money += 1


func _on_heal_button_pressed() -> void:
	if money >= 20 and current_hp < MAX_HP:
		current_hp = MAX_HP
		money -= 20
	
