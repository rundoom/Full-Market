extends Node2D


var Level = preload("res://production/level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(Level)
