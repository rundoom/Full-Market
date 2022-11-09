extends CharacterBody2D


const SPEED = 300.0

enum AttackType {MELEE, RANGED}
var current_attack_type := AttackType.RANGED
@onready var combo = %ComboCounter
var combo_tween: Tween

var combo_counter: int:
	set(value):
		combo_counter = value
		combo.value = combo.max_value
		combo.get_node(^"Label").text = str(combo_counter)
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
			$Ranged.visible = false
			$Ranged.set_physics_process(false)
			$Melee.visible = true
			$Melee.set_physics_process(true)
		AttackType.RANGED:
			$Ranged.visible = true
			$Ranged.set_physics_process(true)
			$Melee.visible = false
			$Melee.set_physics_process(false)
