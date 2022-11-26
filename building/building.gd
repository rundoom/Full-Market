extends StaticBody2D


func _ready() -> void:
	$Sprite2D.frame = randi_range(0, $Sprite2D.hframes - 1)

