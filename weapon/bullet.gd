extends AnimatableBody2D


var speed := 1000
@onready var spare := $SpareBullet as RigidBody2D
var velocity := Vector2.ZERO


func _ready() -> void:
	$BigSparcle.emitting = true
	$SmallSparcle.emitting = true


func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	var collision = move_and_collide(velocity * delta)
	if collision != null: queue_free()


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_tree_exiting() -> void:
	var level = get_tree().get_first_node_in_group("level")
	remove_child(spare)
	level.add_child(spare)
	spare.global_transform = global_transform
	spare.linear_velocity.x = -velocity.x / 2
	spare.start_acting()
	
