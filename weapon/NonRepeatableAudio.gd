extends AudioStreamPlayer2D
class_name NonRepeatableAudio


func play_if_not_yet():
	if playing == true:
		return
	else:
		play()
