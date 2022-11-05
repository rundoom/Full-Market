extends CharacterBody2D


const SPEED = 300.0

enum AttackType {MELEE, RANGED}
var current_attack_type := AttackType.RANGED


func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("w", "s")
	var direction_x := Input.get_axis("a", "d")

	velocity = Vector2(direction_x, direction_y).normalized() * SPEED
	
	var mouse_pos := get_global_mouse_position()
	$RayCast2D.global_rotation = global_position.direction_to(mouse_pos).angle()
	
	current_attack_type = AttackType.MELEE if $RayCast2D.is_colliding() else AttackType.RANGED
	if current_attack_type == AttackType.MELEE:
		$Ranged.visible = false
		$Ranged.set_physics_process(false)
		$Melee.visible = true
		$Melee.set_physics_process(true)
	elif current_attack_type == AttackType.RANGED:
		$Ranged.visible = true
		$Ranged.set_physics_process(true)
		$Melee.visible = false
		$Melee.set_physics_process(false)
		
	$Label.text = str(current_attack_type)

	move_and_slide()
