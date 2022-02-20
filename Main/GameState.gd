extends Node

var gold = 0
var current_level_id = 0
var total_time = 0
var current_player_state = new_player_state()
var enemy_killed = 0
var ng = 0
var victory = false


func ng_plus():
	ng += 1
	victory = false
	current_level_id = 0

func new_player_state():
	return PlayerState.new()


func reset_state():
	current_level_id = 0
	total_time = 0
	gold = 0
	ng = 0
	victory = false
	enemy_killed = 0
	current_player_state = new_player_state()

func is_last_level():
	return current_level_id == len(LevelConfig.levels)-1
