extends CanvasLayer


var is_shopping_avaliable := false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		$Paused.visible = get_tree().paused
		if get_tree().paused: $ShoppingReminder.visible = false
		if !get_tree().paused:
			if is_shopping_avaliable: $ShoppingReminder.visible = true
			$Shopping.visible = false
	if event.is_action_pressed("interaction") and is_shopping_avaliable:
		get_tree().paused = true
		$Shopping.visible = true
		$ShoppingReminder.visible = false
