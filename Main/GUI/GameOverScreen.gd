extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.victory:
		$GUILayer/Label.text = "Congratulations!"
		$GUILayer/HBoxContainer/NewRunButton.text = "Continue (NG+%s)" % (GameState.ng+1)
		$VictoryMusic.play()
		SavedData.set_score(GameState.total_time)
		
	else:
		$GameOverMusic.play()
	gui_timer()
	if SavedData.get_has_finished():
		var best_time = SavedData.get_score()
		var minutes = int(best_time/60.0)
		var seconds = best_time-minutes*60
		$GUILayer/VBoxContainer/BestTimeLabel.text = "Best time(NG0): %sm%ss" % [minutes, stepify(seconds, 0.1)]
	else:
		$GUILayer/VBoxContainer/BestTimeLabel.hide()
	$GUILayer/VBoxContainer/EnemyKilledLabel.text = "Killed: %s" % GameState.enemy_killed

func gui_timer():
	var minutes = int(GameState.total_time/60.0)
	var seconds = GameState.total_time-minutes*60
	$GUILayer/VBoxContainer/RunTimeLabel.text = "Run time: %sm%ss" % [minutes, stepify(seconds, 0.1)]

func _on_NewRunButton_pressed():
	if not GameState.victory:
		GameState.reset_state()
	else:
		GameState.ng_plus()
	get_tree().change_scene("res://Main/Game.tscn")


func _on_QuitToMenuButton_pressed():
	GameState.reset_state()
	get_tree().change_scene("res://Main/GUI/BaseScreen.tscn")
