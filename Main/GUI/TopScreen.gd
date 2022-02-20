extends MarginContainer

signal GoSettings


func _on_StartGame_pressed():
	GameState.reset_state()
	get_tree().change_scene("res://Main/Game.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	emit_signal("GoSettings")
